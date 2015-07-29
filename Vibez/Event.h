//
//  Event.h
//  Vibez
//
//  Created by Harry Liddell on 29/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ticket, Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * eventVenue;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSDate * price;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * lastEntry;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *venues;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Ticket *)value;
- (void)removeEventsObject:(Ticket *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet *)values;
- (void)removeVenues:(NSSet *)values;

@end
