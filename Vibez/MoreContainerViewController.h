//
//  MoreContainerViewController.h
//  Vibez
//
//  Created by Harry Liddell on 14/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SQKDataKit/SQKManagedObjectController.h>
#import "User+Additions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MoreContainerViewController : UITableViewController <SQKManagedObjectControllerDelegate>

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *accountData;
@property (strong, nonatomic) NSArray *filterData;
@property (strong, nonatomic) NSArray *controlData;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) User *user;

@property (nonatomic, strong) SQKManagedObjectController *controller;

@end
