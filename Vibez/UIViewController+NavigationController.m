//
//  UIViewController+NavigationController.m
//  Mithra
//
//  Created by Luke Dixon on 15/06/2015.
//  Copyright (c) 2015 57Digital Ltd. All rights reserved.
//

#import "UIViewController+NavigationController.h"

@implementation UIViewController (NavigationController)

- (UINavigationController *)withNavigationController {
    return [self withNavigationControllerWithModalPresentationStyle:UIModalPresentationFullScreen];
}

- (UINavigationController *)withNavigationControllerWithModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    [navigationController setModalPresentationStyle:modalPresentationStyle];
    return navigationController;
}

- (UINavigationController *)withNavigationControllerWithOpaque {
    return [self withNavigationControllerWithOpaqueWithModalPresentationStyle:UIModalPresentationFullScreen];
}

- (UINavigationController *)withNavigationControllerWithOpaqueWithModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    [[navigationController navigationBar] setTranslucent:NO];
    [[navigationController navigationBar] setOpaque:YES];
    [navigationController setModalPresentationStyle:modalPresentationStyle];
    return navigationController;
}

@end