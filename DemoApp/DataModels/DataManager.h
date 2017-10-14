//
//  DataManager.h
//  DemoApp
//
//  Created by Nitesh Meshram on 10/13/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Message+CoreDataClass.h"
@interface DataManager : NSObject
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel  *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
+ (void)prepareDataStack;

-(void)saveMessage:(NSString *)message userID:(NSString *)userID completion:(void (^)(BOOL, Message *))completion;

-(UserDetails *)checkUserExist:(NSString *)userId;
-(void)saveUserId:(NSString *)userId userName:(NSString *)userName;

+ (DataManager*)sharedInstance;

- (void)saveContext;

-(NSArray *)getAllMessages;
@end
