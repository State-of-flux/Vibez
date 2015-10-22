//
//  Event+CoreDataProperties.h
//  Vibez
//
//  Created by Harry Liddell on 04/10/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDecimalNumber *bookingFee;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSString *eventDescription;
@property (nullable, nonatomic, retain) NSString *eventID;
@property (nullable, nonatomic, retain) NSString *eventVenue;
@property (nullable, nonatomic, retain) NSString *eventVenueId;
@property (nullable, nonatomic, retain) NSString *eventVenueLocation;
@property (nullable, nonatomic, retain) NSNumber *hasBeenUpdated;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSDate *lastEntry;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDecimalNumber *price;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSSet<Venue *> *venues;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet<Venue *> *)values;
- (void)removeVenues:(NSSet<Venue *> *)values;

@end

NS_ASSUME_NONNULL_END
