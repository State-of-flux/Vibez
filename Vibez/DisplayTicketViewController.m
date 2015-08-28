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
}

-(void)layoutSubviews
{
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    self.qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.5f - imageSize * 0.9f), imageSize, imageSize)];
    self.qrImageView.image = [UIImage mdQRCodeForString:self.ticket.ticketID size:self.qrImageView.bounds.size.width fillColor:[UIColor whiteColor]];
    
    self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    self.eventNameLabel.textColor = [UIColor whiteColor];
    self.eventNameLabel.font = [UIFont pik_avenirNextBoldWithSize:24.0f];
    self.eventNameLabel.text = self.ticket.eventName;
    self.eventNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.eventReferenceNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.eventNameLabel.frame) + 16, self.view.frame.size.width, 30)];
    self.eventReferenceNumberLabel.textColor = [UIColor whiteColor];
    self.eventReferenceNumberLabel.font = [UIFont pik_avenirNextRegWithSize:18.0f];
    
    self.eventReferenceNumberLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableString *eventText = [[NSMutableString alloc] initWithString:@"Reference Number: "];
    [eventText appendString:self.ticket.ticketID];
    [self.eventReferenceNumberLabel setText:eventText];
    
    [self.view addSubview:self.eventNameLabel];
    [self.view addSubview:self.eventReferenceNumberLabel];
    [self.view addSubview:self.qrImageView];
}

- (void)sendToFriend
{
    //[self performSegueWithIdentifier:@"goToSendTicketSegue" sender:self];
}

-(void)setNavBar:(NSString*)titleText
{
    self.navigationItem.title = titleText;
    //NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    
    //UIBarButtonItem *buttonSendToFriend = [[UIBarButtonItem alloc] initWithImage:[factory createImageForIcon:NIKFontAwesomeIconSendO] style:UIBarButtonItemStylePlain target:self action:@selector(sendToFriend)];
    
    //self.navigationItem.rightBarButtonItem = buttonSendToFriend;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"goToSendTicketSegue"])
    {
        SendTicketToFriendViewController *vc = segue.destinationViewController;
        [vc setTicket:self.ticket];
    }
}

@end
