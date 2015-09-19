//
//  ASTweet.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASTweet.h"

@implementation ASTweet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.user = [[ASUser alloc] initWithDictionary:dictionary[@"user"]];
        
        self.text = dictionary[@"text"];
        self.tweetId = [dictionary[@"id"] integerValue];
        self.retweetsCount = [dictionary[@"retweet_count"] integerValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favoritesCount = [dictionary[@"favorite_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        
        NSDictionary *retweetedStatus = dictionary[@"retweeted_status"];
        if (retweetedStatus) {
            self.retweetedScreenname = retweetedStatus[@"user"][@"screen_name"];
        } else {
            self.retweetedScreenname = @"";
        }
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
    }
    
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array
{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[ASTweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}


@end
