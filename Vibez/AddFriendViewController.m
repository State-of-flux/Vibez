//
//  AddFriendViewController.m
//  Vibez
//
//  Created by Harry Liddell on 23/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "AddFriendViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RKDropdownAlert.h"

@implementation AddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)addFriend
{
    [self.view setUserInteractionEnabled:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Adding Friend...";
    
    PFUser *user = [PFUser currentUser];
    
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
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username not found" message:@"No usernames matching the input were found, check and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alert show];
                 
                 [self.view setUserInteractionEnabled:YES];
                 [hud hide:YES];
             }
             else
             {
                 PFUser *friend = [objects firstObject];
                 
                 NSMutableArray *arrayOfFriends = [user objectForKey:@"friends"];
                 
                 if(!arrayOfFriends)
                 {
                     arrayOfFriends = [NSMutableArray array];
                 }
                 
                 if([[[PFUser currentUser] username] isEqualToString:[friend username]])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"That's you." message:@"You can't add yourself." delegate:self cancelButtonTitle:@"Fair enough" otherButtonTitles:nil, nil];
                     [alert show];
                     [self.view setUserInteractionEnabled:YES];
                     [hud hide:YES];
                 }
                 else if([arrayOfFriends containsObject:[friend username]])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate" message:@"This user is already in your friend's list." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                     [alert show];
                     [self.view setUserInteractionEnabled:YES];
                     [hud hide:YES];
                 }
                 else
                 {
                     [arrayOfFriends addObject:friend.username];
                     
                     [user setObject:arrayOfFriends forKey:@"friends"];
                     
                     [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if(succeeded)
                         {
                             [RKDropdownAlert title:[NSString stringWithFormat:@"%@ added to friend's list", friend.username] message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.5];
                             
                             [self.view setUserInteractionEnabled:YES];
                             [hud hide:YES];
                             [self performSegueWithIdentifier:@"unwindToFriendsList" sender:self];
                         }
                         else if (error)
                         {
                             NSLog(@"Save Failed: %@. %s", error, __PRETTY_FUNCTION__);
                             [self.view setUserInteractionEnabled:YES];
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username not found" message:@"No usernames matching the input were found, check and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                             [alert show];
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
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured whilst trying to find your friend, please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
             [alert show];
             [hud hide:YES];
         }
     }];
}

- (IBAction)buttonAddFriendPressed:(id)sender {
    NSString *usernameEntered = self.textFieldUsername.text;
    
    if([usernameEntered length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username field empty" message:@"Enter your friend's username to send the ticket." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self addFriend];
    }
}
@end
