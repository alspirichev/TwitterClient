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

#include <RESideMenu.h>
#import "ASLeftMenuViewController.h"
#import "ASRightMenuViewController.h"

@implementation ASLoginViewController

#pragma mark - View Controller life style

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)onLogin:(id)sender
{
    [[ASServerManager sharedManager] loginWithCompletion:^(ASUser *user, NSError *error) {
        if (user != nil) {
            
            NSLog(@"Welcome to %@", user.name);
            
            ASLeftMenuViewController *leftMenuViewController = [[ASLeftMenuViewController alloc] init];
            ASRightMenuViewController *rightMenuViewController = [[ASRightMenuViewController alloc] init];
            
            ASTweetsViewController *tvc = [[ASTweetsViewController alloc] initWithHomeTimeline];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
            
            RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:nvc
                                                                            leftMenuViewController:leftMenuViewController
                                                                           rightMenuViewController:rightMenuViewController];
            // setup Side Menu
            
            sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
            sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
            sideMenuViewController.contentViewShadowColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0];
            sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
            sideMenuViewController.contentViewShadowOpacity = 0.6;
            sideMenuViewController.contentViewShadowRadius = 100;
            sideMenuViewController.contentViewShadowEnabled = YES;
            
            [self presentViewController:sideMenuViewController animated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

@end
