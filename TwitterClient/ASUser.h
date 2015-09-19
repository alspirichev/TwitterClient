//
//  ASUser.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;

@interface ASUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic, assign) NSInteger numberTweets;
@property (nonatomic, assign) NSInteger numberFollowers;
@property (nonatomic, assign) NSInteger numberFollowing;

+ (ASUser *)currentUser;
+ (void)setCurrentUser:(ASUser*)currentUser;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
