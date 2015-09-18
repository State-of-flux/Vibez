//
//  Order.h
//  Vibez
//
//  Created by Harry Liddell on 16/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ticket, User;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * discount;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSDecimalNumber * priceTotal;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *tickets;
@property (nonatomic, retain) User *user;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addTicketsObject:(Ticket *)value;
- (void)removeTicketsObject:(Ticket *)value;
- (void)addTickets:(NSSet *)values;
- (void)removeTickets:(NSSet *)values;

@end
