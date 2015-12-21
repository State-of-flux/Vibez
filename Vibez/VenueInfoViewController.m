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
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@interface VenueInfoViewController ()
{
    CGFloat imageHeight;
}
@end

@implementation VenueInfoViewController

+ (instancetype)createWithVenue:(Venue *)venue {
    UIStoryboard *storyboardMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    VenueInfoViewController *instance = (VenueInfoViewController *)[storyboardMain instantiateViewControllerWithIdentifier:NSStringFromClass([VenueInfoViewController class])];
    
    [instance setVenue:venue];
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons:@"Venue"];
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [self layoutSubviews];
    [[self scrollView] setDelegate:self];
    imageHeight = self.venueImageView.frame.size.height;
    [[self view] bringSubviewToFront:[self buttonGetDirections]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yPos = -scrollView.contentOffset.y;
    if (yPos > 0) {
        CGRect imgRect = self.venueImageView.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = imageHeight+yPos;
        [self.venueImageView setFrame:imgRect];
        [self.blurView setFrame:self.venueImageView.frame];
        [self.venueNameLabel setCenter:CGPointMake(self.venueImageView.frame.size.width/2, self.venueImageView.frame.size.height/2)];
    }
}

- (void)createSocialMediaButtons {
    CGRect frame = [[self scrollView] frame];
    CGFloat yValue = CGRectGetMaxY(self.venueDescriptionTextView.frame) + 16;
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    [factory setColors:@[[UIColor whiteColor], [UIColor whiteColor]]];
    
    [self setButtonFacebook:[UIButton buttonWithType:UIButtonTypeCustom]];
    [[self buttonFacebook] setFrame:CGRectMake(0, yValue, frame.size.width/3 , 50.0f)];
    [[self buttonFacebook] setBackgroundColor:[UIColor pku_FacebookColor]];
    [[self buttonFacebook] setImage:[factory createImageForIcon:NIKFontAwesomeIconFacebook] forState:UIControlStateNormal];
    [[self buttonFacebook] addTarget:self action:@selector(buttonFacebookPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setButtonTwitter:[UIButton buttonWithType:UIButtonTypeCustom]];
    [[self buttonTwitter] setFrame:CGRectMake(CGRectGetMaxX([[self buttonFacebook] frame]), yValue, frame.size.width/3, 50.0f)];
    [[self buttonTwitter] setBackgroundColor:[UIColor pku_TwitterColor]];
    [[self buttonTwitter] setImage:[factory createImageForIcon:NIKFontAwesomeIconTwitter] forState:UIControlStateNormal];
    [[self buttonTwitter] addTarget:self action:@selector(buttonTwitterPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setButtonInstagram:[UIButton buttonWithType:UIButtonTypeCustom]];
    [[self buttonInstagram] setFrame:CGRectMake(CGRectGetMaxX([[self buttonTwitter] frame]), yValue, frame.size.width/3, 50.0f)];
    [[self buttonInstagram] setBackgroundColor:[UIColor pku_InstagramColor]];
    [[self buttonInstagram] setImage:[factory createImageForIcon:NIKFontAwesomeIconInstagram] forState:UIControlStateNormal];
    [[self buttonInstagram] addTarget:self action:@selector(buttonInstagramPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonFacebookPressed:(id)sender {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/GWXTYwMaEvB"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://facebook.com/%@", [[self venue] facebook]]]];
    }
}

- (void)buttonTwitterPressed:(id)sender {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/GWXTYwMaEvB"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", [[self venue] twitter]]]];
    }
}

