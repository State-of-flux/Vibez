//
//  Venue+Additions.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Venue+Additions.h"

@implementation Venue (Additions)

+(void)importVenues:(NSArray *)venues intoContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [Venue allVenuesInContext:context];
    
    [allObjects makeObjectsPerformSelector:@selector(setHasBeenUpdated:) withObject:@NO];
    
    if(error)
    {
        NSLog(@"error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
    }
    else
    {
        NSArray *parseObjects = [PIKParseManager pfObjectsToDictionary:venues];
        
        [Venue sqk_insertOrUpdate:parseObjects
                   uniqueModelKey:@"venueID"
                  uniqueRemoteKey:@"objectId"
              propertySetterBlock:^(NSDictionary *dictionary, Venue *managedObject) {
                  
                  if (dictionary[@"venueImage"]) {
                      PFFile* imageFile = dictionary[@"venueImage"];
                      managedObject.image = imageFile.url;
                  }
                  
                  if (dictionary[@"objectId"]) {
                      managedObject.venueID = dictionary[@"objectId"];
                  }
                  
                  if (dictionary[@"venueDescription"]) {
                       managedObject.venueDescription = dictionary[@"venueDescription"];
                  }
                  
                  if (dictionary[@"venueName"]) {
                      managedObject.name = dictionary[@"venueName"];
                  }
                  
                  if (dictionary[@"town"]) {
                      managedObject.town = dictionary[@"town"];
                  }
                 
                  if (dictionary[@"location"]) {
                      managedObject.location = dictionary[@"location"];
                  }
                  
                  if (dictionary[@"facebook"]) {
                      managedObject.facebook = dictionary[@"facebook"];
                  }
                  
                  if (dictionary[@"twitter"]) {
                      managedObject.twitter = dictionary[@"twitter"];
                  }
                  
                  if (dictionary[@"instagram"]) {
                      managedObject.instagram = dictionary[@"instagram"];
                  }
                  
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

+(void)deleteInvalidVenuesInContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    [Venue sqk_deleteAllObjectsInContext:context
                           withPredicate:[NSPredicate predicateWithFormat:@"hasBeenUpdated == NO"]
                                   error:&error];
}

+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    [PIKParseManager getAllForClassName:NSStringFromClass([self class]) withIncludeKey:nil
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

+(NSArray *)allVenuesInContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [context executeFetchRequest:[Venue sqk_fetchRequest]
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
                                uniqueValue:self.venueID
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
                              dictionary:@{@"objectId" : self.venueID,
                                           @"venueDescription" : self.venueDescription,
                                           @"venueName" : self.name,
                                           //@"location" : self.location,
                                           @"venueImage" : self.image}];
}

@end
