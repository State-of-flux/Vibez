//
//  PIKContextManager.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "PIKContextManager.h"


static SQKContextManager *sharedManger;

@implementation PIKContextManager

+ (SQKContextManager *)sharedManger
{
    if (!sharedManger)
    {
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        sharedManger = [[SQKContextManager alloc] initWithStoreType:NSSQLiteStoreType managedObjectModel:model
                                     orderedManagedObjectModelNames:@[@"Vibez"]
                                                           storeURL:nil];
    }
    
    return sharedManger;
}

+ (NSManagedObjectContext *)mainContext
{
    return [[PIKContextManager sharedManger] mainContext];
}

+ (NSManagedObjectContext *)newPrivateContext
{
    return [[PIKContextManager sharedManger] newPrivateContext];
}

@end
