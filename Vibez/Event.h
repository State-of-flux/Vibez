//
//  Event.h
//  Vibez
//
//  Created by Harry Liddell on 17/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@interface Event : NSObject

@property (nonatomic, retain) NSMutableArray* events;

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic, copy) NSDate *eventDate;
@property (nonatomic, copy) Venue *eventVenue;
@property (nonatomic, copy) NSDate *eventLastEntry;
@property (nonatomic, copy) NSDate *eventEnd;
//@property (nonatomic, copy) NSString *eventGenre;

@property (nonatomic, copy) NSMutableArray *allEvents;

+ (void)getEventsInBackground;
+ (instancetype)eventWithName:(NSString *)name description:(NSString *)description date:(NSDate *)date lastEntry:(NSDate *)lastEntry end:(NSDate *)end;

@end
