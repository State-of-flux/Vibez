//
//  DisplayTicketViewController.m
//  Vibez
//
//  Created by Harry Liddell on 07/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "DisplayTicketViewController.h"
#import "UIImage+MDQRCode.h"
#import "RKDropdownAlert.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SendTicketToFriendViewController.h"
#import "NSString+PIK.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@interface DisplayTicketViewController ()

@end

@implementation DisplayTicketViewController

#pragma mark - General Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar:@"Your Ticket"];
    [self layoutSubviews];
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
}

-(void)layoutSubviews
{
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    self.qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.4f - imageSize), imageSize, imageSize)];
    self.qrImageView.image = [UIImage mdQRCodeForString:self.ticket.ticketID size:self.qrImageView.bounds.size.width fillColor:[UIColor whiteColor]];
    
    self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.qrImageView.frame) + 8, self.view.frame.size.width, 40)];
    self.eventNameLabel.textColor = [UIColor whiteColor];
    self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:24.0f];
    self.eventNameLabel.text = self.ticket.eventName;
    self.eventNameLabel.textAlignment = NSTextAlignmentCenter;
    self.eventNameLabel.numberOfLines = 0;
    
    self.venueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.eventNameLabel.frame) + 8, self.view.frame.size.width, 25)];
    self.venueNameLabel.textColor = [UIColor whiteColor];
    self.venueNameLabel.font = [UIFont pik_avenirNextRegWithSize:18.0f];
    NSMutableString *venueString = [[NSMutableString alloc] initWithString:@"at "];
    [venueString appendString:self.ticket.venue];
    self.venueNameLabel.text = venueString;
    self.venueNameLabel.textAlignment = NSTextAlignmentCenter;
    self.venueNameLabel.numberOfLines = 0;
    
    self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.venueNameLabel.frame) + 24, self.view.frame.size.width, 50)];
    self.eventDateLabel.textColor = [UIColor whiteColor];
    self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:18.0f];
    self.eventDateLabel.textAlignment = NSTextAlignmentCenter;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"HH:mm, EEE, dd MMM, YYYY"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:self.ticket
.eventDate]];
    [dateFormatString insertString:[NSString daySuffixForDate:[[self ticket] eventDate]] atIndex:14];
    [self.eventDateLabel setText:dateFormatString];
    
    [self.view addSubview:self.eventNameLabel];
    [self.view addSubview:self.venueNameLabel];
    [self.view addSubview:self.eventDateLabel];
    [self.view addSubview:self.qrImageView];
    
    [self movingDot];
}

- (void)movingDot {
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(self.eventDateLabel.frame.origin.x, CGRectGetMaxY(self.eventDateLabel.frame) - self.eventDateLabel.frame.size.height, 50, 50)];
    [dot setBackgroundColor:[UIColor pku_purpleColor]];
    [dot setAlpha:0.25];
    [[dot layer] setCornerRadius:[dot frame].size.height/2];
    
    
    [[self view] addSubview:dot];
    
    CGPoint finishPoint = CGPointMake(CGRectGetMaxX(self.eventDateLabel.frame) - 25, CGRectGetMaxY(self.eventDateLabel.frame) - self.eventDateLabel.frame.size.height + 25);
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // do whatever animation you want, e.g.,
                         
                         [dot setCenter:finishPoint];
                     }
                     completion:NULL];
    
    //[self animationLoop:@"id" finished:@10 context:nil onView:dot];
}

-(void)animationLoop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context onView:(UIView *)object{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    // remove:
      //[UIView setAnimationRepeatCount:1000];
      [UIView setAnimationRepeatAutoreverses:YES];
    
    CGFloat x = (CGFloat) (arc4random() % (int) self.view.bounds.size.width);
    CGFloat y = (CGFloat) (arc4random() % (int) self.view.bounds.size.height);
    
    CGPoint squarePostion = CGPointMake(x, y);
    object.center = squarePostion;
    // add:
    [UIView setAnimationDelegate:self]; // as suggested by @Carl Veazey in a comment
    [UIView setAnimationDidStopSelector:@selector(animationLoop:finished:context:onView:)];
    
    [UIView commitAnimations];
}

- (void)sendToFriend {
    //[self performSegueWithIdentifier:@"goToSendTicketSegue" sender:self];
}

-(void)setNavBar:(NSString*)titleText {
    self.navigationItem.title = titleText;
    //NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    
    //UIBarButtonItem *buttonSendToFriend = [[UIBarButtonItem alloc] initWithImage:[factory createImageForIcon:NIKFontAwesomeIconSendO] style:UIBarButtonItemStylePlain target:self action:@selector(sendToFriend)];
    
    //self.navigationItem.rightBarButtonItem = buttonSendToFriend;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"goToSendTicketSegue"]) {
        SendTicketToFriendViewController *vc = segue.destinationViewController;
        [vc setTicket:self.ticket];
    }
}

@end
