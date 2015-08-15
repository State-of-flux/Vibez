//
//  Ticket.h
//  Vibez
//
//  Created by Harry Liddell on 15/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSNumber * hasBeenUsed;
@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * referenceNumber;
@property (nonatomic, retain) NSDate * eventDate;

@end
