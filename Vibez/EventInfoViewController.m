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
#import "PaymentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PIKContextManager.h"
#import "NSString+PIK.h"

@interface EventInfoViewController ()

@end

@implementation EventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons:@"Buy"];
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    if(self.event)
    {
        NSLog(@"Event exists: %@", self.event);
    }
    else
    {
        NSLog(@"Error: Event doesn't exist");
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.getTicketsButton.frame.origin.y)];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 2)];
    [self.view addSubview:self.scrollView];
    
    // Image
    self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height/3)];
    
    [self.eventImageView sd_setImageWithURL:[NSURL URLWithString:self.event.image]
                            placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    self.eventImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.eventImageView.bounds.size.width > self.eventImageView.image.size.width && self.eventImageView.bounds.size.height > self.eventImageView.image.size.height) {
        self.eventImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self.eventImageView.layer setMasksToBounds:YES];
    
    UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.eventImageView.frame.size.width, self.eventImageView.frame.size.height)];
    darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7f];
   
    CGFloat padding = 8;
    CGFloat doublePadding = 16;
    
    // Event Name
    self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.eventImageView.frame)/2 - 20, self.scrollView.frame.size.width, 40)];
    self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:28.0f];
    self.eventNameLabel.textColor = [UIColor whiteColor];
    self.eventNameLabel.textAlignment = NSTextAlignmentCenter;
    self.eventNameLabel.text = self.event.name;
    
    // Event Venue
    self.eventVenueLabel = [[UILabel alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.eventImageView.frame) + padding, self.scrollView.frame.size.width - 32, 25)];
    self.eventVenueLabel.font = [UIFont pik_avenirNextBoldWithSize:20.0f];
    self.eventVenueLabel.textColor = [UIColor whiteColor];
    self.eventVenueLabel.text = self.event.eventVenue;
    
    // Event Date
    self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, self.scrollView.frame.size.width - 32, 25)];
    self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
    self.eventDateLabel.textColor = [UIColor whiteColor];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:self.event.startDate]];
    [dateFormatString insertString:[NSString daySuffixForDate:self.event.startDate] atIndex:6];
    self.eventDateLabel.text = dateFormatString;
    
    // Event Date
    self.eventDateEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.eventDateLabel.frame)/2 + doublePadding, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, self.scrollView.frame.size.width /2 - 32, 25)];
    self.eventDateEndLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
    self.eventDateEndLabel.textColor = [UIColor whiteColor];
    self.eventDateEndLabel.textAlignment = NSTextAlignmentRight;

    [dateFormatter setDateFormat:@"HH:mma"];
    NSMutableString *dateFormatStringBegin = [[NSMutableString alloc] initWithString:[[dateFormatter stringFromDate:self.event.startDate] lowercaseString]];
    NSMutableString *dateFormatStringEnd = [[NSMutableString alloc] initWithString:[[dateFormatter stringFromDate:self.event.endDate] lowercaseString]];
    NSMutableString *beginningEnd = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"%@ - %@", @"Beginning And End"), dateFormatStringBegin, dateFormatStringEnd];
    
    self.eventDateEndLabel.text = beginningEnd;
    
    // Event Description
    self.eventDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(doublePadding, CGRectGetMaxY(self.eventDateLabel.frame) + padding, self.scrollView.frame.size.width - 32, 400)];
    self.eventDescriptionTextView.backgroundColor = [UIColor clearColor];
    self.eventDescriptionTextView.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    self.eventDescriptionTextView.textColor = [UIColor pku_greyColor];
    self.eventDescriptionTextView.text = self.event.eventDescription;
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
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.eventDescriptionTextView.frame))];

    [self.view bringSubviewToFront:self.getTicketsButton];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)bookmarkEventAction
{
    [RKDropdownAlert title:@"Event Bookmarked!" message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        self.event = nil;
    }
}

-(void)setTopBarButtons:(NSString*)titleText
{
    UIBarButtonItem *bookmarkButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkEventAction)];
    
    //UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];

    self.navigationItem.rightBarButtonItem = bookmarkButtonItem;
    self.navigationItem.title = titleText;
    [self.navigationItem setHidesBackButton:NO];
}

- (IBAction)getTicketsButtonTapped:(id)sender {
    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:[PIKContextManager mainContext]];
//    
//    Ticket *ticket = [[Ticket alloc] initWithEntity:entity insertIntoManagedObjectContext:[PIKContextManager mainContext]];
//    PFUser *user = [PFUser currentUser];
//    
//    NSError *error;
//    
//    [ticket setTicketID:@"YASRgKzOBf"];
//    [ticket setHasBeenUsed:@NO];
//    [ticket setHasBeenUpdated:@NO];
//    [ticket setUser:user.objectId];
//    [ticket setEvent:self.event.eventID];
//    [[ticket managedObjectContext] save:&error];
//    
//    if(error)
//    {
//        NSLog(@"Error %@ %s", error.localizedDescription, __PRETTY_FUNCTION__);
//    }
//    
//    [ticket saveToParse];
    
    [self performSegueWithIdentifier:@"eventInfoToBuyTicketSegue" sender:self];
    //PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
    //[self.navigationController pushViewController:paymentVC animated:YES];
}

@end
