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
    
        
    }
    return self;
}

@end
