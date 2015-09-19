//
//  ASTweetCell.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 18.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTweet.h"

@interface ASTweetCell : UITableViewCell

@property (nonatomic, strong) ASTweet * tweet;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@end
