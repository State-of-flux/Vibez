//
//  Event.h
//  Vibez
//
//  Created by Harry Liddell on 17/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * eventVenue;
@property (nonatomic, retain) NSString * eventVenueLocation;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSDate * lastEntry;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDecimalNumber * bookingFee;
@property (nonatomic, retain) NSSet *venues;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet *)values;
- (void)removeVenues:(NSSet *)values;

@end
