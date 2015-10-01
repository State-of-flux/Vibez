//
//  Order+CoreDataProperties.h
//  Vibez
//
//  Created by Harry Liddell on 30/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Order.h"

NS_ASSUME_NONNULL_BEGIN

@interface Order (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDecimalNumber *discount;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *hasBeenUpdated;
@property (nullable, nonatomic, retain) NSString *orderID;
@property (nullable, nonatomic, retain) NSDecimalNumber *priceTotal;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<Ticket *> *tickets;
@property (nullable, nonatomic, retain) User *user;

@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addTicketsObject:(Ticket *)value;
- (void)removeTicketsObject:(Ticket *)value;
- (void)addTickets:(NSSet<Ticket *> *)values;
- (void)removeTickets:(NSSet<Ticket *> *)values;

@end

NS_ASSUME_NONNULL_END
