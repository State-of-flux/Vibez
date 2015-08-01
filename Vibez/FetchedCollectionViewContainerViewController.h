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
#import "EventDataSource.h"
#import "VenueDataSource.h"

@interface FetchedCollectionViewContainerViewController : SQKFetchedCollectionViewController <UICollectionViewDataSource>

@property BOOL isEventDataDisplayed;
@property (strong, nonatomic) IBOutlet EventDataSource *eventDataSource;
@property (strong, nonatomic) IBOutlet VenueDataSource *venueDataSource;

@property (strong, nonatomic) NSIndexPath *indexPathEventSelected;

@property (nonatomic, strong) SQKManagedObjectController *controller;

@end
