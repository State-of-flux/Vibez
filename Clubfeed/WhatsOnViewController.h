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
#import "Clubfeed-Swift.h"

@interface WhatsOnViewController : GlobalViewController

@property BOOL isEventDataDisplayed;

@property (weak, nonatomic) IBOutlet AVSegmentedControl *advSegmentedControl;

- (IBAction)advsegmentedControlTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewSegmentedControl;

@property (nonatomic, strong) UIViewController *currentVC;

@end
