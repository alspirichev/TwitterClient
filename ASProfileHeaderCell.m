//
//  ASProfileHeaderCell.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 26.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASProfileHeaderCell.h"
#include <UIImageView+AFNetworking.h>

@implementation ASProfileHeaderCell

- (void)awakeFromNib
{
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
    [self.thumbImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.thumbImageView.layer setBorderWidth:2.0];
}


- (void)setUser:(ASUser *)user
{
    _user = user;
    
    user.profileImageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    
    self.userName.text = user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", user.screenName];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.numberTweetsLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:user.numberTweets]];
    self.numberFollowingLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:user.numberFollowing]];
    self.numberFollowersLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:user.numberFollowers]];
}
@end
