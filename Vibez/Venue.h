//
//  Venue.h
//  Vibez
//
//  Created by Harry Liddell on 23/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * venueDescription;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSString * venueID;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSSet *events;
@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
