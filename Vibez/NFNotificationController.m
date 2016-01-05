//
//  NFNotificationController.m
//  Vibez
//
//  Created by Harry Liddell on 25/11/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "NFNotificationController.h"
#import "Ticket+Additions.h"
#import <DateTools/DateTools.h>
#import "NSArray+PIK.h"

@interface NFNotificationController ()

@end

@implementation NFNotificationController

+ (void)scheduleNotifications {
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    SQKManagedObjectController *controller = [[SQKManagedObjectController alloc] initWithFetchRequest:[Ticket sqk_fetchRequest] managedObjectContext:[PIKContextManager mainContext]];
    NSError *error;
    //[controller setDelegate:self];
    [controller fetchRequest];
    [controller performFetch:&error];
    
    NSArray *uniqueValues = [[controller managedObjects] arrayFilteredForUniqueValuesOfKeyPath:@"eventID"];
    
    if(!error) {
        for(Ticket *ticket in uniqueValues) {
            
            NSDate *dayBeforeAlert = [[[ticket eventDate] dateBySubtractingDays:1] dateBySubtractingHours:1];
            NSDate *hourBeforeAlert = [[ticket eventDate] dateBySubtractingHours:1];
            
            [self createLocalNotification:[NSString stringWithFormat:@"%@ starts tomorrow, don't forget!", [ticket eventName]] date:dayBeforeAlert userInfo:@{@"id" : @"eventReminder"}];
            [self createLocalNotification:[NSString stringWithFormat:@"%@ will begin in 1 hour!", [ticket eventName]] date:hourBeforeAlert userInfo:@{@"id" : @"eventReminder"}];
            [self createLocalNotification:[NSString stringWithFormat:@"%@ has begun!", [ticket eventName]] date:[ticket eventDate] userInfo:@{@"id" : @"eventReminder"}];
            [self createLocalNotification:[NSString stringWithFormat:@"Hope you had a good night! Stay safe, stay lively."] date:[ticket eventEndDate] userInfo:@{@"id" : @"eventReminder"}];
        }
    } else {
        NSLog(@"Error Occurred while fetching the tickets to schedule notifications: %@", [error localizedDescription]);
    }
}

+ (void)createLocalNotification:(NSString *)message date:(NSDate *)date userInfo:(NSDictionary *)userInfo {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setAlertTitle:NSLocalizedString(@"Clubfeed", nil)];
    [localNotification setAlertBody:message];
    [localNotification setFireDate:date];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    [localNotification setUserInfo:userInfo];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [localNotification setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"%@ --- %@", message, [localNotification fireDate]);
}

@end
