//
//  VenueInfoViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueInfoViewController.h"
#import "LocationViewController.h"
#import "UIColor+Piktu.h"
#import "UIFont+PIK.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VenueInfoViewController ()

@end

@implementation VenueInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons:@"Vibes"];
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    
    
    Event *event = [self.controller.managedObjects objectAtIndex:indexPath.row];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 2)];
    [self.view addSubview:self.scrollView];
    
    // Image
    self.venueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height/3)];
    
    [self.venueImageView sd_setImageWithURL:[NSURL URLWithString:self.venueSelected.image]
                           placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    self.venueImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.venueImageView.bounds.size.width > self.venueImageView.image.size.width && self.venueImageView.bounds.size.height > self.venueImageView.image.size.height) {
        self.venueImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self.venueImageView.layer setMasksToBounds:YES];
    
    UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.venueImageView.frame.size.width, self.venueImageView.frame.size.height)];
    darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7f];
    
    CGFloat padding = 8;
    CGFloat doublePadding = 16;

    // Event Name
    self.venueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.venueImageView.frame)/2 - 20, self.scrollView.frame.size.width, 40)];
    self.venueNameLabel.font = [UIFont pik_montserratBoldWithSize:28.0f];
    self.venueNameLabel.textColor = [UIColor whiteColor];
    self.venueNameLabel.textAlignment = NSTextAlignmentCenter;
    self.venueNameLabel.text = @"FOUNDRY";
    
    // Event Venue
    self.venueTownLabel = [[UILabel alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.venueImageView.frame) + padding, self.scrollView.frame.size.width - 32, 25)];
    self.venueTownLabel.font = [UIFont pik_avenirNextBoldWithSize:20.0f];
    self.venueTownLabel.textColor = [UIColor whiteColor];
    self.venueTownLabel.text = @"Sheffield";
    
    // Event Description
    self.venueDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.venueTownLabel.frame) + padding, self.scrollView.frame.size.width - 32, 400)];
    self.venueDescriptionTextView.backgroundColor = [UIColor clearColor];
    self.venueDescriptionTextView.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    self.venueDescriptionTextView.textColor = [UIColor pku_greyColor];
    self.venueDescriptionTextView.text = @"This is the ultimate Saturday night party, with all the best singalong hits from the early Noughties, 90s and 80s in the Foundry! Plus in Room 2 every week, the best that the 50s rock n roll, 60s pop & soul & 70s rock & disco had to offer!";
    self.venueDescriptionTextView.textContainer.lineFragmentPadding = 0;
    self.venueDescriptionTextView.textContainerInset = UIEdgeInsetsZero;
    self.venueDescriptionTextView.editable = NO;
    self.venueDescriptionTextView.selectable = NO;
    [self.venueDescriptionTextView sizeToFit];
    
    [self.scrollView addSubview:self.venueImageView];
    [self.scrollView addSubview:darkOverlay];
    [self.scrollView addSubview:self.venueNameLabel];
    [self.scrollView addSubview:self.venueTownLabel];
    [self.scrollView addSubview:self.venueDescriptionTextView];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)setTopBarButtons:(NSString*)titleText
{
    UIBarButtonItem *buttonLocation = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buttonLocationPressed)];
    
    self.navigationItem.rightBarButtonItem = buttonLocation;
    self.navigationItem.title = titleText;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        self.indexPathVenueSelected = nil;
    }
}

-(void)buttonLocationPressed
{
    [self performSegueWithIdentifier:@"toMapSegue" sender:self];
    NSLog(@"location button clicked");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMapSegue"]) {
        LocationViewController *locationVC = segue.destinationViewController;
        locationVC.latCoord = 53.3764;
        locationVC.longCoord = -1.4716;
    }
}

@end
