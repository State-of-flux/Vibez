//
//  AccountController.m
//  Vibez
//
//  Created by Harry Liddell on 20/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "AccountController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "PIKDataLoader.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Vibes.h"

@interface AccountController () {
    
}
@end

@implementation AccountController

+ (NSArray *)FacebookPermissions {
    return @[@"public_profile", @"email", @"user_friends"];
}

+ (void)loginWithFacebook:(id)sender {
    [[sender view] setUserInteractionEnabled:NO];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:[self FacebookPermissions] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        // Was login successful?
        
        if (!user) {
                [MBProgressHUD hideStandardHUD:[sender hud] target:[sender navigationController]];
            
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", @"Login Failed") message:[error localizedDescription] delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
                [alert show];

                NSLog(@"An error occurred: %@", [error localizedDescription]);
            }
        } else {
            
            if ([user isNew]) {
                [self createNewUserForFacebook:user];
                NSLog(@"User registered and logged in through Facebook!");

            } else {
                NSLog(@"User logged in through Facebook!");
            }
            
            [PIKDataLoader loadAllCustomerData:^(BOOL finished) {
                if(finished)
                {
                    [MBProgressHUD hideStandardHUD:[sender hud] target:[sender navigationController]];
                    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
                    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                }
            }];
        }
    }];
}

+ (void)createNewUserForFacebook:(PFUser *)user {
    
}

+ (void)signupWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password sender:(id)sender {
    PFUser *user = [PFUser user];
    [user setUsername:[username lowercaseString]];
    [user setEmail:[email lowercaseString]];
    [user setPassword:password];
    [user setObject:[NSArray array] forKey:@"friends"];
    [user setObject:@"Sheffield" forKey:@"location"];
    [user setObject:@NO forKey:@"isLinkedToFacebook"];
    [user setObject:@NO forKey:@"isAdmin"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        PFACL *userACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [userACL setPublicReadAccess:YES];
        [userACL setPublicWriteAccess:NO];

        [[PFUser currentUser] setACL:userACL];
        [[PFUser currentUser] saveInBackground];
        
        [MBProgressHUD hideStandardHUD:[sender hud] target:sender];
        
        if (succeeded && !error) {
            [PIKDataLoader loadAllCustomerData:^(BOOL finished) {
                if(finished)
                {
                    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                    [[appDelegateTemp window] setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController]];
                    [MBProgressHUD showSuccessHUD:[sender hud] target:sender title:NSLocalizedString(@"Account Created", nil) message:NSLocalizedString(@"Welcome to Clubfeed.", nil)];
                }
            }];
        }
        else if (error)
        {
            if([error code] == 203)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"That email address is already taken", @"That email address is already taken") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([error code] == 202)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"That username is already taken", @"That username is already taken") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"A problem occured, please try again later.", @"A problem occured, please try again later.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
        [MBProgressHUD hideStandardHUD:[sender hud] target:sender];
    }];
}

+ (void)loginWithUsernameOrEmail:(NSString *)username andPassword:(NSString *)password sender:(id)sender {
    NSString *emailIdentifier = @"@";
    
    if ([username rangeOfString:emailIdentifier].location != NSNotFound) {
        //"username" contains the email identifier @, therefore this is an email. Pull down the username.
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:username];
        NSArray *foundUsers = [query findObjects];
        
        if([foundUsers count] == 1) {
            PFUser *foundUser = [foundUsers firstObject];
            username = [foundUser username];
            [self loginWithUsernameParse:username andPassword:password sender:sender];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", @"Login Failed") message:NSLocalizedString(@"An error occurred, please try again later.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
            [alert show];
            [MBProgressHUD hideStandardHUD:[sender hud] target:sender];
        }
    }
    else
    {
        [self loginWithUsernameParse:username andPassword:password sender:sender];
    }
}

