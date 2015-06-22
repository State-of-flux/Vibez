//
//  LoginViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountController.h"
#import "AppDelegate.h"
#import "UIColor+Piktu.h"
#import "Event.h"

@interface LoginViewController ()
{
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self tapOffKeyboardGestureSetup];
    [self placeholderTextColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.FacebookLoginButton.readPermissions = [AccountController FacebookPermissions];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Button Event Handling

- (IBAction)loginButtonTapped:(id)sender
{
    [self Login];
    //[Event getEventsInBackground];
    
}

- (IBAction)signUpButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"loginToSignUpSegue" sender:self];
}

#pragma mark - Parse Login

-(void)Login
{
    NSString *emailIdentifier = @"@";
    NSString *usernameOrEmailString = self.emailAddressTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    if ([usernameOrEmailString rangeOfString:emailIdentifier].location != NSNotFound) {
        //"username" contains the email identifier @, therefore this is an email. Pull down the username.
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:usernameOrEmailString];
        NSArray *foundUsers = [query findObjects];
        
        if([foundUsers count]  == 1) {
            for (PFUser *foundUser in foundUsers) {
                usernameOrEmailString = [foundUser username];
                [self LoginWithUsernameParse:usernameOrEmailString andPassword:passwordString];
            }
        }
    }
    else
    {
        [self LoginWithUsernameParse:usernameOrEmailString andPassword:passwordString];
    }
}

-(void)LoginWithUsernameParse:(NSString *)username andPassword:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
     {
         if(user)
         {
             //[self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
             AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
             appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:error.description delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
             [alert show];
         }
     }];
}

#pragma mark - Facebook Login

- (IBAction)FacebookLoginButtonTapped:(id)sender
{
    //[accountController LoginWithFacebook];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UI Stuff

-(void)placeholderTextColor
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor pku_placeHolderTextColor]};
    self.emailAddressTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.emailAddressTextField.placeholder attributes:attributes];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:attributes];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Keyboard Dismissal

-(void)tapOffKeyboardGestureSetup
{
    UIGestureRecognizer *tapOffKeyboard = [[UITapGestureRecognizer alloc]
                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapOffKeyboard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOffKeyboard];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

@end
