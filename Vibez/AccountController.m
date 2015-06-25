//
//  AccountController.m
//  Vibez
//
//  Created by Harry Liddell on 20/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "AccountController.h"


@interface AccountController ()
{
    NSString* currentErrorMessage;
}
@end

@implementation AccountController

+(NSArray *)FacebookPermissions
{
    return @[@"public_profile", @"email", @"user_friends"];
}

-(NSString *)GetErrorMessage
{
    return currentErrorMessage;
}

-(void)LoginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
    {
        if(user)
        {
            NSLog(@"Login Successful");
            
        }
        else
        {
            NSLog(@"Login Failed: %@", error.description);
            currentErrorMessage = error.description;
        }
    }];
}

-(void)LoginWithFacebook
{
    [PFFacebookUtils logInInBackgroundWithReadPermissions:[AccountController FacebookPermissions] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

-(void)SignUpWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = emailAddress;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
           
        }
        else
        {
            currentErrorMessage = [error userInfo][@"error"];
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)LinkAccountToFacebook
{
    PFUser* user = [PFUser currentUser];
    
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
            }
            else if(!succeeded && error)
            {
                NSLog(@"Action failed. User is not linked to their Facebook account. Error: %@", error);
            }
        }];
    }
}

-(void)UnlinkFacebookAccount
{
    PFUser* user = [PFUser currentUser];
    
    [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The user is no longer associated with their Facebook account.");
        }
        else if(!succeeded && error)
        {
            NSLog(@"Action failed. User still associated with their Facebook account. Error: %@", error);
        }
    }];
}

-(void)Logout
{
    [PFUser logOut];
}




@end