+ (void)loginWithUsernameParse:(NSString *)username andPassword:(NSString *)password sender:(id)sender
{
    [PFUser logInWithUsernameInBackground:[username lowercaseString] password:password block:^(PFUser *user, NSError *error)
     {
         if(user)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:[user username] forKey:@"username"];
             [defaults setObject:[user email] forKey:@"emailAddress"];
             
             if(![[user objectForKey:@"isAdmin"] boolValue])
             {
                 [PIKDataLoader loadAllCustomerData:^(BOOL finished) {
                     if(finished)
                     {
                         [MBProgressHUD hideStandardHUD:[sender hud] target:sender];
                         AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
                         appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                     }
                 }];
             }
             else
             {
                 [PIKDataLoader loadAllAdminData:^(BOOL finished) {
                     if(finished)
                     {
                         [MBProgressHUD hideStandardHUD:[sender hud] target:sender];
                         AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
                         appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"TicketReading" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                     }
                 }];
             }
         }
         else if (error)
         {
             [MBProgressHUD hideStandardHUD:[sender hud] target:sender];
             
             if(error.code == 101)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", @"Login Failed") message:NSLocalizedString(@"Username/Email or password incorrect", @"Username/Email or password incorrect") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                 [alert show];
             } else {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", @"Login Failed") message:NSLocalizedString(@"An error occurred, please try again later.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
                 [alert show];
             }
         }
     }];
}

+ (void)linkOrUnlinkParseAccountFromFacebook {
    PFUser* user = [PFUser currentUser];
    
    //[[PFFacebookUtils facebookLoginManager] setLoginBehavior:FBSDKLoginBehaviorSystemAccount];
    
    if ([PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [user setObject:@NO forKey:@"isLinkedToFacebook"];
                NSLog(@"User has unlinked from Facebook");
            } else {
                NSLog(@"Unlink failed: %@", error);
            }
        }];
    } else {
        [PFFacebookUtils linkUserInBackground:user withReadPermissions:[self FacebookPermissions] block:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"User has linked to Facebook");
                [user setObject:@YES forKey:@"isLinkedToFacebook"];
            } else {
                NSLog(@"Link failed: %@", error);
            }
        }];
    }
}

+ (void)forgotPasswordWithEmail:(NSString *)email sender:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Password Reset", @"Password Reset") message:NSLocalizedString(@"Please enter your username or email. If the username or email exists, a password reset email will be sent.", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textFieldPassword)
     {
         textFieldPassword.placeholder = NSLocalizedString(@"Email", @"Email");
         [textFieldPassword setKeyboardAppearance:UIKeyboardAppearanceDark];
         [textFieldPassword setKeyboardType:UIKeyboardTypeEmailAddress];
         [textFieldPassword setText:email ? email : @""];
     }];
    
    UIAlertAction *actionValidate = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send Reset", @"Send Reset")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               [sender resignFirstResponder];
                                                               UITextField *textField = alert.textFields.firstObject;
                                                               NSString *input = textField.text;
                                                               NSString *emailIdentifier = @"@";
                                                               
                                                               // If entered input is an email just go straight to password reset.
                                                               if ([input rangeOfString:emailIdentifier].location != NSNotFound) {
                                                                   [PFUser requestPasswordResetForEmail:input];
                                                               }
                                                               else
                                                               {
                                                                   // If it's not an email, it must be a username, so find that usernames email, and send it to that.
                                                                   PFQuery *query = [PFUser query];
                                                                   [query whereKey:@"username" equalTo:input];
                                                                   NSArray *foundUsers = [query findObjects];
                                                                   
                                                                   if([foundUsers count]  == 1) {
                                                                       for (PFUser *foundUser in foundUsers) {
                                                                           input = [foundUser email];
                                                                           
                                                                           [self sendResetEmail:input];
                                                                       }
                                                                   } else {
                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"A problem occured while sending the password reset, please try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
                                                                       [alert show];
                                                                   }
                                                               }
                                                           }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:actionValidate];
    [alert addAction:actionCancel];
    
    [sender presentViewController:alert animated:YES completion:nil];
}

+ (void)sendResetEmail:(NSString *)email
{
    [PFUser requestPasswordResetForEmail:email];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sent", nil) message:NSLocalizedString(@"Please allow up to 10 minutes for the email to arrive.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
    [alert show];
}

@end
