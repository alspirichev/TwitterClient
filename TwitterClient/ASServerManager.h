//
//  ASServerManager.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASTweet.h"
#import "BDBOAuth1RequestOperationManager.h"
#import "ASUser.h"

@interface ASServerManager : BDBOAuth1RequestOperationManager

+ (ASServerManager*) sharedManager;

- (void)loginWithCompletion:(void (^)(ASUser *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *, NSError *))completion;

-(void) userTimelineWithParams:(NSDictionary* )params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
- (void)createTweetWithTweet:(NSString *)tweet params:(NSDictionary *)params completion:(void (^)(ASTweet *tweet, NSError *error))completion;

// work with tweet

- (void)favoriteTweet:(NSInteger)tweetId;
- (void)unfavoriteTweet:(NSInteger)tweetId;

- (void)retweetTweet:(NSInteger)tweetId completion:(void (^)(NSInteger retweetId, NSError *error))completion;
- (void)unRetweetTweet:(NSInteger)tweetId completion:(void (^)(NSError *error))completion;


@end
