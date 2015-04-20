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

- (IBAction)loginButtonTapped:(id)sender {
    //[accountController Login];
    [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
}

- (IBAction)signUpButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"loginToSignUpSegue" sender:self];
}

- (IBAction)FacebookLoginButtonTapped:(id)sender {
    //[accountController LoginWithFacebook];
}

-(void)Login
{
    NSString *emailIdentifier = @"@";
    NSString *usernameOrEmailText = self.emailAddressTextField.text;
    
    if ([usernameOrEmailText rangeOfString:emailIdentifier].location != NSNotFound) {
        //"username" contains the email identifier @, therefore this is an email. Pull down the username.
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:usernameOrEmailText];
        NSArray *foundUsers = [query findObjects];
        
        if([foundUsers count]  == 1) {
            for (PFUser *foundUser in foundUsers) {
                usernameOrEmailText = [foundUser username];
            }
        }
    }
    else
    {
        //[accountController LoginWithUsername: andPassword:];
    }
}



@end
