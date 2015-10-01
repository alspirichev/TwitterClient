//
//  ASServerManager.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 17.09.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ASServerManager.h"
#import "ASTweet.h"

NSString * const kTwitterConsumerKey =      @"CI6vxpjM68kMGOM2iKNRGAtaK";
NSString * const kTwitterConsumerSecret =   @"8jmQNNse1Hdg8Vu1tam5fXJFJa6I13Tv21NmG2B64Q1SAnDmTi";
NSString * const kTwitterBaseUrl =          @"https://api.twitter.com";

@interface ASServerManager ()

@property (nonatomic, strong) void (^loginCompletion)(ASUser *, NSError *);

@end

@implementation ASServerManager

+ (ASServerManager*) sharedManager {
    
    static ASServerManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[ASServerManager alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]
                                                    consumerKey:kTwitterConsumerKey
                                                 consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(ASUser *, NSError *))completion
{
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"alspirichev://oauth"]
                              scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSLog(@"got the request token");
                                
                                NSURL *authURL =
                                [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                                                                                                                                requestToken.token]];
                                [[UIApplication sharedApplication] openURL:authURL];
                                
                            } failure:^(NSError *error) {
                                NSLog(@"failed to get request token");
                                NSLog(@"Error: %@", error.localizedDescription);
                                self.loginCompletion(nil, error);
                            }];
}

- (void)openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
                           success:^(BDBOAuth1Credential *accessToken) {
                               
        NSLog(@"got the access token!");
                               
        [self.requestSerializer saveAccessToken:accessToken];
                               
        [self GET:@"1.1/account/verify_credentials.json"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
            NSLog(@"current user (JSON): %@", responseObject);
              
            ASUser *user = [[ASUser alloc] initWithDictionary:responseObject];
            [ASUser setCurrentUser:user];
              
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
            NSLog(@"Error: %@", error.localizedDescription);
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token!");
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

#pragma mark - API Requests

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *, NSError *))completion
{
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
        NSMutableArray *tweets = [ASTweet tweetsWithArray:responseObject];
        completion(tweets, nil);
          
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error.localizedDescription);
        completion(nil, error);
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *, NSError *))completion
{
    [self GET:@"1.1/statuses/mentions_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
        NSMutableArray *tweets = [ASTweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        completion(nil, error);
    }];
}

-(void) userTimelineWithParams:(NSDictionary* )params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion
{
    [self GET:@"1.1/statuses/user_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *tweets = [ASTweet tweetsWithArray:responseObject];
          completion(tweets, nil);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error.localizedDescription);
          completion(nil, error);
      }];
}

@end
