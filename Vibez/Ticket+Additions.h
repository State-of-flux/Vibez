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
+(void)getAllFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+(NSArray *)allTicketsInContext:(NSManagedObjectContext *)context;
- (void)saveToParse;

@end
