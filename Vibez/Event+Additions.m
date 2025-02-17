//
//  Event+Additions.m
//  Vibez
//
//  Created by Harry Liddell on 26/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Event+Additions.h"
#import "Constants.h"

@implementation Event (Additions)

+(void)importEvents:(NSArray *)events intoContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [Event allEventsInContext:context];
    
    [allObjects makeObjectsPerformSelector:@selector(setHasBeenUpdated:) withObject:@NO];
    
    if(error)
    {
        NSLog(@"error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
    }
    else
    {
        NSArray *parseObjects = [PIKParseManager pfObjectsToDictionary:events];
        
        [Event sqk_insertOrUpdate:parseObjects
                   uniqueModelKey:@"eventID"
                  uniqueRemoteKey:@"objectId"
              propertySetterBlock:^(NSDictionary *dictionary, Event *managedObject) {
                  
                  PFFile* imageFile = dictionary[@"eventImage"];
                  managedObject.image = imageFile.url;
                  
//                  [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//                      if (!error && data) {
//                          [managedObject setImageData:[[NSData alloc] initWithData:data]];
//                      }
//                  }];

                  managedObject.eventID = dictionary[@"objectId"];
                  managedObject.price = dictionary[@"price"];
                  managedObject.name = dictionary[@"eventName"];
                  managedObject.eventDescription = dictionary[@"eventDescription"];
                  managedObject.eventVenue = [dictionary[@"venue"] objectForKey:@"venueName"];
                  managedObject.eventVenueId = [dictionary[@"venue"] objectId];
                  managedObject.startDate = dictionary[@"eventDate"];
                  managedObject.lastEntry = dictionary[@"eventLastEntry"];
                  managedObject.endDate = dictionary[@"eventEnd"];
                  managedObject.quantity = dictionary[@"quantity"];
                  managedObject.bookingFee = dictionary[@"bookingFee"];
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

+(void)deleteInvalidEventsInContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    [Event sqk_deleteAllObjectsInContext:context
                           withPredicate:[NSPredicate predicateWithFormat:@"hasBeenUpdated == NO"]
                                   error:&error];
}

+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventEnd >= %@", [NSDate date]];
    
    [PIKParseManager getAllForClassName:NSStringFromClass([self class]) withPredicate:predicate withIncludeKey:@"venue"
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

+(void)getEventsFromParseForAdmin:(PFUser *)adminScanner withSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scanner = %@", [PFUser currentUser]];
    
    [PIKParseManager getAllForClassName:NSStringFromClass([self class]) withPredicate:predicate withIncludeKey:@"venue"
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

+(NSArray *)allEventsInContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [context executeFetchRequest:[Event sqk_fetchRequest]
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
                                uniqueValue:self.eventID
                                    success:^(PFObject *pfObject) {
                                        NSLog(@"Uploaded");
                                    }
                                    failure:^(NSError *error) {
                                        NSLog(@"Error %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
                                    }];
}

- (PFObject *)pfObject {
    return [PFObject objectWithClassName:NSStringFromClass([self class])
                              dictionary:@{@"objectId"         : self.eventID,
                                           @"eventDescription" : self.eventDescription,
                                           @"eventName"        : self.name,
                                           @"price"            : self.price,
                                           @"image"            : self.image,
                                           @"eventVenue"       : self.eventVenue,
                                           @"eventDate"        : self.startDate,
                                           @"eventLastEntry"   : self.lastEntry,
                                           @"eventEnd"         : self.endDate,
                                           @"quantity"         : self.quantity}];
}

- (void)quantityRemainingFromParseWithBlock:(eventCompletion)compblock {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"objectId" equalTo:[self eventID]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if ([objects count] == 1) {
            
            PFObject *returnedObject = [objects firstObject];
            
            if ([returnedObject objectForKey:@"quantity"]) {
                compblock(YES, [[returnedObject objectForKey:@"quantity"] intValue], error);
            } else {
                compblock(NO, 0, error);
            }
            
        } else {
            compblock(NO, 0, error);
        }
    }];
}

+ (void)quantityRemainingFromParseWithId:(NSString *)Id withBlock:(eventCompletion)compblock {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"objectId" equalTo:Id];
    [query selectKeys:@[@"quantity"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if ([objects count] == 1) {
            
            PFObject *returnedObject = [objects firstObject];
            
            if (returnedObject) {
                compblock(YES, [[returnedObject objectForKey:@"quantity"] intValue], error);
            } else {
                compblock(NO, 0, error);
            }
            
        } else {
            compblock(NO, 0, error);
        }
    }];
}

+ (NSString *)eventIdForAdmin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventId = [defaults objectForKey:pikEventIdForAdmin];
    return eventId;
}

+ (NSString *)eventNameForAdmin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventName = [defaults objectForKey:pikEventNameForAdmin];
    return eventName;
}

+ (void)setEventIdForAdmin:(NSString *)eventId withName:(NSString *)eventName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:eventId forKey:pikEventIdForAdmin];
    [defaults setObject:eventName forKey:pikEventNameForAdmin];
    [defaults synchronize];
}

@end
