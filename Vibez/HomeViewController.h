//
//  HomeViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "EventCollectionViewCell.h"
#import "VenueCollectionViewCell.h"
#import "EventDataSource.h"
#import "VenueDataSource.h"

@interface HomeViewController : GlobalViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray* apps;
@property BOOL isEventDataDisplayed;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsVenuesSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet EventDataSource *eventDataSource;
@property (strong, nonatomic) IBOutlet VenueDataSource *venueDataSource;
- (IBAction)segmentedControlTapped:(id)sender;

@end
