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
#import <SDWebImage/SDWebImageDownloader.h>
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
#import "UIScrollView+TwitterCover.h"

static CGFloat kImageOriginHight = 180.f;

@interface EventInfoViewController () {
    Reachability *reachability;
    CGFloat imageHeight;
}
@end

@implementation EventInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopBarButtons:@"Event"];
    [self layoutSubviews];
    [self setCustomNavigationBackButton];
    
    imageHeight = self.eventImageView.frame.size.height;
    
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

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yPos = -scrollView.contentOffset.y;
    if (yPos > 0) {
        CGRect imgRect = self.eventImageView.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = imageHeight+yPos;
        [self.eventImageView setFrame:imgRect];
        [self.blurView setFrame:imgRect];
        [self.eventNameLabel setCenter:CGPointMake(self.eventImageView.frame.size.width/2, self.eventImageView.frame.size.height/2)];
    }
}

- (void)setCustomNavigationBackButton {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIImage *myIcon = [self imageWithImage:[UIImage imageNamed:@"backArrow.png"] scaledToSize:CGSizeMake(36, 36)];
    
    [self.navigationController.navigationBar setTintColor:[UIColor pku_purpleColor]];
    self.navigationController.navigationBar.backIndicatorImage = myIcon;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = myIcon;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)adjustButtonView:(UIButton *)button toSize:(CGSize)size
{
    CGRect previousFrame = button.frame;
    CGRect newFrame = button.frame;
    newFrame.size = size;
    CGFloat adjustX = (size.width - previousFrame.size.width)/2;
    CGFloat adjustY = (size.height - previousFrame.size.height)/2;
    newFrame.origin.x = previousFrame.origin.x - adjustX;
    newFrame.origin.y = previousFrame.origin.y - adjustY;
    button.frame = newFrame;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(adjustY, adjustX, adjustY, adjustX);
    button.contentEdgeInsets = edgeInsets;
}