- (void)buttonInstagramPressed:(id)sender {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/GWXTYwMaEvB"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://instagram.com/%@", [[self venue] instagram]]]];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)layoutSubviews {
    CGFloat padding = 8;
    CGFloat paddingDouble = 16;
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat heightWithoutNavOrTabOrStatus = (height - (self.buttonGetDirections.frame.size.height));
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus)];
    [self.view addSubview:self.scrollView];
    
    // Image
    self.venueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus/2.5)];
    
    [[self venueImageView] sd_setImageWithURL:[NSURL URLWithString:[[self venue] image]]
                           placeholderImage:nil
                                  completed:nil];
    
    self.venueImageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    if (self.venueImageView.bounds.size.width > self.venueImageView.image.size.width && self.venueImageView.bounds.size.height > self.venueImageView.image.size.height) {
//        self.venueImageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
    
    [self.venueImageView.layer setMasksToBounds:YES];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurView.frame = self.venueImageView.bounds;
    
    //[self createSocialMediaButtons];
    
    // Event Name
    self.venueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(self.venueImageView.frame)/2 - 40, width - padding, 70)];
    self.venueNameLabel.font = [UIFont pik_montserratBoldWithSize:28.0f];
    self.venueNameLabel.textColor = [UIColor whiteColor];
    self.venueNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.venueNameLabel setText:self.venue.name];
    [self.venueNameLabel sizeToFit];
    [self.venueNameLabel setCenter:CGPointMake(self.venueImageView.frame.size.width/2, self.venueImageView.frame.size.height/2)];
    
    // Event Venue
    self.venueTownLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.venueImageView.frame) + paddingDouble, width - 32, 25)];
    self.venueTownLabel.font = [UIFont pik_avenirNextBoldWithSize:20.0f];
    self.venueTownLabel.textColor = [UIColor whiteColor];
    self.venueTownLabel.text = self.venue.town;
    
    // Event Description
    self.venueDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.venueTownLabel.frame) + padding, width - 32, 400)];
    self.venueDescriptionTextView.backgroundColor = [UIColor clearColor];
    self.venueDescriptionTextView.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    self.venueDescriptionTextView.textColor = [UIColor pku_greyColor];
    self.venueDescriptionTextView.text = self.venue.venueDescription;
    self.venueDescriptionTextView.textContainer.lineFragmentPadding = 0;
    self.venueDescriptionTextView.textContainerInset = UIEdgeInsetsZero;
    self.venueDescriptionTextView.editable = NO;
    self.venueDescriptionTextView.selectable = NO;
    [self.venueDescriptionTextView setScrollEnabled:NO];
    [self.venueDescriptionTextView sizeToFit];
    
    //[self createUpcomingEventButton];
    [self createSocialMediaButtons];
    
    [self.scrollView addSubview:self.venueImageView];
    [self.scrollView addSubview:self.blurView];
    
    [self.scrollView addSubview:self.buttonFacebook];
    [self.scrollView addSubview:self.buttonTwitter];
    [self.scrollView addSubview:self.buttonInstagram];

    [self.scrollView addSubview:self.venueNameLabel];
    [self.scrollView addSubview:self.venueTownLabel];
    [self.scrollView addSubview:self.venueDescriptionTextView];
    [[self scrollView] addSubview:[self buttonUpcomingEvent]];
    
    CGFloat yValueScrollView = CGRectGetMaxY(self.buttonFacebook.frame) + [[self buttonGetDirections] frame].size.height + paddingDouble;
    
    if (yValueScrollView < [[self view] frame].size.height) {
        yValueScrollView = [[self view] frame].size.height;
    }
    
    [[self scrollView] setContentSize:CGSizeMake(width, yValueScrollView)];
}

- (void)createUpcomingEventButton {
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    [factory setColors:@[[UIColor pku_purpleColor], [UIColor pku_purpleColor]]];
    
    [self setButtonUpcomingEvent:[UIButton buttonWithType:UIButtonTypeCustom]];
    [[self buttonUpcomingEvent] setFrame:CGRectMake(0, CGRectGetMaxY([[self venueDescriptionTextView] frame]) + 16, [[self view] frame].size.width, 50.0f)];
    [[self buttonUpcomingEvent] setBackgroundColor:[UIColor pku_lightBlack]];
    [[self buttonUpcomingEvent] setTitle:@"Upcoming Event" forState:UIControlStateNormal];
    [[[self buttonUpcomingEvent] titleLabel] setFont:[UIFont pik_avenirNextBoldWithSize:18.0f]];
    [[[self buttonUpcomingEvent] layer] setBorderWidth:1];
    [[[self buttonUpcomingEvent] layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self buttonUpcomingEvent] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self buttonUpcomingEvent] setImage:[factory createImageForIcon:NIKFontAwesomeIconHome] forState:UIControlStateNormal];
    [[self buttonUpcomingEvent] setTintColor:[UIColor whiteColor]];
    //[self adjustButtonView:buttonVenue toSize:CGSizeMake(buttonVenue.frame.size.width + 15.0f, buttonVenue.frame.size.height + 5.0f)];
    [[self buttonUpcomingEvent] addTarget:self action:@selector(buttonUpcomingEventPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addBorder:UIRectEdgeTop | UIRectEdgeBottom color:[UIColor pku_lightBlack] thickness:1.0f button:[self buttonUpcomingEvent]];
}

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness button:(UIButton *)button {
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(button.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(button.frame) - thickness, CGRectGetWidth(button.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(button.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(button.frame) - thickness, 0, thickness, CGRectGetHeight(button.frame));
            break;
        default:
            break;
    }
    
    [border setBackgroundColor:[color CGColor]];
    [[button layer] addSublayer:border];
    
    return border;
}

- (void)buttonUpcomingEventPressed:(id)sender {
    
}

-(void)setTopBarButtons:(NSString*)titleText {

    [[self navigationItem] setTitle:titleText];
    
    if ([[self venue] location]) {
        NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
        [factory setColors:@[[UIColor pku_purpleColor], [UIColor pku_purpleColor]]];
        UIBarButtonItem *buttonMapMarker = [[UIBarButtonItem alloc] initWithImage:[factory createImageForIcon:NIKFontAwesomeIconMapMarker] style:UIBarButtonItemStylePlain target:self action:@selector(buttonLocationPressed)];
        [[self navigationItem] setRightBarButtonItem:buttonMapMarker];
    } else {
        [[self buttonGetDirections] setHidden:YES];
        [[self buttonGetDirections] setEnabled:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        self.indexPathVenueSelected = nil;
    }
}

-(void)buttonLocationPressed {
    [self performSegueWithIdentifier:@"toMapSegue" sender:self];
    NSLog(@"location button clicked");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMapSegue"]) {
        LocationViewController *locationVC = [segue destinationViewController];
        [locationVC setVenue:[self venue]];
    }
}

- (IBAction)buttonGetDirectionsPressed:(id)sender {
    [self performSegueWithIdentifier:@"toMapSegue" sender:self];
    NSLog(@"location button clicked");
}

@end
