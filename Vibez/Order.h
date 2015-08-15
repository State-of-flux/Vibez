//
//  Order.h
//  Vibez
//
//  Created by Harry Liddell on 15/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * hasBeenUpdated;
@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) User *user;

@end
