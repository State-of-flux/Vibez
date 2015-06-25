//
//  Event.h
//  Vibez
//
//  Created by Harry Liddell on 23/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * lastEntry;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * eventVenue;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Venue *venue;

@end
