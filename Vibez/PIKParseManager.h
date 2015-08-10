//
//  VLSParseManager.h
//  Village Shop
//
//  Created by Ste Prescott on 23/08/2014.
//  Copyright (c) 2014 3Squared. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFObject+PIK.h"

@interface PIKParseManager : NSObject

+ (void)pfObjectForClassName:(NSString *)className remoteUniqueKey:(NSString *)remoteUniqueKey uniqueValue:(NSString *)uniqueValue success:(void (^)(PFObject *pfObject))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)insertOrUpdatePFObject:(PFObject *)pfObject withClassName:(NSString *)className remoteUniqueKey:(NSString *)remoteUniqueKey uniqueValue:(NSString *)uniqueValue success:(void (^)(PFObject *pfObject))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (NSArray *)pfObjectsToDictionary:(NSArray *)pfObjects;
+ (void)getAllForClassName:(NSString *)className success:(void (^)(NSArray *objects))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)getAllForClassName:(NSString *)className withPredicate:(NSPredicate *)predicate success:(void (^)(NSArray *objects))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)reloadDataSuccess:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
