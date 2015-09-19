//
//  ASLoginViewController.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASLoginViewController.h"
#import "ASServerManager.h"
#import "ASTweetsViewController.h"

@implementation ASLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)onLogin:(id)sender
{
    [[ASServerManager sharedManager] loginWithCompletion:^(ASUser *user, NSError *error) {
        if (user != nil) {

            NSLog(@"welcome to %@", user.name);
            
            ASTweetsViewController *tvc = [[ASTweetsViewController alloc] initWithHomeTimeline];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
            [self presentViewController:nvc animated:YES completion:nil];
        } else {
            NSLog(@"Error!");
        }
    }];
}

@end
