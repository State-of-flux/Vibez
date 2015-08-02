//
//  VenueFetchedCollectionViewContainerViewController.h
//  Vibez
//
//  Created by Harry Liddell on 21/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedCollectionViewController.h"
#import "Vibez-Swift.h"
#import "PIKContextManager.h"
#import <UIScrollView+EmptyDataSet.h>

@interface VenueFetchedCollectionViewContainerViewController : SQKFetchedCollectionViewController <UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) SQKManagedObjectController *controller;
@property (strong, nonatomic) NSIndexPath *indexPathVenueSelected;

@end
