//
//  ViewController.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 29.08.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "ViewController.h"
#import <STTwitter/STTwitter.h>
#import "ASFollowing.h"

static NSString* consumerKey = @"Zws3ybpPzgbDDlPlDYkNWZc4p";
static NSString* consumerSecret = @"eHuQ6nyqiOrtL5nw48dTyVFxDMl3b7eljCpkqdRpNxMfC51M04";

@interface ViewController ()

@property ASFollowing* following;

@end

@implementation ViewController

@synthesize managedObjectContext        = _managedObjectContext;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;
@synthesize fetchedResultsController    = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // [self obtainABearerToken];
    
    STTwitterAPI* twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:consumerKey
                                                            consumerSecret:consumerSecret];
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        /*
         [twitter getUserTimelineWithScreenName:@"alspirichev" successBlock:^(NSArray *statuses) {
         
         self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
         [self.tableView reloadData];
         
         } errorBlock:^(NSError *error) {
         NSLog(@"%@", error.debugDescription);
         }];   */
        /*
         [twitter getTrendsForWOEID:@"2346910" excludeHashtags:nil successBlock:^(NSDate *asOf, NSDate *createdAt, NSArray *locations, NSArray *trends) {
         self.twitterFeed = [NSMutableArray arrayWithArray:trends];
         [self.tableView reloadData];
         
         } errorBlock:^(NSError *error) {
         NSLog(@"Error: %@", error.debugDescription);
         }]; */
        /*
         [twitter getFollowersForScreenName:@"alspirichev" successBlock:^(NSArray *followers) {
         
         self.twitterFeed = [NSMutableArray arrayWithArray:followers];
         [self.tableView reloadData];
         
         } errorBlock:^(NSError *error) {
         NSLog(@"Error: %@", error.debugDescription);
         }];
         */
        
        [twitter getFriendsForScreenName:@"alspirichev" successBlock:^(NSArray *friends) {
            self.twitterFeed = [NSMutableArray arrayWithArray:friends];
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error.debugDescription);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.debugDescription);
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self printDB];
}

/*
 -(NSString*) bearerTokenBase64Credentials
 {
 NSString* bearerToken = [NSString stringWithFormat:@"%@:%@", consumerKey, consumerSecret];
 NSData* data = [bearerToken dataUsingEncoding:NSUTF8StringEncoding];
 NSString* bearerTokenBase64 = [data base64EncodedString];
 
 NSLog(@"bearerTokenBase64: %@", bearerTokenBase64);
 
 return bearerTokenBase64;
 }
 
 -(void) obtainABearerToken
 {
 AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
 manager.responseSerializer = [AFJSONResponseSerializer serializer];
 
 [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [self bearerTokenBase64Credentials]]
 forHTTPHeaderField:@"Authorization"];
 
 [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8"
 forHTTPHeaderField:@"Content-Type"];
 
 
 [manager POST:@"https://api.twitter.com/oauth2/token"
 parameters:@{@"grant_type":@"client_credentials"}
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"Success");
 }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Fail");
 }];
 
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ASFollowing"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* nameDescription =
    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[nameDescription]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
}


-(void) saveInfoAboutFollowingWithName:(NSString*) name profileImage:(NSData*) image andFollowingCount:(NSNumber*) followingCount
{
    
    self.following = [NSEntityDescription insertNewObjectForEntityForName:@"ASFollowing"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [self.following setValue:name forKey:@"name"];
    [self.following setValue:image forKey:@"profileImage"];
    [self.following setValue:followingCount forKey:@"followersCount"];
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void) printDB
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ASFollowing"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    NSLog(@"!!!!!!!!!!!!! BEGIN !!!!!!!!!!!!");
    
    for (ASFollowing* object in resultArray) {
        ASFollowing* following = (ASFollowing*) object;
        
        NSLog(@"Name: %@ Followers count: %@", following.name, following.followersCount);
    }
    NSLog(@"!!!!!!!!!!!!! END !!!!!!!!!!!!!!");
    
}

- (void) deleteAllObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ASFollowing"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    for (id object in resultArray) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.twitterFeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    
    // UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSDictionary* JSONresponse = self.twitterFeed[indexPath.row];
    
    // Name
    
    NSString* name = [NSString stringWithFormat:@"%@", JSONresponse[@"screen_name"]];
    
    cell.textLabel.text = name;
    
    // Image
    
    NSURL* url = [NSURL URLWithString:[JSONresponse objectForKey:@"profile_image_url"]];
    NSData* image = [NSData dataWithContentsOfURL:url];
    
    cell.tag = indexPath.row;
    
    if (JSONresponse)
     {
        cell.imageView.image = [UIImage imageNamed:@"user.png"];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell.tag == indexPath.row) {
                        cell.imageView.image = image;
                        [cell setNeedsLayout];
                    }
                });
            }
        });
     }
    
    // Followers count
    
    NSString* numberFollowing = [NSString stringWithFormat:@"%@", JSONresponse[@"followers_count"]];
    NSNumber* followingCount = [NSNumber numberWithInt:[numberFollowing intValue]];
    
    cell.detailTextLabel.text = numberFollowing;
    
    //[self saveInfoAboutFollowingWithName:name profileImage:image andFollowingCount:followingCount];
    
    // [self deleteAllObjects];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TopTrendsModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataTest.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end