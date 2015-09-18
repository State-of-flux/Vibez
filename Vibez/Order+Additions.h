//
//  Order+Additions.h
//  Vibez
//
//  Created by Harry Liddell on 20/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Order.h"
#import "PIKParseManager.h"
#import <SQKDataKit/SQKDataKit.h>

@interface Order (Additions)

+(void)importOrders:(NSArray *)events intoContext:(NSManagedObjectContext *)context;
+(void)deleteInvalidOrdersInContext:(NSManagedObjectContext *)context;
+(NSArray *)allOrdersInContext:(NSManagedObjectContext *)context;
+(void)getOrdersForUserFromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+ (void)getOrdersForEvent:(PFObject *)event fromParseWithSuccessBlock:(void (^)(NSArray *objects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
- (void)saveToParse;
+ (PFObject *)createOrderForEvent:(PFObject *)event withQuantity:(NSInteger)quantity;

@end
