//
//  ASProfileViewController.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 26.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "ASUser.h"

@interface ASProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithUser:(ASUser *)user;

@end
