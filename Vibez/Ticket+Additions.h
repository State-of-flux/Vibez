//
//  Ticket+Additions.h
//  Vibez
//
//  Created by Harry Liddell on 29/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Ticket.h"
#import "PIKParseManager.h"
#import "PIKContextManager.h"
#import <SQKDataKit/SQKDataKit.h>
#import "Event+Additions.h"

@interface Ticket (Additions)

+(void)importTickets:(NSArray *)events intoContext:(NSManagedObjectContext *)context;
+(void)deleteInvalidTicketsInContext:(NSManagedObjectContext *)context;
+(NSArray *)allTicketsInContext:(NSManagedObjectContext *)context;
+(void)getTicketsForUserFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+ (void)getTicketsForEvent:(PFObject *)event fromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
- (void)saveToParse;
+ (void)getAmountOfTicketsUserOwnsOnEvent:(Event *)event withBlock:(void (^)(int, NSError *))block;
+ (void)getAmountOfTicketsUserOwnsOnEventPFObject:(PFObject *)event withBlock:(void (^)(int, NSError *))block;
- (PFObject *)pfObject;

@end
