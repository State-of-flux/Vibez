//
//  NSArray+PIK.m
//  Vibez
//
//  Created by Harry Liddell on 21/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "NSArray+PIK.h"

@implementation NSArray (PIK)

- (NSArray*)arrayFilteredForUniqueValuesOfKeyPath:(NSString*)keyPath
{
    NSMutableSet *valueSeen = [NSMutableSet new];
    
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        id value = [evaluatedObject valueForKeyPath:keyPath];
        
        if(![valueSeen containsObject:value])
        {
            [valueSeen addObject:value];
            return true;
        }
        else
        {
            return false;
        }
    }]];
}

@end
