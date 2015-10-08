//
//  ASProfileViewController.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 26.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASProfileViewController.h"
#import "ASComposeTweetController.h"
#import "ASServerManager.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#include <UIImageView+AFNetworking.h>

#include <RESideMenu.h>
#include "ASLeftMenuViewController.h"

#include "ASProfileHeaderCell.h"
#include "ASTweetCell.h"

const NSInteger kHeaderHeight = 140;

@interface ASProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
                                                                ASComposeTweetControllerDelegate, ASTweetCellDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) ASUser *user;
@property (strong, nonatomic) UIImageView *headerImage;

@end

@implementation ASProfileViewController

#pragma mark - Initializing

- (id)initWithUser:(ASUser *)user
{
    self = [super init];
    if (self) {
        NSDictionary *params = @{@"screen_name" : user.screenName};
        [[ASServerManager sharedManager] userTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
        self.user = user;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ASProfileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProfileHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ASTweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // setup nav bar
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title = self.user.name;

    if (self.user == [ASUser currentUser]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                              target:self
                                                                                              action:@selector(onMenu)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self
                                                                                           action:@selector(onCompose)];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self onInfiniteScroll];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, self.tableView.frame.size.width, kHeaderHeight)];
    [headerImage setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageUrl]];
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.headerImage = headerImage;
    [self.tableView insertSubview:headerImage atIndex:0];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kHeaderHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onInfiniteScroll
{
    ASTweet* oldestTweet = self.tweets[self.tweets.count - 1];
    
    NSDictionary *params = @{@"max_id" : @(oldestTweet.tweetId - 1),
                             @"screen_name" : self.user.screenName};
    [[ASServerManager sharedManager] userTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets && tweets.count > 0) {
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - Actions

-(void) onMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];    
}

- (void)updateHeaderView
{
    CGRect headerRect = CGRectMake(0, -kHeaderHeight, self.tableView.bounds.size.width, kHeaderHeight);
    if (self.tableView.contentOffset.y < -kHeaderHeight) {
        headerRect.origin.y = self.tableView.contentOffset.y;
        headerRect.size.height = - self.tableView.contentOffset.y;
    }
    
    self.headerImage.frame = headerRect;
}

- (void)onCompose
{
    ASComposeTweetController *ctc = [[ASComposeTweetController alloc] init];
    ctc.delegate = self;
    ctc.replyToTweet = nil;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateHeaderView];
}

#pragma mark - ASTweetCellDelegate Methods

- (void)tweetCell:(ASTweetCell *)cell didReplyToTweet:(ASTweet *)tweet
{
    ASComposeTweetController *ctc = [[ASComposeTweetController alloc] init];
    ctc.replyToTweet = tweet;
    ctc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)tweetCell:(ASTweetCell *)cell didTapUser:(ASUser *)user
{
    if (![user.screenName isEqualToString: self.user.screenName]) {
        ASProfileViewController *pvc = [[ASProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

#pragma mark - ASComposeTweetControllerDelegate Methods

- (void)composeTweetController:(ASComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet
{
    [[ASServerManager sharedManager] createTweetWithTweet:tweet
                                                   params:nil
                                               completion:^(ASTweet *tweet, NSError *error) {
                                                   if (error == nil) {
                                                       [self.tweets insertObject:tweet atIndex:0];
                                                       [self.tableView reloadData];
                                                   } else {
                                                       NSLog(@"%@", error.localizedDescription);
                                                   }
                                               }];
}

- (void)composeTweetController:(ASComposeTweetController *)composeTweetController
                  didSendTweet:(NSString *)tweet inReplyToStatusId:(NSInteger)statusId
{
    NSDictionary *params = @{@"in_reply_to_status_id" : @(statusId)};

    [[ASServerManager sharedManager] createTweetWithTweet:tweet
                                                   params:params
                                               completion:^(ASTweet *tweet, NSError *error) {
                                                   if (error == nil) {
                                                       [self.tweets insertObject:tweet atIndex:0];
                                                       [self.tableView reloadData];
                                                   } else {
                                                       NSLog(@"%@", error.localizedDescription);
                                                   }
                                               }];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASProfileHeaderCell *profileHeaderCell;
    ASTweetCell *cell;
    
    switch (indexPath.row) {
        case 0:
            profileHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderCell" forIndexPath:indexPath];
            profileHeaderCell.user = self.user;
                        
            return profileHeaderCell;
        default:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
            cell.tweet = self.tweets[indexPath.row - 1];
            cell.delegate = self;
            return cell;
    }
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
