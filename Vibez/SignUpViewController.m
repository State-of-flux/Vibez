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

#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.usernameTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    else if ([sender isEqual:self.emailAddressTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    else if ([sender isEqual:self.passwordTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    else if ([sender isEqual:self.confirmPasswordTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillHide)
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)submitButtonTapped:(id)sender
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Signing up...";
    
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
    //[user setObject:@NO forKey:@"emailVerified"];
    [user setObject:@"Sheffield" forKey:@"location"];
    [user setObject:@NO forKey:@"isLinkedToFacebook"];
    [user setObject:@NO forKey:@"isAdmin"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            //User has successfully signed up now that I have a cached currentUser we proceed to add them to the 'Moderator' Role:
            //PFQuery *roleQuery = [PFRole query];
            //[roleQuery whereKey:@"name" equalTo:@"customer"];
            //[roleQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    //PFRole *role = (PFRole *)object;
                    //[role.users addObject:[PFUser currentUser]];
                    //[role saveInBackground];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Account created, welcome to Vibes." delegate:self cancelButtonTitle:@"Feel the Vibes" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                }
            //}];
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
        
        [self.hud hide:YES];
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
