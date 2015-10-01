//
//  ASProfileHeaderCell.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 26.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASUser.h"

@interface ASProfileHeaderCell : UITableViewCell

@property (nonatomic, strong) ASUser *user;

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *numberTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;

@end
