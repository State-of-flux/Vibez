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
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import <Reachability/Reachability.h>

static CGFloat kParallaxRatio = 0.40;
static CGFloat kMainImageHeight = 180.0;

@interface EventInfoViewController ()
{
    Reachability *reachability;
}
@end

@implementation EventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self setTopBarButtons:@""];
    [self layoutSubviews];
    [self setCustomNavigationBackButton];
    
    
    reachability = [Reachability reachabilityForInternetConnection];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    
    picker.dataSource = self;
    picker.delegate = self;
    
    [self.scrollView setDelegate:self];
    
    self.arrayOfQuantities = [NSMutableArray array];
    
    for(NSInteger i = 1; i <= 10; i++)
    {
        [self.arrayOfQuantities addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    NSLog(@"yOffset:%f",yOffset);
    CGRect f = self.eventImageView.frame;
    if (yOffset >= 0) {
        f.origin.y = -(yOffset*kParallaxRatio);
    } else {
        f.size.height = kMainImageHeight - yOffset;
    }
    self.eventImageView.frame = f;
    self.eventNameLabel.frame = f;
    //self.blurView.frame = f;
    self.darkOverlay.frame = f;
    //self.viewImageLabelHolder.frame = f;
    NSLog(@"height:%f   y:%f", self.eventImageView.frame.size.height, self.eventImageView.frame.origin.y);
}

-(void)layoutSubviews
{
    CGFloat statusBarFrame = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat padding = 8;
    CGFloat paddingDouble = 16;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat heightWithoutNavOrTabOrStatus = (height - (navBarHeight + tabBarHeight + statusBarFrame));
    
    //    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus - self.getTicketsButton.frame.size.height)];
    //    [self.scrollView setDelegate:self];
    //
    //    [self.view addSubview:self.scrollView];
    //
    //    // Image
    //self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus/3)];
    
    [self.eventImageView sd_setImageWithURL:[NSURL URLWithString:self.event.image]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    self.eventImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (self.eventImageView.bounds.size.width > self.eventImageView.image.size.width && self.eventImageView.bounds.size.height > self.eventImageView.image.size.height) {
        self.eventImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self.eventImageView.layer setMasksToBounds:YES];
    
    //UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //self.blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //self.blurView.frame = self.eventImageView.frame;
    //[self.eventImageView addSubview:self.blurView];
    
    self.darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.eventImageView.frame.size.width, self.eventImageView.frame.size.height)];
    self.darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.65f];
    [self.eventImageView addSubview:self.darkOverlay];
    
    [self.eventNameLabel setText:[[self event] name]];
    
    [self.eventVenueButton setTitle:[[self event] eventVenue] forState:UIControlStateNormal];
    [self.eventVenueButton sizeToFit];
    
    //    // Event Name
    //    self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(self.eventImageView.frame)/2 - 40, width - padding, 70)];
    //    self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:28.0f];
    //    self.eventNameLabel.textColor = [UIColor whiteColor];
    //    self.eventNameLabel.textAlignment = NSTextAlignmentCenter;
    //    self.eventNameLabel.text = self.event.name;
    //    self.eventNameLabel.numberOfLines = 2;
    //
    //    // Event Venue
    //    self.eventVenueLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.eventImageView.frame) + padding, width - 32, 25)];
    //    self.eventVenueLabel.font = [UIFont pik_avenirNextBoldWithSize:20.0f];
    //    self.eventVenueLabel.textColor = [UIColor whiteColor];
    //    self.eventVenueLabel.text = self.event.eventVenue;
    //
    //    // Event Date
    //    self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, width - 32, 25)];
    //    self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
    //    self.eventDateLabel.textColor = [UIColor whiteColor];
    //
    //    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //    [dateFormatter setDateFormat:@"EEE dd MMM"];
    //    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:self.event.startDate]];
    //    [dateFormatString insertString:[NSString daySuffixForDate:self.event.startDate] atIndex:6];
    //    self.eventDateLabel.text = dateFormatString;
    //
    //    // Event Date
    //    self.eventDateEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.eventDateLabel.frame)/2, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, width / 2 - 32, 25)];
    //    self.eventDateEndLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    //    self.eventDateEndLabel.textColor = [UIColor whiteColor];
    //    self.eventDateEndLabel.textAlignment = NSTextAlignmentRight;
    //
    //    [dateFormatter setDateFormat:@"HH:mma"];
    //    NSMutableString *dateFormatStringBegin = [[NSMutableString alloc] initWithString:[[dateFormatter stringFromDate:self.event.startDate] lowercaseString]];
    //    NSMutableString *dateFormatStringEnd = [[NSMutableString alloc] initWithString:[[dateFormatter stringFromDate:self.event.endDate] lowercaseString]];
    //    NSMutableString *beginningEnd = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"%@ - %@", @"Beginning And End"), dateFormatStringBegin, dateFormatStringEnd];
    //
    //    self.eventDateEndLabel.text = beginningEnd;
    //
    //    // Event Description
    //    self.eventDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.eventDateLabel.frame) + padding, width - 32, 400)];
    //    self.eventDescriptionTextView.backgroundColor = [UIColor clearColor];
    //    self.eventDescriptionTextView.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    //    self.eventDescriptionTextView.textColor = [UIColor pku_greyColor];
    //    self.eventDescriptionTextView.text = self.event.eventDescription;
    //    self.eventDescriptionTextView.textContainer.lineFragmentPadding = 0;
    //    self.eventDescriptionTextView.textContainerInset = UIEdgeInsetsZero;
    //    self.eventDescriptionTextView.editable = NO;
    //    self.eventDescriptionTextView.selectable = NO;
    //    [self.eventDescriptionTextView sizeToFit];
    //
    //    [self.scrollView addSubview:self.eventImageView];
    //    [self.scrollView addSubview:darkOverlay];
    //    [self.scrollView addSubview:self.eventNameLabel];
    //    [self.scrollView addSubview:self.eventDateLabel];
    //    [self.scrollView addSubview:self.eventDateEndLabel];
    //    [self.scrollView addSubview:self.eventVenueLabel];
    //    [self.scrollView addSubview:self.eventDescriptionTextView];
    //
    //    //[self.scrollView setContentSize:CGSizeMake(width, CGRectGetMaxY(self.eventDescriptionTextView.frame))];
    [self.scrollView setContentSize:CGSizeMake(0, self.scrollView.frame.size.height + 200)];
    //
    //
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    [self.getTicketsButton setImage:[factory createImageForIcon:NIKFontAwesomeIconTicket] forState:UIControlStateNormal];
    [self.getTicketsButton setTintColor:[UIColor whiteColor]];
    
    //    if([[self.event quantity] isEqualToNumber:@0])
    //    {
    //        [self.getTicketsButton setImage:[factory createImageForIcon:NIKFontAwesomeIconTicket] forState:UIControlStateDisabled];
    //        [self.getTicketsButton setTintColor:[UIColor darkGrayColor]];
    //        [self.getTicketsButton setTitle:@"SOLD OUT" forState:UIControlStateDisabled];
    //        [self.getTicketsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    //        [self.getTicketsButton setBackgroundColor:[UIColor lightGrayColor]];
    //        [self.getTicketsButton setEnabled:NO];
    //    }
    //
    //    [self.view bringSubviewToFront:self.getTicketsButton];
}

