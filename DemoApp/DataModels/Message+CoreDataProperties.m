//
//  Message+CoreDataProperties.m
//  DemoApp
//
//  Created by Nitesh Meshram on 10/12/17.
//  Copyright © 2017 Nitesh M. All rights reserved.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Message"];
}

@dynamic dateTime;
@dynamic id;
@dynamic messageDescription;
@dynamic receiverId;
@dynamic senderId;
@dynamic user;

@end
