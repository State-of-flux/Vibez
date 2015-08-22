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
#import "Order+Additions.h"
#import "OrderInfoViewController.h"
#import "PIKParseManager.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

@interface EventInfoViewController ()

@end

@implementation EventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons:@"Buy"];
    [self layoutSubviews];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    
    picker.dataSource = self;
    picker.delegate = self;
    
    self.arrayOfQuantities = [NSMutableArray array];
    
    for(NSInteger i = 1; i < 11; i++)
    {
        [self.arrayOfQuantities addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
}

-(void)layoutSubviews
{
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
    NSString* title = self.event.name;
    NSDate* startDate = self.event.startDate;
    NSString* description = self.event.eventDescription;
    NSString* venue = self.event.eventVenue;
    
    NSDecimalNumber *overallPrice = [self addNumber:[self.event price] andOtherNumber:[self.event bookingFee]];
    NSString *eventPriceString = [NSString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [overallPrice floatValue]];
    
    NSArray* sharedArray=@[title, venue, description, startDate, eventPriceString];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    UIActivityViewController * activityVC = [[UIActivityViewController alloc] initWithActivityItems:sharedArray applicationActivities:nil];
    
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    //    [RKDropdownAlert title:@"Event Bookmarked!" message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
    
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"Cancel"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"Post to Facebook", @"Tweet it", @"Email", @"Text Message", nil];
    //
    //    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            // Facebook
        case 0:
            NSLog(@"Facebook");
            [self shareEventFacebook];
            break;
            // Twitter
        case 1:
            NSLog(@"Twitter");
            [self shareEventTwitter];
            break;
            // Email
        case 2:
            NSLog(@"Email");
            [self shareEventEmail];
            break;
            // Text Message
        case 3:
            NSLog(@"Text Message");
            [self shareEventTextMessage];
            break;
            
        default:
            break;
    }
}

-(void)shareEventFacebook
{
    
}

-(void)shareEventTwitter
{
    
}

-(void)shareEventEmail
{
    
}

-(void)shareEventTextMessage
{
    
}

-(NSDecimalNumber *)addNumber:(NSDecimalNumber *)num1 andOtherNumber:(NSDecimalNumber *)num2
{
    NSDecimalNumber *added = [[NSDecimalNumber alloc] initWithInt:0];
    return [added decimalNumberByAdding:[num1 decimalNumberByAdding:num2]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        //self.event = nil;
    }
}

-(void)setTopBarButtons:(NSString*)titleText
{
    UIBarButtonItem *bookmarkButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(bookmarkEventAction)];
    
    //UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    self.navigationItem.rightBarButtonItem = bookmarkButtonItem;
    self.navigationItem.title = titleText;
    [self.navigationItem setHidesBackButton:NO];
}

- (IBAction)getTicketsButtonTapped:(id)sender
{
    // Grabbing the event here so it can be attached to the Order object.
    
    [ActionSheetStringPicker showPickerWithTitle:@"How many tickets?"
                                            rows:[self.arrayOfQuantities copy]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           
                                           self.quantitySelected = [selectedValue integerValue];
                                           
                                           if(self.quantitySelected)
                                           {
                                               [self createOrderAndProceed];
                                           }
                                           else
                                           {
                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"An error occured, restarting the app my resolve this issue.", @"An error occured, restarting the app my resolve this issue.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                                               [alert show];
                                           }
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    
   
}

- (void)createOrderAndProceed
{
    [PIKParseManager pfObjectForClassName:@"Event" remoteUniqueKey:@"objectId" uniqueValue:self.event.eventID success:^(PFObject *pfObject)
     {
         self.eventPFObject = pfObject;
         
         // If found we can proceed to the next page.
         
         if(self.eventPFObject)
         {
             [self performSegueWithIdentifier:@"eventInfoToOrderInfoSegue" sender:self];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"An error occured whilst trying to find the event, please try again.", @"An error occured whilst trying to find the event, please try again.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay")  otherButtonTitles:nil, nil];
             [alert show];
         }
         
     }
                                  failure:^(NSError *error)
     {
         NSLog(@"Error: %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"eventInfoToOrderInfoSegue"])
    {
        // Here we create the order using the event and quantity, the quantity denotes the amount of ticket objects created.
        
        OrderInfoViewController *destinationVC = segue.destinationViewController;
        destinationVC.order = [Order createOrderForEvent:self.eventPFObject withQuantity:self.quantitySelected];
    }
}

#pragma mark - UIPickerView Methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.arrayOfQuantities count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.arrayOfQuantities[row];
}

@end
