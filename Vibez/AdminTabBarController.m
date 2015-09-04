//
//  AdminTabBarController.m
//  Vibez
//
//  Created by Harry Liddell on 03/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "AdminTabBarController.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@interface AdminTabBarController ()

@end

@implementation AdminTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory tabBarItemIconFactory];
    UITabBarItem *item0 = self.tabBar.items[0];
    item0.title = @"Scan";
    item0.image = [factory createImageForIcon:NIKFontAwesomeIconCamera];
    item0.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconCamera];
    
    UITabBarItem *item1 = self.tabBar.items[1];
    item1.title = @"Search";
    item1.image = [factory createImageForIcon:NIKFontAwesomeIconSearch];
    item1.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconSearch];
    
    UITabBarItem *item2 = self.tabBar.items[2];
    item2.title = @"More";
    item2.image = [factory createImageForIcon:NIKFontAwesomeIconBars];
    item2.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconBars];
}

@end
