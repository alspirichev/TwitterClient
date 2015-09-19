//
//  ASTweetsViewController.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 18.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASTweetsViewController.h"
#import "ASServerManager.h"
#import "ASTweetCell.h"

@interface ASTweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;

@end

@implementation ASTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ASTweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title = self.title;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
        self.title = @"Mentions";
    }
    return self;
}

#pragma mark - UITableViewDataSource Mathods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASTweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
