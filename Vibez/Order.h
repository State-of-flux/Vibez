//
//  Order.h
//  Vibez
//
//  Created by Harry Liddell on 23/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ticket, User;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *tickets;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addTicketsObject:(Ticket *)value;
- (void)removeTicketsObject:(Ticket *)value;
- (void)addTickets:(NSSet *)values;
- (void)removeTickets:(NSSet *)values;

@end
