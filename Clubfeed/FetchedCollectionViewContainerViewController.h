//
//  VenuesCollectionViewController.h
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedCollectionViewController.h"
//#import "Vibez-Swift.h"
#import "PIKSegmentedControl.h"
#import "PIKContextManager.h"
#import "VenueCollectionViewCell.h"
#import "EventCollectionViewCell.h"
#import <UIScrollView+EmptyDataSet.h>

@interface FetchedCollectionViewContainerViewController : SQKFetchedCollectionViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property BOOL isEventDataDisplayed;

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) NSIndexPath *indexPathSelected;
//@property (nonatomic, strong) SQKManagedObjectController *controller;

@end