- (void)setCustomNavigationBackButton
{
    UIImage *backBtn = [UIImage imageNamed:@"first_selected.png"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //self.navigationItem.backBarButtonItem.title = @"";
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    [self.navigationItem.backBarButtonItem setTitle:@"Title here"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
}

//- (UIStatusBarStyle) preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

-(void)shareEvent
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
    
    //[RKDropdownAlert title:@"Event Shared" message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
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
    //NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    //UIBarButtonItem *buttonShare = [[UIBarButtonItem alloc] initWithImage:[factory createImageForIcon:NIKFontAwesomeIconShareAlt] style:UIBarButtonItemStylePlain target:self action:@selector(shareEvent)];
    UIBarButtonItem *buttonShare = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleDone target:self action:@selector(shareEvent)];
    self.navigationItem.rightBarButtonItem = buttonShare;
    self.navigationItem.title = titleText;
    //[self.navigationItem setHidesBackButton:NO];
}

- (IBAction)getTicketsButtonTapped:(id)sender
{
    // Grabbing the event here so it can be attached to the Order object.
    if([reachability isReachable])
    {
        [ActionSheetStringPicker showPickerWithTitle:@"How many tickets?"
                                                rows:[self.arrayOfQuantities copy]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                     picker, (long)selectedIndex, selectedValue);
                                               
                                               self.quantitySelected = [selectedValue integerValue];
                                               
                                               if(self.quantitySelected)
                                               {
                                                   NSInteger quantityOfTickets = [Ticket getAmountOfTicketsUserOwnsOnEvent:self.event];
                                                   
                                                   if((quantityOfTickets + self.quantitySelected) <= 10)
                                                   {
                                                       [self createOrderAndProceed];
                                                   }
                                                   else
                                                   {
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid", @"Invalid") message:NSLocalizedString(@"You can only buy up to 10 tickets per event.", @"You can only buy up to 10 tickets per event.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                                                       [alert show];
                                                   }
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
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
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
        if([reachability isReachable]) {
            OrderInfoViewController *destinationVC = segue.destinationViewController;
            destinationVC.order = [Order createOrderForEvent:self.eventPFObject withQuantity:self.quantitySelected];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alertView show];
        }
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

- (IBAction)buttonVenuePressed:(id)sender {
}
@end
