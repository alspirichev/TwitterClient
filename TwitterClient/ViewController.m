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
#import <AFNetworking/AFHTTPRequestOperationManager.h>

static NSString* consumerKey = @"CI6vxpjM68kMGOM2iKNRGAtaK";
static NSString* consumerSecret = @"8jmQNNse1Hdg8Vu1tam5fXJFJa6I13Tv21NmG2B64Q1SAnDmTi";

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext        = _managedObjectContext;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;
@synthesize fetchedResultsController    = _fetchedResultsController;

#pragma mark - View life cycle

- (void)viewDidLoad {
    /*
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    STTwitterAPI* twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:consumerKey
                                                            consumerSecret:consumerSecret];
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [twitter setUserID:[NSString stringWithFormat:@"3419763023"]];
        
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
     */
    [self obtainABearerToken];
}

/*
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
        [[ASServerManager sharedManager] authorizeUser:^(ASUser *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"USER: %@", user.firstName);
        }];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Application-only authentication

-(NSString*) bearerTokenBase64Credentials
{
    NSString* bearerToken = [NSString stringWithFormat:@"%@:%@", consumerKey, consumerSecret];
    NSData* data = [bearerToken dataUsingEncoding:NSUTF8StringEncoding];
    NSString* bearerTokenBase64 = [data base64EncodedStringWithOptions:0];
        
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
              NSLog(@"JSON: %@", responseObject);
          }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@ %ld", error.localizedDescription, operation.response.statusCode);
          }];
}

#pragma mark - Work with Core Data

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
                                                   cacheName:nil];
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

- (void)saveToCoreData
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

-(void) printDB
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"ASFollowing"
                                                   inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    for (ASFollowing* object in resultArray) {
        ASFollowing* following = (ASFollowing*) object;
        
        NSLog(@"Name: %@ Followers count: %@", following.name, following.followersCount);
    }
    
}

#pragma mark - Actions

- (IBAction)downloadFollowings:(id)sender
{
    for(int i = 0; i < self.twitterFeed.count; i++) {
        
        NSDictionary* JSONresponse = self.twitterFeed[i];
        
        NSString* name = [NSString stringWithFormat:@"%@", JSONresponse[@"screen_name"]];
        
        NSURL* url = [NSURL URLWithString:[JSONresponse objectForKey:@"profile_image_url"]];
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        
        NSString* numberFollowing = [NSString stringWithFormat:@"%@", JSONresponse[@"followers_count"]];
        NSNumber* followingCount = [NSNumber numberWithInt:[numberFollowing intValue]];
        
        ASFollowing* following = [NSEntityDescription insertNewObjectForEntityForName:@"ASFollowing"
                                                               inManagedObjectContext:self.managedObjectContext];
        
        following.name = name;
        following.profileImage = imageData;
        following.followersCount = followingCount;
        
        NSError* error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    [self.tableView reloadData];
    /*
    NSMutableArray* newPath = [NSMutableArray array];
    for(int i = (int)[self.twitterFeed count]; i ; )
     {
        
     }
    
    [self.tableView beginUpdates];
    
    
    
    [self.tableView endUpdates];
    
    [self printDB];
    
    [[[UIAlertView alloc] initWithTitle:@"Saveing..."
                                message:@"Data been saved."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
    */
}


- (IBAction)deleteAllObjects:(id)sender
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
    
    for (id object in resultArray) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
    
    [self.tableView reloadData];
    
    [[[UIAlertView alloc] initWithTitle:@"Deleting..."
                                message:@"Data been deleted."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
    [self printDB];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"ASFollowing"
                                                   inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    NSLog(@"resultArray.count = %zd", resultArray.count);
    
    return resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ASFollowing* following = [self.fetchedResultsController objectAtIndexPath:indexPath];
 
    cell.textLabel.text = following.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", following.followersCount];
    
    cell.imageView.image = [UIImage imageNamed:@"user.png"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        UIImage* image = [[UIImage alloc] initWithData:following.profileImage];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.imageView.image = image;
                [cell setNeedsLayout];
            });
        }
    });
    
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TwitterClient" withExtension:@"momd"];
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

-(void) saveContext
{
    
}

@end