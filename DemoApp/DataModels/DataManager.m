//
//  DataManager.m
//  DemoApp
//
//  Created by Nitesh Meshram on 10/13/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
//+ (DataManager*)sharedInstance;
//- (void)saveContext;
@end

@implementation DataManager

+ (void)prepareDataStack{
    [[self sharedInstance] managedObjectContext];

}

+ (DataManager*)sharedInstance
{
    static DataManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DataManager alloc] init];
        
    });
    
    return _sharedInstance;
}

#pragma mark - Core Data

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil] ;
    
    return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"DemoApp.sqlite"]];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
    }
    
    return persistentStoreCoordinator;

}


#pragma mark - Application's Documents directory

- (NSString *)applicationDocumentsDirectory {
    
    NSLog(@"DB Path => %@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
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
            abort();
        }
    }
}

-(void)saveMessage:(NSString *)message userID:(NSString *)userID completion:(void (^)(BOOL, Message *))completion {
    
    _managedObjectContext = self.managedObjectContext;
    Message *objMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:_managedObjectContext];
    
    NSDateFormatter *messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S"]; // for example
    NSDate *itsDate = [NSDate date];
    [objMessage setValue:itsDate forKey:@"dateTime"];
    
    NSString *messageId = [[NSUUID UUID] UUIDString];
    [objMessage setValue:messageId forKey:@"id"];
    
    
    [objMessage setValue:message forKey:@"messageDescription"];
    
    if ([userID isEqualToString:@"2"])
    {
        
        [objMessage setValue:userID forKey:@"senderId"];
        [objMessage setValue:@"1" forKey:@"receiverId"];
        
    }
    else{ // System User
        
        [objMessage setValue:userID forKey:@"senderId"];
        [objMessage setValue:@"2" forKey:@"receiverId"];
    }
    
    
    
    
    
    NSError *error = nil;
    if ([_managedObjectContext save:&error]) {
        NSLog(@"Message saved");
        completion(YES, objMessage);
        
    }
    else{
        NSLog(@"Error occured while Message saving");
        completion(NO, nil);
    }
    
}

-(void)saveUserId:(NSString *)userId userName:(NSString *)userName
{
  
    
    if ([[DataManager sharedInstance] checkUserExist:userId]) {
        NSLog(@"User Exist in DB");
    }
    
    else {
        
        NSManagedObject *objUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:_managedObjectContext];
        
        [objUser setValue:userId forKey:@"userId"];
        [objUser setValue:userName forKey:@"userName"];
        
        NSError *error = nil;
        if ([_managedObjectContext save:&error]) {
            NSLog(@"UserDetails saved");
            //            completion(YES, nil);
            
        }
        else{
            NSLog(@"Error occured while UserDetails saving");
            //            completion(NO, nil);
        }
        
    }
}

-(UserDetails *)checkUserExist:(NSString *)userId {
    
    NSArray *fetchedObjects;
    _managedObjectContext = self.managedObjectContext;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UserDetails"  inManagedObjectContext: _managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"userId = %@",userId]];
    NSError * error = nil;
    fetchedObjects = [_managedObjectContext executeFetchRequest:fetch error:&error];
    if (fetchedObjects.count>0) {
        NSLog(@"User Exist in DB");
        return [fetchedObjects objectAtIndex:0];
        
    }
    return nil;
    
}

-(NSArray *)getAllMessages{

    NSArray *fetchedObjects;
    _managedObjectContext = self.managedObjectContext;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Message"  inManagedObjectContext: _managedObjectContext];
    [fetch setEntity:entityDescription];
//    [fetch setPredicate:[NSPredicate predicateWithFormat:@"userId = %@",userId]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:TRUE];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    NSError * error = nil;
    fetchedObjects = [_managedObjectContext executeFetchRequest:fetch error:&error];
    if (fetchedObjects.count>0) {
        NSLog(@"User Exist in DB");
        return fetchedObjects;
        
//        NSLog(@"getAllMessages => %@",[fetchedObjects objectAtIndex:0]);
//        NSLog(@"getAllMessages => %@",[fetchedObjects objectAtIndex:1]);
        
//        for (Message *msg in fetchedObjects)
//        {
//            NSLog(@"Message Details => %@", msg.messageDescription);
//        }
        
    }
    return nil;
}



@end
