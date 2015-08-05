//
//  VenuesCollectionViewController.h
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedCollectionViewController.h"
#import "Vibez-Swift.h"
#import "PIKContextManager.h"
#import "VenueCollectionViewCell.h"
#import "EventCollectionViewCell.h"
#import <UIScrollView+EmptyDataSet.h>

@interface FetchedCollectionViewContainerViewController : SQKFetchedCollectionViewController <UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property BOOL isEventDataDisplayed;

@property (strong, nonatomic) NSIndexPath *indexPathEventSelected;

@property (nonatomic, strong) SQKManagedObjectController *controller;

@end
