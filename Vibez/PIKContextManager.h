//
//  PIKContextManager.h
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKContextManager.h"
#import <SQKDataKit/SQKDataKit.h>
#import "User+Additions.h"
#import "Venue+Additions.h"

@interface PIKContextManager : SQKContextManager

/**
 *  Gets the main context of the context manager.
 *
 *  @return The main context of the context manager.
 */
+ (NSManagedObjectContext *)mainContext;

/**
 *  So saving operations don't block the main thread new private contexts
 *  are used to take the operation off the main thread.
 *
 *  @return A new private context that will mirror the main context at the point of exicution.
 */
+ (NSManagedObjectContext *)newPrivateContext;

@end
