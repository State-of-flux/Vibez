//
//  LoginViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountController.h"

@interface LoginViewController ()
{
    AccountController* accountController;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    accountController = [[AccountController alloc] init];
    self.FacebookLoginButton.readPermissions = [accountController FacebookPermissions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonTapped:(id)sender
{
    //[self Login];
    
    
    // TEMP SEGUE
    [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
}

- (IBAction)signUpButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"loginToSignUpSegue" sender:self];
}

- (IBAction)FacebookLoginButtonTapped:(id)sender
{
    //[accountController LoginWithFacebook];
}

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
             [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:error.description delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
             [alert show];

         }
     }];
}

@end
