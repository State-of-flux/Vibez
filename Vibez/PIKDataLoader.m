//
//  PIKDataLoader.m
//  Vibez
//
//  Created by Harry Liddell on 12/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "PIKDataLoader.h"
#import "Event+Additions.h"
#import "Venue+Additions.h"
#import "Ticket+Additions.h"
#import "NFNotificationController.h"

@implementation PIKDataLoader

+ (void)loadEvents:(CompletionBlock)compblock {
    [Event getAllFromParseWithSuccessBlock:^(NSArray *objects)
     {
         NSError *error;
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Event importEvents:objects intoContext:newPrivateContext];
         [Event deleteInvalidEventsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
         
         compblock(YES);
     }
                              failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
}

+ (void)loadVenues:(CompletionBlock)compblock {
    [Venue getAllFromParseWithSuccessBlock:^(NSArray *objects) {
        NSError *error;
        NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
        [Venue importVenues:objects intoContext:newPrivateContext];
        [Venue deleteInvalidVenuesInContext:newPrivateContext];
        [newPrivateContext save:&error];
        
        if(error)
        {
            NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
        }
        
        compblock(YES);
    }
                              failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
}

+ (void)loadTickets:(CompletionBlock)compblock {
    [Ticket getTicketsForUserFromParseWithSuccessBlock:^(NSArray *objects)
     {
         NSError *error;
         
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Ticket importTickets:objects intoContext:newPrivateContext];
         [Ticket deleteInvalidTicketsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
         
         compblock(YES);
         [NFNotificationController scheduleNotifications];
     }
                                          failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
}

+ (void)loadAllCustomerData:(CompletionBlock)compblock {
    [self loadEvents:^(BOOL finishedEvents) {
        if (finishedEvents) {
            [self loadVenues:^(BOOL finishedVenues) {
                if (finishedVenues) {
                    [self loadTickets:^(BOOL finishedTickets) {
                        if (finishedTickets) {
                            compblock(YES);
                        }
                    }];
                }
            }];
        }
    }];
}

+ (void)loadAllAdminData:(CompletionBlock)compblock {
    
    [Event getEventsFromParseForAdmin:[PFUser currentUser] withSuccessBlock:^(NSArray *objects)
     {
         NSError *error;
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Event importEvents:objects intoContext:newPrivateContext];
         [Event deleteInvalidEventsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
         
         compblock(YES);
     }
                         failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         compblock(YES);
     }];
}

@end
