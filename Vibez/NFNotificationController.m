//
//  NFNotificationController.m
//  Vibez
//
//  Created by Harry Liddell on 25/11/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "NFNotificationController.h"
#import <Parse/Parse.h>

@implementation NFNotificationController

+ (void)scheduleNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //
    
    for (int i = 0; i < 10; i++) {
        
    }
}

- (void)createLocalNotification:(NSString *)message date:(NSDate *)date userInfo:(NSDictionary *)userInfo {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setAlertBody:message];
    [localNotification setFireDate:date];
    //[localNotification setSoundName:@"pdq.caf"];
    [localNotification setUserInfo:userInfo];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
