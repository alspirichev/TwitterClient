//
//  ASTweet.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASUser.h"

@interface ASTweet : NSObject

@property (nonatomic, strong) ASUser*       user;

@property (nonatomic, strong) NSString*     text;
@property (nonatomic, strong) NSDate*       createdAt;
@property (nonatomic, assign) NSInteger     tweetId;
@property (nonatomic, assign) NSInteger     retweetsCount;
@property (nonatomic, assign) BOOL          retweeted;
@property (nonatomic, assign) NSInteger     favoritesCount;
@property (nonatomic, assign) BOOL          favorited;
@property (nonatomic, assign) NSInteger     retweetId;
@property (nonatomic, strong) NSString*     retweetedScreenname;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
