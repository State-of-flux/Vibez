//
//  VibesTabBarViewController.m
//  Vibez
//
//  Created by Harry Liddell on 30/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VibesTabBarViewController.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@interface VibesTabBarViewController ()

@end

@implementation VibesTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory tabBarItemIconFactory];
    UITabBarItem *item0 = self.tabBar.items[0];
    item0.title = NSLocalizedString(@"DISCOVER", nil);
    item0.image = [factory createImageForIcon:NIKFontAwesomeIconMoonO];
    item0.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconMoonO];
    
    UITabBarItem *item1 = self.tabBar.items[1];
    item1.title = NSLocalizedString(@"TICKETS", nil);
    item1.image = [factory createImageForIcon:NIKFontAwesomeIconTicket];
    item1.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconTicket];
    
    UITabBarItem *item2 = self.tabBar.items[2];
    item2.title = NSLocalizedString(@"MORE", nil);
    item2.image = [factory createImageForIcon:NIKFontAwesomeIconBars];
    item2.selectedImage = [factory createImageForIcon:NIKFontAwesomeIconBars];
}

@end
