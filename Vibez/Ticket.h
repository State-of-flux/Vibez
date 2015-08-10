//
//  Ticket.h
//  Vibez
//
//  Created by Harry Liddell on 10/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSNumber * hasBeenUsed;
@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * event;

@end
