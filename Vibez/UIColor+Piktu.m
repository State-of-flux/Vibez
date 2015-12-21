//
//  UIColor+Piktu.m
//  Vibez
//
//  Created by Harry Liddell on 10/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "UIColor+Piktu.h"

@implementation UIColor (Piktu)

+ (UIColor *)pku_placeHolderTextColor
{
    return [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
}

+ (UIColor *)pku_purpleColor {
    return [UIColor colorWithRed:148.0/255.0 green:34.0/255.0 blue:205.0/255.0 alpha:1.0];
    //return [UIColor colorWithRed:224.0/255.0 green:90.0/255.0 blue:109.0/255.0 alpha:1.0f];
}

+ (UIColor *)pku_purpleColorandAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:148.0/255.0 green:34.0/255.0 blue:205.0/255.0 alpha:alpha];
    //return [UIColor colorWithRed:224.0/255.0 green:90.0/255.0 blue:109.0/255.0 alpha:alpha];
}

+ (UIColor *)pku_purpleColorOld
{
    return [UIColor colorWithRed:184.0/255.0 green:42.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)pku_blackColor
{
    return [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    //return [UIColor colorWithRed:245.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
}

+ (UIColor *)pku_lightBlack
{
    return [UIColor colorWithRed:46.0/255.0 green:47.0/255.0 blue:51.0/255.0 alpha:1.0];
    //return [UIColor colorWithRed:245.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
}

+ (UIColor *)pku_lighterBlack
{
    return [UIColor colorWithRed:50.0/255.0 green:51.0/255.0 blue:58.0/255.0 alpha:1.0];
    //return [UIColor colorWithRed:245.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
}

+ (UIColor *)pku_lightBlackAndAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:46.0/255.0 green:47.0/255.0 blue:51.0/255.0 alpha:alpha];
    //return [UIColor colorWithRed:245.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
}

+ (UIColor *)pku_greyColor
{
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
}

+ (UIColor *)pku_greyColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:alpha];
}

+ (UIColor *)pku_SuccessColor
{
    return [UIColor colorWithRed:11.0f/255.0f green:211.0f/255.0f blue:24.0f/255.0f alpha:1.0];
}

+ (UIColor *)pku_FacebookColor
{
    return [UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:152.0f/255.0f alpha:1.0];
}

+ (UIColor *)pku_TwitterColor
{
    return [UIColor colorWithRed:64.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0];
}

+ (UIColor *)pku_InstagramColor
{
    return [UIColor colorWithRed:18.0f/255.0f green:86.0f/255.0f blue:136.0f/255.0f alpha:1.0];
}

@end
