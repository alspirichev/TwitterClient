//
//  ASTweetCell.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 18.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASTweetCell.h"
#import "ASUser.h"
#import <UIImageView+AFNetworking.h>
#import <DateTools.h>

@implementation ASTweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setTweet:(ASTweet *)tweet
{
    _tweet = tweet;
    
    ASUser* user = tweet.user;
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetLabel.text = tweet.text;
    
    [self setRetweetsNumber];
    [self setFavoritesCount];
    self.favoritesButton.selected = tweet.favorited;
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:tweet.createdAt.timeIntervalSinceNow];
    self.dateTweetLabel.text = timeAgoDate.shortTimeAgoSinceNow;
}

- (void)setRetweetsNumber
{
    NSInteger numRetweets = self.tweet.retweetsCount;
    if (numRetweets > 0) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%zd", numRetweets];
    } else {
        self.retweetLabel.text = @"";
    }
}

-(void) setFavoritesCount
{
    NSInteger numFavorites = self.tweet.favoritesCount;
    if (numFavorites > 0) {
        self.favoritesLabel.text = [NSString stringWithFormat:@"%zd", numFavorites];
    } else {
        self.favoritesLabel.text = @"";
    }
}

@end
