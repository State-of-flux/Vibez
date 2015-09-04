//
//  SignUpViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SignUpViewController.h"
#import "AccountController.h"
#import "Validator.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Reachability/Reachability.h>

@interface SignUpViewController ()
{
    AccountController* accountController;
    Validator* validator;
    NSMutableString* passwordErrorString;
    Reachability *reachability;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    reachability = [Reachability reachabilityForInternetConnection];
    accountController = [[AccountController alloc] init];
    validator = [[Validator alloc] init];
    [self tapOffKeyboardGestureSetup];
}

- (IBAction)submitButtonTapped:(id)sender
{
    if([reachability isReachable])
    {
        if([self SignUpValidation])
        {
            [self SignUpWithUsername:self.usernameTextField.text emailAddress:self.emailAddressTextField.text password:self.passwordTextField.text];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Sign Up Validation

-(BOOL)SignUpValidation
{
    if([validator isValidUsername:self.usernameTextField.text])
    {
        if([validator isValidEmail:self.emailAddressTextField.text])
        {
            if([validator isValidPassword:self.passwordTextField.text confirmPassword:self.confirmPasswordTextField.text])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)SignUpWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = emailAddress;
    [user setObject:[NSArray array] forKey:@"friends"];
    [user setObject:@NO forKey:@"emailVerified"];
    [user setObject:@"Sheffield" forKey:@"location"];
    [user setObject:@NO forKey:@"isLinkedToFacebook"];
    [user setObject:@NO forKey:@"isAdmin"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Account created, welcome to Vibes." delegate:self cancelButtonTitle:@"Feel the Vibes" otherButtonTitles:nil, nil];
            [alert show];
            
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
            appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
        else
        {
            if(error.code == 203)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")message:NSLocalizedString(@"That email address is already taken", @"That email address is already taken") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")message:NSLocalizedString(@"A problem occured, please try again later.", @"A problem occured, please try again later.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

- (IBAction)signInButtonTapped:(id)sender {
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)tapOffKeyboardGestureSetup
{
    UIGestureRecognizer *tapOffKeyboard = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handleSingleTap:)];
    tapOffKeyboard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOffKeyboard];
}

@end
