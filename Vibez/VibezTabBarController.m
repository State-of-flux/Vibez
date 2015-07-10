//
//  VibezTabBarController.m
//  Vibez
//
//  Created by Harry Liddell on 06/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VibezTabBarController.h"
#import "UIFont+PIK.h"

@implementation VibezTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
    {
        self.delegate = self;
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:184.0f/255.0f green:42.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];

        
        [UITabBarItem.appearance setTitleTextAttributes: @{
                                                           NSFontAttributeName : [UIFont pik_montserratRegWithSize:10.0f]
                                                           } forState:UIControlStateNormal];
        
    }
    return self;
}

@end
