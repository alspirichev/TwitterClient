//
//  ASTweetsViewController.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 18.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASTweetsViewController.h"
#import "ASComposeTweetController.h"

#import "ASServerManager.h"
#import "ASTweetCell.h"

#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>

@interface ASTweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;

@end

@implementation ASTweetsViewController

#pragma mark - Initialization

- (id)initWithHomeTimeline {
    self = [super self];
    if (self) {
        [[ASServerManager sharedManager] homeTimelineWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
        self.title = @"Home";
    }
    return self;
}

- (id)initWithMentionsTimeline {
    self = [super self];
    if (self) {
        [[ASServerManager sharedManager] mentionsTimelineWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
            if (!tweets) {
                self.tweets = tweets;
                [self.tableView reloadData];
            }
        }];
        self.title = @"Mentions";
    }
    return self;
}

#pragma mark - View Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ASTweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationItem.title = self.title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Menu"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(presentLeftMenuViewController:)];


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                    target:self
                                                                    action:@selector(onCompose)];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self onRefresh];
        [self.tableView.pullToRefreshView stopAnimating];
    }];

    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self onInfiniteScroll];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark -  Actions

- (void)onCompose
{
    ASComposeTweetController *ctc = [[ASComposeTweetController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRefresh
{
    
    ASTweet* newestTweet = self.tweets[0];
    NSDictionary *params = [NSDictionary dictionaryWithObject:@(newestTweet.tweetId) forKey:@"since_id"];
    
    [[ASServerManager sharedManager] homeTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets && tweets.count > 0) {
            
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tweets.count)];
            [self.tweets insertObjects:tweets atIndexes:indexes];
            [self.tableView reloadData];
        }
    }];
}

- (void)onInfiniteScroll
{
    ASTweet *oldestTweet = self.tweets[self.tweets.count - 1];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:@(oldestTweet.tweetId - 1) forKey:@"max_id"];
    
    if ([self.title isEqualToString:@"Home"]) {
        [[ASServerManager sharedManager] homeTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
            if (tweets && tweets.count > 0) {
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    } else {
        
        [[ASServerManager sharedManager] mentionsTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
            if (tweets && tweets.count > 0) {
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    
}

#pragma mark - UITableViewDataSource Mathods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASTweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
