//
//  Venue+CoreDataProperties.h
//  Vibez
//
//  Created by Harry Liddell on 30/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Venue.h"

NS_ASSUME_NONNULL_BEGIN

@interface Venue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *hasBeenUpdated;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *town;
@property (nullable, nonatomic, retain) NSString *venueDescription;
@property (nullable, nonatomic, retain) NSString *venueID;
@property (nullable, nonatomic, retain) NSSet<Event *> *events;

@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet<Event *> *)values;
- (void)removeEvents:(NSSet<Event *> *)values;

@end

NS_ASSUME_NONNULL_END
