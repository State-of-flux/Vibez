//
//  Ticket+Additions.m
//  Vibez
//
//  Created by Harry Liddell on 29/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Ticket+Additions.h"

@implementation Ticket (Additions)

+(void)importTickets:(NSArray *)tickets intoContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [Ticket allTicketsInContext:context];
    
    [allObjects makeObjectsPerformSelector:@selector(setHasBeenUpdated:) withObject:@NO];
    
    if(error)
    {
        NSLog(@"error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
    }
    else
    {
        NSArray *parseObjects = [PIKParseManager pfObjectsToDictionary:tickets];
        
        [Ticket sqk_insertOrUpdate:parseObjects
                   uniqueModelKey:@"eventID"
                  uniqueRemoteKey:@"objectId"
              propertySetterBlock:^(NSDictionary *dictionary, Ticket *managedObject) {
                  
                  managedObject.ticketID = dictionary[@"objectId"];
                  managedObject.referenceNumber = dictionary[@"referenceNumber"];
                  managedObject.owner = dictionary[@"owner"];
                  managedObject.hasBeenUsed = dictionary[@"hasBeenUsed"];
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

+(void)deleteInvalidTicketsInContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    [Ticket sqk_deleteAllObjectsInContext:context
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

+(NSArray *)allTicketsInContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [context executeFetchRequest:[Ticket sqk_fetchRequest]
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
                                uniqueValue:self.ticketID
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
                              dictionary:@{@"objectId" : self.ticketID,
                                           @"referenceNumber" : self.referenceNumber,
                                           @"owner" : self.owner}];
}

@end
