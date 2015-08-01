//
//  User+Additions.h
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "User.h"
#import "PIKParseManager.h"
#import <SQKDataKit/SQKDataKit.h>

@interface User (Additions)

+(void)importUsers:(NSArray *)users intoContext:(NSManagedObjectContext *)context;
+(void)deleteInvalidUsersInContext:(NSManagedObjectContext *)context;
+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+(NSArray *)allUsersInContext:(NSManagedObjectContext *)context;

- (void)saveToParse;
- (PFObject *)pfObject;

@end
