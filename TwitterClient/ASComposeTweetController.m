//
//  ASComposeTweetController.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 29.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASComposeTweetController.h"

@interface ASComposeTweetController ()

@end

@implementation ASComposeTweetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[[UIColor alloc] initWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                  target:self
                                                                  action:@selector(onCancelButton)];
    
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
