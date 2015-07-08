//
//  NSString+PIK.m
//  Vibez
//
//  Created by Harry Liddell on 08/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "NSString+PIK.h"

@implementation NSString (PIK)

+ (NSString *)daySuffixForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

@end
