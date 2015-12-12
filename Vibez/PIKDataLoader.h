//
//  PIKDataLoader.h
//  Vibez
//
//  Created by Harry Liddell on 12/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIKDataLoader : NSObject

typedef void(^CompletionBlock)(BOOL finished);

@property (nonatomic, copy) CompletionBlock completion;

+ (void)loadEvents:(CompletionBlock)compblock;
+ (void)loadVenues:(CompletionBlock)compblock;
+ (void)loadTickets:(CompletionBlock)compblock;

+ (void)loadAllCustomerData:(CompletionBlock)compblock;
+ (void)loadAllAdminData:(CompletionBlock) compblock;

@end
