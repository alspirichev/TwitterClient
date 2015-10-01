//
//  ASTweetsViewController.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 18.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>

@interface ASTweetsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithHomeTimeline;
- (id)initWithMentionsTimeline;

@end