-(void)layoutSubviews
{
    CGFloat statusBarFrame = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat padding = 8;
    CGFloat paddingDouble = 16;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat heightWithoutNavOrTabOrStatus = (height - (self.getTicketsButton.frame.size.height));
    

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus)];
    [self.view addSubview:self.scrollView];
    
    // Image
    self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus/2.5)];
    [self.eventImageView sd_setImageWithURL:[NSURL URLWithString:self.event.image]
                           placeholderImage:nil
                                  completed:nil];
    
    self.eventImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.eventImageView.layer setMasksToBounds:YES];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurView.frame = self.eventImageView.frame;
    [self.eventImageView addSubview:self.blurView];
    
    [self.eventNameLabel setText:[[self event] name]];
    
    // Event Name
    self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(self.eventImageView.frame)/2 - 40, width - padding, 70)];
    self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:28.0f];
    self.eventNameLabel.textColor = [UIColor whiteColor];
    self.eventNameLabel.textAlignment = NSTextAlignmentCenter;
    self.eventNameLabel.text = self.event.name;
    self.eventNameLabel.numberOfLines = 2;
    [self.eventNameLabel setCenter:CGPointMake(self.eventImageView.frame.size.width/2, self.eventImageView.frame.size.height/2)];
    
    // Event Venue
    self.eventVenueLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.eventImageView.frame) + padding, width - 32, 25)];
    self.eventVenueLabel.font = [UIFont pik_avenirNextBoldWithSize:20.0f];
    self.eventVenueLabel.textColor = [UIColor whiteColor];
    self.eventVenueLabel.text = self.event.eventVenue;
    
    UIButton *buttonVenue = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonVenue setFrame:CGRectMake(paddingDouble + 7.5f, CGRectGetMaxY(self.eventImageView.frame) + padding, width - 32, 25)];
    [buttonVenue setTitle:[[self event] eventVenue] forState:UIControlStateNormal];
    [[buttonVenue titleLabel] setFont:[UIFont pik_avenirNextBoldWithSize:18.0f]];
    [buttonVenue setBackgroundColor:[UIColor pku_purpleColorandAlpha:1.0f]];
    [buttonVenue sizeToFit];
    buttonVenue.layer.cornerRadius = 2;
    buttonVenue.layer.borderWidth = 2;
    buttonVenue.layer.borderColor = [UIColor pku_purpleColor].CGColor;
    [buttonVenue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self adjustButtonView:buttonVenue toSize:CGSizeMake(buttonVenue.frame.size.width + 15.0f, buttonVenue.frame.size.height - 5.0f)];
    [buttonVenue addTarget:self action:@selector(pushVenue:) forControlEvents:UIControlEventAllEvents];
    
    // Event Date
    self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.eventVenueLabel.frame) + paddingDouble, width - 32, 25)];
    self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
    self.eventDateLabel.textColor = [UIColor whiteColor];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:self.event.startDate]];
    [dateFormatString insertString:[NSString daySuffixForDate:self.event.startDate] atIndex:6];
    self.eventDateLabel.text = dateFormatString;
    
    // Event Date
    self.eventDateEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.eventDateLabel.frame)/2, CGRectGetMaxY(self.eventVenueLabel.frame) + padding, width / 2 - 32, 25)];
    self.eventDateEndLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
    self.eventDateEndLabel.textColor = [UIColor whiteColor];
    self.eventDateEndLabel.textAlignment = NSTextAlignmentRight;
    
    [dateFormatter setDateFormat:@"HH:mma"];
    NSMutableString *dateFormatStringBegin = [[NSMutableString alloc] initWithString:[[dateFormatter stringFromDate:self.event.startDate] lowercaseString]];
    NSMutableString *dateFormatStringEnd = [[NSMutableString alloc] initWithString:[[dateFormatter stringFromDate:self.event.endDate] lowercaseString]];
    NSMutableString *beginningEnd = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"%@ - %@", @"Beginning And End"), dateFormatStringBegin, dateFormatStringEnd];
    
    self.eventDateEndLabel.text = beginningEnd;
    
    // Event Description
    self.eventDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.eventDateLabel.frame) + padding, width - 32, 400)];
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
    //[self.scrollView addSubview:self.darkOverlay];
    [self.eventImageView addSubview:self.eventNameLabel];
    [self.scrollView addSubview:self.eventDateLabel];
    [self.scrollView addSubview:self.eventDateEndLabel];
    [self.scrollView addSubview:buttonVenue];
    [self.scrollView addSubview:self.eventDescriptionTextView];
    
    //[self.scrollView setContentSize:CGSizeMake(width, CGRectGetMaxY(self.eventDescriptionTextView.frame))];
    [self.scrollView setContentSize:CGSizeMake(0, self.scrollView.frame.size.height + 200 + self.getTicketsButton.frame.size.height)];
    //
    //
    //NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    //[self.getTicketsButton setImage:[factory createImageForIcon:NIKFontAwesomeIconTicket] forState:UIControlStateNormal];
    [self.getTicketsButton setTintColor:[UIColor whiteColor]];
    
    if([[self.event quantity] isEqualToNumber:@0])
    {
        //[self.getTicketsButton setImage:[factory createImageForIcon:NIKFontAwesomeIconTicket] forState:UIControlStateDisabled];
        [self.getTicketsButton setTintColor:[UIColor darkGrayColor]];
        [self.getTicketsButton setTitle:@"SOLD OUT" forState:UIControlStateDisabled];
        [self.getTicketsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        [self.getTicketsButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.getTicketsButton setEnabled:NO];
    }
    
    [self.view bringSubviewToFront:self.getTicketsButton];
}

- (void)pushEvent:(id)sender {
    
}

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
    UIBarButtonItem *buttonShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareEvent)];
    self.navigationItem.rightBarButtonItem = buttonShare;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor pku_purpleColor]];
    self.navigationItem.title = titleText;
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
