//
//  ASUser.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASUser.h"
#import "ASServerManager.h"

@interface ASUser()

@property (strong, nonatomic) NSDictionary* dictionary;

@end

@implementation ASUser

static ASUser* _currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (ASUser *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[ASUser alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(ASUser*)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        self.profileBackgroundImageUrl = dictionary[@"profile_banner_url"];
        self.numberTweets = [dictionary[@"statuses_count"] integerValue];
        self.numberFollowers = [dictionary[@"followers_count"] integerValue];
        self.numberFollowing = [dictionary[@"friends_count"] integerValue];
    }
    return self;
}

@end
