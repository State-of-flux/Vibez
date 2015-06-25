//
//  WhatsOnViewController.h
//  Vibez
//
//  Created by Harry Liddell on 01/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "EventCollectionViewCell.h"
#import "VenueCollectionViewCell.h"
#import "EventDataSource.h"
#import "VenueDataSource.h"
#import "Vibez-Swift.h"

@interface WhatsOnViewController : GlobalViewController <UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIBarButtonItem *searchBarButtonItem;
@property (nonatomic, strong) UISearchBar *searchBar;


@property (strong, nonatomic) NSMutableArray* apps;
@property BOOL isEventDataDisplayed;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet EventDataSource *eventDataSource;
@property (strong, nonatomic) IBOutlet VenueDataSource *venueDataSource;
@property (weak, nonatomic) IBOutlet ADVSegmentedControl *advSegmentedControl;

- (IBAction)advsegmentedControlTapped:(id)sender;

@end
