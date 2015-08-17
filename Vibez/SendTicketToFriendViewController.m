//
//  SendTicketToFriendViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SendTicketToFriendViewController.h"
#import "RKDropdownAlert.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>

@interface SendTicketToFriendViewController ()

@end

@implementation SendTicketToFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textFieldUsername setText:@""];
    [self setNavBar:@"Send to Friend"];
}

- (IBAction)buttonSendToFriendPressed:(id)sender {
    
    NSString *usernameEntered = self.textFieldUsername.text;
    
    if([usernameEntered length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username field empty" message:@"Enter your friend's username to send the ticket." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self sendToFriend];
    }
}

-(void)setNavBar:(NSString*)titleText
{
    self.navigationItem.title = titleText;
    //UIBarButtonItem *bookmarkButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItem target:self action:@selector(showFriendsList)];
    
    //self.navigationItem.rightBarButtonItem = bookmarkButtonItem;
}

- (void)sendToFriend
{
    [self.view setUserInteractionEnabled:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    PFObject *ticket = [PFObject objectWithoutDataWithClassName:@"Ticket" objectId:self.ticket.ticketID];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.textFieldUsername.text];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             if([objects count] > 1)
             {
                 NSLog(@"Error, more than one user found %s", __PRETTY_FUNCTION__);
                 [self.view setUserInteractionEnabled:YES];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A problem occured with this username, please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
                 [hud hide:YES];
             }
             else if ([objects count] == 0)
             {
                 [self.view setUserInteractionEnabled:YES];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username not found" message:@"No usernames matching the input were found, check and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
                 [hud hide:YES];
             }
             else
             {
                 [ticket setObject:[objects firstObject] forKey:@"user"];
                 
                 [ticket saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     if(succeeded)
                     {
                         [RKDropdownAlert title:@"Ticket Sent!" message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
                         [hud hide:YES];
                         [self.view setUserInteractionEnabled:YES];
                         [self performSegueWithIdentifier:@"unwindToTicketsView" sender:self];
                     }
                     else if (error)
                     {
                         NSLog(@"Save Failed: %@. %s", error, __PRETTY_FUNCTION__);
                         [self.view setUserInteractionEnabled:YES];
                         [hud hide:YES];
                     }
                 }];
             }
         }
         else
         {
             NSLog(@"Find Failed: %@. %s", error, __PRETTY_FUNCTION__);
             [self.view setUserInteractionEnabled:YES];
             [hud hide:YES];
         }
     }];
}

@end
