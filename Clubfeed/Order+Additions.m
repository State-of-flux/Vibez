//
//  Order+Additions.m
//  Vibez
//
//  Created by Harry Liddell on 20/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Order+Additions.h"

@implementation Order (Additions)

+(void)importOrders:(NSArray *)tickets intoContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [Order allOrdersInContext:context];
    
    [allObjects makeObjectsPerformSelector:@selector(setHasBeenUpdated:) withObject:@NO];
    
    if(error)
    {
        NSLog(@"error : %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
    }
    else
    {
        NSArray *parseObjects = [PIKParseManager pfObjectsToDictionary:tickets];
        
        [Order sqk_insertOrUpdate:parseObjects
                    uniqueModelKey:@"orderID"
                   uniqueRemoteKey:@"objectId"
               propertySetterBlock:^(NSDictionary *dictionary, Order *managedObject) {
                   
                   managedObject.orderID = dictionary[@"objectId"];
                   managedObject.discount = dictionary[@"discount"];
                   managedObject.username = [dictionary[@"user"] objectForKey:@"username"];
                   managedObject.email = [dictionary[@"user"] objectForKey:@"email"];
                   managedObject.priceTotal = dictionary[@"priceTotal"];
                   [managedObject.tickets setByAddingObjectsFromArray:dictionary[@"tickets"]];
                   managedObject.quantity = dictionary[@"quantity"];
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

+(void)deleteInvalidOrdersInContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    [Order sqk_deleteAllObjectsInContext:context
                            withPredicate:[NSPredicate predicateWithFormat:@"hasBeenUpdated == NO"]
                                    error:&error];
}

+(void)getOrdersForUserFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user = %@", [PFUser currentUser]];
    
    [PIKParseManager getAllForClassName:NSStringFromClass([self class]) withPredicate:predicate withIncludeKey:@"event"
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

+ (void)getOrdersForEvent:(PFObject *)event fromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event = %@", event];
    
    [PIKParseManager getAllForClassName:NSStringFromClass([self class]) withPredicate:predicate withIncludeKey:@"event.venue"
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

+(NSArray *)allOrdersInContext:(NSManagedObjectContext *)context
{
    NSError* error;
    
    NSArray* allObjects = [context executeFetchRequest:[Order sqk_fetchRequest]
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
                                uniqueValue:self.orderID
                                    success:^(PFObject *pfObject) {
                                        NSLog(@"Uploaded");
                                    }
                                    failure:^(NSError *error) {
                                        NSLog(@"Error %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
                                    }];
}

- (PFObject *)pfObject
{
    PFObject *object = [PFObject objectWithClassName:NSStringFromClass([self class])
                                          dictionary:@{@"objectId" : self.orderID,
                                                       @"priceTotal" : self.priceTotal,
                                                       @"discount" : self.discount,
                                                       @"user" : self.user,
                                                       @"tickets" : self.tickets,
                                                       @"quantity" : self.quantity
                                                       }];
    
    return object;
}

+ (PFObject *)createOrderForEvent:(PFObject *)event withQuantity:(NSInteger)quantity
{
    PFObject *newOrder = [PFObject objectWithClassName:NSStringFromClass([self class])];
    
    [newOrder setObject:event forKey:@"event"];
    [newOrder setObject:[NSNumber numberWithInteger:quantity] forKey:@"quantity"];
    [newOrder setObject:[event objectForKey:@"price"] forKey:@"priceTotal"];
    [newOrder setObject:@0 forKey:@"discount"];
    [newOrder setObject:[PFUser currentUser] forKey:@"user"];
    
    return newOrder;
}

+ (NSMutableArray *)createTicketsForOrder:(PFObject *)order {
    NSMutableArray *arrayOfTickets = [NSMutableArray array];
    
    for(NSInteger i = 0; i < [[order objectForKey:@"quantity"] integerValue]; i++)
    {
        PFObject *ticket = [PFObject objectWithClassName:@"Ticket"];
        
        [ticket setObject:@NO forKey:@"hasBeenUsed"];
        [ticket setObject:[order objectForKey:@"event"] forKey:@"event"];
        [ticket setObject:[PFUser currentUser] forKey:@"user"];
        [ticket setObject:@"" forKey:@"nameIdentifier"];
        
        [arrayOfTickets addObject:ticket];
    }
    
    return arrayOfTickets;
}

@end
