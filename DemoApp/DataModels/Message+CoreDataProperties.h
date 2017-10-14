//
//  Message+CoreDataProperties.h
//  DemoApp
//
//  Created by Nitesh Meshram on 10/12/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateTime;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *messageDescription;
@property (nullable, nonatomic, copy) NSString *receiverId;
@property (nullable, nonatomic, copy) NSString *senderId;
@property (nullable, nonatomic, retain) UserDetails *user;

@end

NS_ASSUME_NONNULL_END
