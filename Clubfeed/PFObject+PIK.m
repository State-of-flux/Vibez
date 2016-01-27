//
//  PFObject+PIK.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "PFObject+PIK.h"

@implementation PFObject (PIK)

-(NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:self.allKeys.count];
    
    [self.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        dictionary[key] = self[key];
    }];
    
    if(self.objectId)
    {
        dictionary[@"objectId"] = self.objectId;
    }
    
    return dictionary;
}

@end
