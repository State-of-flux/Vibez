//
//  Ticket.h
//  Vibez
//
//  Created by Harry Liddell on 12/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSNumber * hasBeenUsed;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) Order *order;

@end
