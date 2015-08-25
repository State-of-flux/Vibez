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
#import "PIKContextManager.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@interface SendTicketToFriendViewController ()

@end

@implementation SendTicketToFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textFieldUsername setText:@""];
    [self setNavBar:@"Send to Friend"];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    [self.buttonSendToFriend setImage:[factory createImageForIcon:NIKFontAwesomeIconSendO] forState:UIControlStateNormal];
    [self.buttonSendToFriend setTintColor:[UIColor whiteColor]];
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
        [self validateUser];
    }
}

-(void)setNavBar:(NSString*)titleText
{
    self.navigationItem.title = titleText;
    //UIBarButtonItem *bookmarkButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItem target:self action:@selector(showFriendsList)];
    
    //self.navigationItem.rightBarButtonItem = bookmarkButtonItem;
}

-(void)validateUser
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Final Check", @"Final Check") message:NSLocalizedString(@"Once the ticket is sent, you will not be able to get it back unless that user sends it back. If you are sure you wish to continue please enter your username.", @"Once the ticket is sent, you will not be able to get it back unless that user sends it back. If you are sure you wish to continue please enter your username.") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textFieldPassword)
     {
         textFieldPassword.placeholder = NSLocalizedString(@"Your username", @"Your username");
         [textFieldPassword setSecureTextEntry:YES];
     }];
    
    UIAlertAction *actionValidate = [UIAlertAction actionWithTitle:NSLocalizedString(@"Validate and Send", @"Validate and Send")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               UITextField *textField = alert.textFields.firstObject;
                                                               
                                                               //[textField.text isEqualToString:[[PFUser currentUser] password]];
                                                               
                                                               if([[[PFUser currentUser] username] isEqualToString:textField.text])
                                                               {
                                                                   [self sendToFriend];
                                                               }
                                                               else
                                                               {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error" , @"Error") message:NSLocalizedString(@"Incorrect please try again.", @"Incorrect, please try again.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay" , @"Okay")  otherButtonTitles:nil, nil];
                                                                   [alert show];
                                                               }
                                                           }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:actionValidate];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
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
                 PFUser *friend = [objects firstObject];
                 
                 if([[PFUser currentUser] isEqual:friend])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"That's you." message:@"You can't send tickets to yourself." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                     [alert show];
                     [self.view setUserInteractionEnabled:YES];
                     [hud hide:YES];
                 }
                 else
                 {
                     [ticket setObject:[objects firstObject] forKey:@"user"];
                     
                     [ticket saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if(succeeded)
                         {
                             [RKDropdownAlert title:[NSString stringWithFormat:@"Ticket sent to %@", friend.username] message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
                             
                             [self.view setUserInteractionEnabled:YES];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"Ticket Sent To Friend" object:nil];
                             [hud hide:YES];
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
