//
//  AppDelegate.h
//  Vibez
//
//  Created by Harry Liddell on 03/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SQKDataKit/SQKDataKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic, readwrite, strong) SQKContextManager *contextManager;
@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;
- (void)logout;
- (void)linkParseAccountToFacebook;

@end

