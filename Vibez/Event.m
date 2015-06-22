//
//  Event.m
//  Vibez
//
//  Created by Harry Liddell on 17/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Event.h"
#import <Parse/Parse.h>

@implementation Event

+ (void)getEventsInBackground
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query orderByDescending:@"eventDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded. The first 100 objects available are in 'objects'
             
             [PFObject pinAllInBackground:objects];
             
//             for (PFObject *object in objects)
//             {
//                 [Event eventWithName:[object valueForKey:@"eventName"] description:[object valueForKey:@"eventDescription"] date:[object valueForKey:@"eventDate"] lastEntry:[object valueForKey:@"eventLastEntry"] end:[object valueForKey:@"eventEnd"]];
//                 
//                 [allEvents addObject:[Event eventWithName:[object valueForKey:@"eventName"] description:[object valueForKey:@"eventDescription"] date:[object valueForKey:@"eventDate"] lastEntry:[object valueForKey:@"eventLastEntry"] end:[object valueForKey:@"eventEnd"]]];
//                 
//                 
//             }
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

+ (instancetype)eventWithName:(NSString *)name description:(NSString *)description date:(NSDate *)date lastEntry:(NSDate *)lastEntry end:(NSDate *)end
{
    Event *event = [[self alloc] init];
    event.eventName = name;
    event.eventDescription = description;
    event.eventDate = date;
    event.eventLastEntry = lastEntry;
    event.eventEnd = end;
    return event;
}

@end
