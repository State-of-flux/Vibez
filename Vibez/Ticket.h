//
//  Ticket.h
//  Vibez
//
//  Created by Harry Liddell on 23/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * referenceNumber;
@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) Order *order;

@end
