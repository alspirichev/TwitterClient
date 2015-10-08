//
//  ASComposeTweetController.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 29.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ASTweet.h"

@class ASComposeTweetController;

@protocol ASComposeTweetControllerDelegate <NSObject>

@optional

- (void)composeTweetController:(ASComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet;
- (void)composeTweetController:(ASComposeTweetController *)composeTweetController
                  didSendTweet:(NSString *)tweet inReplyToStatusId:(NSInteger)statusId;

@end

@interface ASComposeTweetController : UIViewController

@property (nonatomic, weak) id<ASComposeTweetControllerDelegate> delegate;
@property (nonatomic, strong) ASTweet *replyToTweet;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderText;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) UILabel *charCountLabel;
@property (weak, nonatomic) UIButton *sendTweetButton;

@end
