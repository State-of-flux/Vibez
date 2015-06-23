//
//  Venue+Additions.h
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Venue.h"
#import "PIKParseManager.h"

@interface Venue (Additions)

+(void)importVenues:(NSArray *)venues intoContext:(NSManagedObjectContext *)context;
+(void)deleteInvalidVenuesInContext:(NSManagedObjectContext *)context;
+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+(NSArray *)allVenuesInContext:(NSManagedObjectContext *)context;

- (void)saveToParse;

@end
