//
//  User+Additions.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "User+Additions.h"

@implementation User (Additions)

+ (void)importUsers:(NSArray *)users intoContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [User allUsersInContext:context];
    
    [allObjects makeObjectsPerformSelector:@selector(setHasBeenUpdated:) withObject:@NO];
    
    if(error)
    {
        NSLog(@"error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
    }
    else
    {
        NSArray *parseObjects = [PIKParseManager pfObjectsToDictionary:users];
        
        [User sqk_insertOrUpdate:parseObjects
                   uniqueModelKey:@"venueID"
                  uniqueRemoteKey:@"objectId"
              propertySetterBlock:^(NSDictionary *dictionary, User *managedObject) {
                  
                  managedObject.userID = dictionary[@"objectId"];
                  managedObject.username = dictionary[@"username"];
                  managedObject.emailAddress = dictionary[@"email"];
                  managedObject.location = dictionary[@"location"];
                  managedObject.friends = dictionary[@"friends"];
                  managedObject.hasBeenUpdated = @YES;
                  
              }
                   privateContext:context
                            error:&error];
        
        if(error)
        {
            NSLog(@"error when importing : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
        }
    }
    
}

+(void)deleteInvalidUsersInContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    [User sqk_deleteAllObjectsInContext:context
                           withPredicate:[NSPredicate predicateWithFormat:@"hasBeenUpdated == NO"]
                                   error:&error];
}

+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    [PIKParseManager getAllForClassName:NSStringFromClass([self class])
                                success:^(NSArray *objects) {
                                    if (successBlock) {
                                        successBlock(objects);
                                    }
                                }
                                failure:^(NSError *error) {
                                    if (failureBlock) {
                                        failureBlock(error);
                                    }
                                }];
    
}

+(NSArray *)allUsersInContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [context executeFetchRequest:[User sqk_fetchRequest]
                                                 error:&error];
    
    if(error)
    {
        NSLog(@"error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
        return nil;
    }
    else
    {
        return allObjects;
    }
}

- (void)saveToParse
{
    [PIKParseManager insertOrUpdatePFObject:[self pfObject]
                              withClassName:NSStringFromClass([self class])
                            remoteUniqueKey:@"objectId"
                                uniqueValue:self.userID
                                    success:^(PFObject *pfObject) {
                                        NSLog(@"Uploaded");
                                    }
                                    failure:^(NSError *error) {
                                        NSLog(@"Error %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
                                    }];
}

- (PFObject *)pfObject
{
    return [PFObject objectWithClassName:NSStringFromClass([self class])
                              dictionary:@{@"objectId" : self.userID,
                                           @"username" : self.username,
                                           @"email" : self.emailAddress,
                                           @"location" : self.location,
                                           @"friends" : self.friends
                                           }];
}

@end
