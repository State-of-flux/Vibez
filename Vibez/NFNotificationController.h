//
//  NFNotificationController.h
//  Vibez
//
//  Created by Harry Liddell on 25/11/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQKDataKit/SQKManagedObjectController.h>

@interface NFNotificationController : NSObject

@property (strong, nonatomic) SQKManagedObjectController *controller;

+ (void)scheduleNotifications;

@end
