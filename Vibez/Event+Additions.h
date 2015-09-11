//
//  Event+Additions.h
//  Vibez
//
//  Created by Harry Liddell on 26/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Event.h"
#import "PIKParseManager.h"
#import <SQKDataKit/SQKDataKit.h>
#import <Parse/Parse.h>

@interface Event (Additions)

+(void)importEvents:(NSArray *)events intoContext:(NSManagedObjectContext *)context;
+(void)deleteInvalidEventsInContext:(NSManagedObjectContext *)context;
+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+(void)getEventsFromParseForAdmin:(PFUser *)adminScanner withSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+(NSArray *)allEventsInContext:(NSManagedObjectContext *)context;

- (void)saveToParse;

@end
