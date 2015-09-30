//
//  Ticket+CoreDataProperties.h
//  Vibez
//
//  Created by Harry Liddell on 30/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ticket (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSDate *eventDate;
@property (nullable, nonatomic, retain) NSString *eventID;
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSNumber *hasBeenUpdated;
@property (nullable, nonatomic, retain) NSNumber *hasBeenUsed;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *ticketID;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *venue;
@property (nullable, nonatomic, retain) Order *order;

@end

NS_ASSUME_NONNULL_END
