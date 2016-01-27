//
//  UIViewController+NavigationController.h
//  Mithra
//
//  Created by Luke Dixon on 15/06/2015.
//  Copyright (c) 2015 57Digital Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationController)

- (UINavigationController *)withNavigationController;
- (UINavigationController *)withNavigationControllerWithModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle;

- (UINavigationController *)withNavigationControllerWithOpaque;
- (UINavigationController *)withNavigationControllerWithOpaqueWithModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle;

@end