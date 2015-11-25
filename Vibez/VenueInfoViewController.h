//
//  VenueInfoViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "Venue.h"

@interface VenueInfoViewController : GlobalViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *venueImageView;
@property (strong, nonatomic) UILabel *venueNameLabel;
@property (strong, nonatomic) UILabel *venueTownLabel;
@property (strong, nonatomic) UITextView *venueDescriptionTextView;

@property (strong, nonatomic) UIButton *buttonUpcomingEvent;
@property (strong, nonatomic) UIButton *buttonFacebook;
@property (strong, nonatomic) UIButton *buttonTwitter;
@property (strong, nonatomic) UIButton *buttonInstagram;

@property (strong, nonatomic) NSIndexPath *indexPathVenueSelected;

@property (strong, nonatomic) Venue *venue;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIVisualEffectView *blurView;

@property (weak, nonatomic) IBOutlet UIButton *buttonGetDirections;

- (IBAction)buttonGetDirectionsPressed:(id)sender;
+ (instancetype)createWithVenue:(Venue *)venue;

@end
