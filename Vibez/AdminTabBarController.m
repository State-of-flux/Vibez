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
    item0.title = @"SCAN";
    item0.image = [factory createImageForIcon:NIKFontAwesomeIconQrcode];
    item0.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconQrcode];
    
    UITabBarItem *item1 = self.tabBar.items[1];
    item1.title = @"LIST";
    item1.image = [factory createImageForIcon:NIKFontAwesomeIconAdn];
    item1.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconAdn];
    
    UITabBarItem *item2 = self.tabBar.items[2];
    item2.title = @"MORE";
    item2.image = [factory createImageForIcon:NIKFontAwesomeIconBars];
    item2.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconBars];
}

@end
