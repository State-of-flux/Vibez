//
//  Venue+CoreDataProperties.h
//  Clubfeed
//
//  Created by Harry Liddell on 01/02/2016.
//  Copyright © 2016 Pikture. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Venue.h"

NS_ASSUME_NONNULL_BEGIN

@interface Venue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *facebook;
@property (nullable, nonatomic, retain) NSNumber *hasBeenUpdated;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *instagram;
@property (nullable, nonatomic, retain) id location;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *town;
@property (nullable, nonatomic, retain) NSString *twitter;
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
