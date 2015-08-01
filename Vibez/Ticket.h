//
//  Ticket.h
//  Vibez
//
//  Created by Harry Liddell on 31/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Order;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSNumber * hasBeenUsed;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * referenceNumber;
@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) Order *order;
@property (nonatomic, retain) Event *tickets;

@end
