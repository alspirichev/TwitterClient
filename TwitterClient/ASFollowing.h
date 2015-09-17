//
//  ASFollowing.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 29.08.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ASFollowing : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSString * profileImage;

@end
