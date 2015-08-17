//
//  VLSParseManager.m
//  Village Shop
//
//  Created by Ste Prescott on 23/08/2014.
//  Copyright (c) 2014 3Squared. All rights reserved.
//

#import "PIKParseManager.h"
#import "PIKContextManager.h"
#import "PFObject+PIK.h"

@implementation PIKParseManager

+ (void)pfObjectForClassName:(NSString *)className remoteUniqueKey:(NSString *)remoteUniqueKey uniqueValue:(NSString *)uniqueValue success:(void (^)(PFObject *pfObject))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ == '%@'", remoteUniqueKey, uniqueValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    PFQuery *query = [PFQuery queryWithClassName:className predicate:predicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            if(failureBlock)
            {
                failureBlock(error);
            }
        }
        else
        {
            if(objects.count > 1)
            {
                NSLog(@"More than one entity that matches the predicate %@. Returning first object", predicateFormat);
            }
            
            if(successBlock)
            {
                successBlock([objects firstObject]);
            }
        }
    }];
}

+ (void)insertOrUpdatePFObject:(PFObject *)pfObject withClassName:(NSString *)className remoteUniqueKey:(NSString *)remoteUniqueKey uniqueValue:(NSString *)uniqueValue success:(void (^)(PFObject *pfObject))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ == '%@'", remoteUniqueKey, uniqueValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    PFQuery *query = [PFQuery queryWithClassName:className predicate:predicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *queryObject;
        
        if(objects.count > 0)
        {
            queryObject = (PFObject *)[objects firstObject];
            
            NSArray *allKeys = [pfObject allKeys];
            
            [allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                [queryObject setObject:pfObject[key] forKey:key];
            }];
        }
        else
        {
            queryObject = [PFObject objectWithClassName:className dictionary:[pfObject dictionary]];
        }
        
        
        [queryObject saveInBackground];
        
        if(error)
        {
            NSLog(@"Error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
            if(failureBlock)
            {
                failureBlock(error);
            }
        }
        else if(successBlock)
        {
            successBlock(queryObject);
        }
    }];
}

+ (NSArray *)pfObjectsToDictionary:(NSArray *)pfObjects
{
    NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:pfObjects.count];
    
    [pfObjects enumerateObjectsUsingBlock:^(PFObject *object, NSUInteger idx, BOOL *stop) {
        [dictionaries addObject:[object dictionary]];
    }];
    
    return dictionaries;
}

+ (void)getAllForClassName:(NSString *)className withIncludeKey:(NSString *)includeKey success:(void (^)(NSArray *objects))successBlock failure:(void (^)(NSError *error))failureBlock
{
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    if(includeKey)
    {
        [query includeKey:includeKey];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(!error && successBlock)
        {
            successBlock(objects);
        }
        else if(failureBlock)
        {
            failureBlock(error);
        }
    }];
}

+ (void)getAllForClassName:(NSString *)className withPredicate:(NSPredicate *)predicate withIncludeKey:(NSString *)includeKey success:(void (^)(NSArray *objects))successBlock failure:(void (^)(NSError *error))failureBlock
{
    PFQuery *query = [PFQuery queryWithClassName:className predicate:predicate];
    
    if(includeKey)
    {
        [query includeKey:includeKey];
        [query includeKey:@"user"];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error && successBlock)
         {
             successBlock(objects);
         }
         else if(failureBlock)
         {
             failureBlock(error);
         }
     }];
}

+ (void)reloadDataSuccess:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock
{
    //    [PIKParseManager getAllForClassName:@"ProductCategory"
    //                                success:^(NSArray *objects) {
    //
    //                                    NSManagedObjectContext *privateContext = [PIKContextManager newPrivateContext];
    //                                    [ProductCategory importProductCategories:objects inContext:privateContext];
    //                                    [ProductCategory deleteInvalidObjectsInContext:privateContext];
    //
    //                                    [PIKParseManager getAllForClassName:@"Venue"
    //                                                                success:^(NSArray *objects) {
    //                                                                    [Product importProducts:objects inContext:privateContext];
    //                                                                    [Product deleteInvalidObjectsInContext:privateContext];
    //
    //                                                                    [privateContext save:nil];
    //
    //                                                                    if(successBlock)
    //                                                                    {
    //                                                                        successBlock();
    //                                                                    }
    //                                                                }
    //                                                                failure:^(NSError *error) {
    //                                                                    if(failureBlock)
    //                                                                    {
    //                                                                        failureBlock(error);
    //                                                                    }
    //                                                                }];
    //                                }
    //                                failure:^(NSError *error) {
    //                                    if(failureBlock)
    //                                    {
    //                                        failureBlock(error);
    //                                    }
    //                                }];
}

@end
