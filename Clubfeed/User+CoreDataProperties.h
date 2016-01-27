//
//  User+CoreDataProperties.h
//  Vibez
//
//  Created by Harry Liddell on 18/11/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *emailAddress;
@property (nullable, nonatomic, retain) id friends;
@property (nullable, nonatomic, retain) NSNumber *hasBeenUpdated;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet<Order *> *)values;
- (void)removeOrders:(NSSet<Order *> *)values;

@end

NS_ASSUME_NONNULL_END
