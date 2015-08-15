//
//  Ticket+Additions.h
//  Vibez
//
//  Created by Harry Liddell on 29/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Ticket.h"
#import "PIKParseManager.h"
#import <SQKDataKit/SQKDataKit.h>

@interface Ticket (Additions)

+(void)importTickets:(NSArray *)events intoContext:(NSManagedObjectContext *)context;
+(void)deleteInvalidTicketsInContext:(NSManagedObjectContext *)context;
+(NSArray *)allTicketsInContext:(NSManagedObjectContext *)context;
+(void)getTicketsForUserFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
- (void)saveToParse;

@end
