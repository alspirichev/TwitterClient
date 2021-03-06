//
//  ViewController.h
//  TwitterClient
//
//  Created by Alexander Spirichev on 29.08.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

- (IBAction)downloadFollowings:(id)sender;
- (IBAction)deleteAllObjects:(id)sender;

@property (strong, nonatomic) NSMutableArray* twitterFeed;
@property (strong, nonatomic) ViewController* viewController;
@property (strong, nonatomic) NSString* screenName;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end