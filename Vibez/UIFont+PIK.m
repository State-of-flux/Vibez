//
//  UIFont+PIK.m
//  Vibez
//
//  Created by Harry Liddell on 05/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "UIFont+PIK.h"

@implementation UIFont (PIK)

+ (UIFont *)pik_montserratBoldWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Montserrat-Bold" size:fontSize];
}

+ (UIFont *)pik_montserratRegWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Montserrat-Regular" size:fontSize];
}

+ (UIFont *)pik_avenirNextBoldWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"AvenirNext-Bold" size:fontSize];
    //return [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
}

+ (UIFont *)pik_avenirNextRegWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:fontSize];
    //return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}

@end
