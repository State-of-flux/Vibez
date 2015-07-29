//
//  User.h
//  Vibez
//
//  Created by Harry Liddell on 29/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) id friends;
@property (nonatomic, retain) UNKNOWN_TYPE userID;
@property (nonatomic, retain) NSSet *orders;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
