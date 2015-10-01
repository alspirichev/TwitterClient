//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 29.08.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "AppDelegate.h"
#import "ASLoginViewController.h"
#import "ASTweetsViewController.h"
#import "ASServerManager.h"
#import "ASUser.h"

#import "ASLeftMenuViewController.h"
#import "ASRightMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogout)
                                                 name:UserDidLogoutNotification
                                               object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIColor* tintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0];
    
    UINavigationController *nvc = nil;
    RESideMenu *sideMenuViewController = nil;
    
    ASUser *user = [ASUser currentUser];
    
    if (user != nil) {
        NSLog(@"Welcome %@", user.name);
        
        ASTweetsViewController *tvc = [[ASTweetsViewController alloc] initWithHomeTimeline];
        nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
        
        ASLeftMenuViewController *leftMenuViewController = [[ASLeftMenuViewController alloc] init];
        ASRightMenuViewController *rightMenuViewController = [[ASRightMenuViewController alloc] init];
        
        sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:nvc
                                                            leftMenuViewController:leftMenuViewController
                                                           rightMenuViewController:rightMenuViewController];
        
        // setup Side Menu
        
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
        sideMenuViewController.contentViewShadowColor = tintColor;
        sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
        sideMenuViewController.contentViewShadowOpacity = 0.6;
        sideMenuViewController.contentViewShadowRadius = 100;
        sideMenuViewController.contentViewShadowEnabled = YES;
        
        self.window.rootViewController = sideMenuViewController;

    } else {
        NSLog(@"Not logged in");
        
        ASLoginViewController *lvc = [[ASLoginViewController alloc] init];
        self.window.rootViewController = lvc;
    }
    
    [self.window makeKeyAndVisible];
    
    // setup Navigation Bar
    
    [[UINavigationBar appearance] setBarTintColor:tintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)userDidLogout {
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ self.window.rootViewController = [[ASLoginViewController alloc] init]; }
                    completion:nil];
}

#pragma mark - AppDelegate Methods

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[ASServerManager sharedManager] openURL:url];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end