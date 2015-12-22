//
//  NSArray+PIK.h
//  Vibez
//
//  Created by Harry Liddell on 21/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PIK)

- (NSArray*)arrayFilteredForUniqueValuesOfKeyPath:(NSString*)keyPath;

@end
