//
//  ASTweetCell.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 18.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASTweetCell.h"
#import "ASUser.h"
#import "ASServerManager.h"

#import <UIImageView+AFNetworking.h>
#import <DateTools.h>

@implementation ASTweetCell

- (void)awakeFromNib {
    
    self.profileImage.layer.cornerRadius = 3;
    self.profileImage.clipsToBounds = YES;
    
    [self.favoritesButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateSelected];
    
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap)];
    [self.profileImage addGestureRecognizer:profileTap];
    self.profileImage.userInteractionEnabled = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setTweet:(ASTweet *)tweet
{
    _tweet = tweet;
    
    ASUser *user = tweet.user;
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetLabel.text = tweet.text;
    
    [self setRetweetsNumber];
    self.retweetButton.selected = tweet.retweeted;
    
    [self setFavoritesCount];
    self.favoritesButton.selected = tweet.favorited;
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:tweet.createdAt.timeIntervalSinceNow];
    self.dateTweetLabel.text = timeAgoDate.shortTimeAgoSinceNow;
}

#pragma mark - Actions

- (void)onProfileTap
{
    [self.delegate tweetCell:self didTapUser:self.tweet.user];
}

- (IBAction)onReply:(id)sender
{
    [self.delegate tweetCell:self didReplyToTweet:self.tweet];
}

- (IBAction)onRetweet:(id)sender
{
    if (self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.retweetButton.selected = NO;
        self.tweet.retweetsCount -= 1;
        [[ASServerManager sharedManager] unRetweetTweet:self.tweet.retweetId completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
                self.tweet.retweetId = -1;
                self.tweet.retweeted = NO;
            }
        }];
    } else {
        
        self.tweet.retweeted = YES;
        self.retweetButton.selected = YES;
        self.tweet.retweetsCount += 1;
        [[ASServerManager sharedManager] retweetTweet:self.tweet.tweetId completion:^(NSInteger retweetId, NSError *error) {
            self.tweet.retweetId = retweetId;
            self.tweet.retweeted = YES;
        }];
    }
    [self setRetweetsNumber];
}

- (IBAction)onFavotite:(id)sender
{
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.favoritesButton.selected = NO;
        self.tweet.favoritesCount -= 1;
        [[ASServerManager sharedManager] unfavoriteTweet:self.tweet.tweetId];
    } else {
        self.tweet.favorited = YES;
        self.favoritesButton.selected = YES;
        self.tweet.favoritesCount += 1;
        [[ASServerManager sharedManager] favoriteTweet:self.tweet.tweetId];
    }
    [self setFavoritesCount];
}

- (void)setFavoritesCount
{
    NSInteger numFavorites = self.tweet.favoritesCount;
    if (numFavorites > 0) {
        self.favoritesLabel.text = [@(numFavorites) stringValue];
    } else {
        self.favoritesLabel.text = @"";
    }
}

- (void)setRetweetsNumber
{
    NSInteger numRetweets = self.tweet.retweetsCount;
    if (numRetweets > 0) {
        self.retweetLabel.text = [@(numRetweets) stringValue];
    } else {
        self.retweetLabel.text = @"";
    }
}

@end
