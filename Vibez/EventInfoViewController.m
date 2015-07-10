//
//  EventInfoViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventInfoViewController.h"
#import "UIFont+PIK.h"
#import "UIColor+Piktu.h"
#import "RKDropdownAlert.h"

@interface EventInfoViewController ()

@end

@implementation EventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons:@"Vibesy Information"];
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    // Image
    self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height/4)];
    self.eventImageView.image = [UIImage imageNamed:@"plug.jpg"];
    
    UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height/4)];
    darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7f];
   
//    self.eventImageView.contentMode = UIViewContentModeCenter;
//    if (self.eventImageView.bounds.size.width > self.eventImageView.image.size.width && self.eventImageView.bounds.size.height > self.eventImageView.image.size.height) {
//        self.eventImageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
    
    CGFloat padding = 8;
    CGFloat doublePadding = 16;
    
    // Event Name
    self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.eventImageView.frame)/2 - 20, self.scrollView.frame.size.width, 40)];
    self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:28.0f];
    self.eventNameLabel.textColor = [UIColor whiteColor];
    self.eventNameLabel.textAlignment = NSTextAlignmentCenter;
    self.eventNameLabel.text = @"POPTARTS";
    
    // Event Venue
    self.eventVenueLabel = [[UILabel alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.eventImageView.frame) + padding, self.scrollView.frame.size.width - 32, 25)];
    self.eventVenueLabel.font = [UIFont pik_avenirNextBoldWithSize:20.0f];
    self.eventVenueLabel.textColor = [UIColor whiteColor];
    self.eventVenueLabel.text = @"Foundry";
    
    // Event Date
    self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, self.scrollView.frame.size.width - 32, 25)];
    self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
    self.eventDateLabel.textColor = [UIColor pku_greyColor];
    self.eventDateLabel.text = @"14th July 2015";
    
    // Event Date
    self.eventDateEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.eventDateLabel.frame)/2 + doublePadding, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, self.scrollView.frame.size.width /2 - 32, 25)];
    self.eventDateEndLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
    self.eventDateEndLabel.textColor = [UIColor pku_greyColor];
    self.eventDateEndLabel.textAlignment = NSTextAlignmentRight;
    self.eventDateEndLabel.text = @"8:00pm to 3:00am";
    
    // Event Description
    self.eventDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.eventDateLabel.frame) + padding, self.scrollView.frame.size.width - 32, 400)];
    self.eventDescriptionTextView.backgroundColor = [UIColor clearColor];
    self.eventDescriptionTextView.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    self.eventDescriptionTextView.textColor = [UIColor whiteColor];
    self.eventDescriptionTextView.text = @"This is the ultimate Saturday night party, with all the best singalong hits from the early Noughties, 90s and 80s in the Foundry! Plus in Room 2 every week, the best that the 50s rock n roll, 60s pop & soul & 70s rock & disco had to offer!";
    self.eventDescriptionTextView.textContainer.lineFragmentPadding = 0;
    self.eventDescriptionTextView.textContainerInset = UIEdgeInsetsZero;
    self.eventDescriptionTextView.editable = NO;
    self.eventDescriptionTextView.selectable = NO;
    [self.eventDescriptionTextView sizeToFit];
    
    [self.scrollView addSubview:self.eventImageView];
    [self.scrollView addSubview:darkOverlay];
    [self.scrollView addSubview:self.eventNameLabel];
    [self.scrollView addSubview:self.eventDateLabel];
    [self.scrollView addSubview:self.eventDateEndLabel];
    [self.scrollView addSubview:self.eventVenueLabel];
    [self.scrollView addSubview:self.eventDescriptionTextView];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)bookmarkEventAction
{
    [RKDropdownAlert title:@"Event Bookmarked!" message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
}

-(void)setTopBarButtons:(NSString*)titleText
{
    UIBarButtonItem *bookmarkButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkEventAction)];
    
    // UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    //UIFont *customFont = [UIFont fontWithName:@"Futura-Medium" size:24.0];
    //NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    //[settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
    
    //self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
    self.navigationItem.rightBarButtonItem = bookmarkButtonItem;
    
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:titleText];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont pik_avenirNextRegWithSize:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    self.navigationItem.titleView = titleLabel;
    
    // [self.advSegmentedControl setFont:[UIFont fontWithName:@"Futura-Medium" size:14.0f]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationItem setHidesBackButton:NO];
}

- (IBAction)getTicketsButtonTapped:(id)sender {
}
@end
