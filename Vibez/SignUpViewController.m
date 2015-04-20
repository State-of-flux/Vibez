//
//  SignUpViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SignUpViewController.h"
#import "AccountController.h"

#define REGEX_USERNAME @"^[a-z0-9_-]{3,15}$"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,40})"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface SignUpViewController ()
{
    AccountController* accountController;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    accountController = [[AccountController alloc] init];
    
    [self.usernameTextField addRegx:REGEX_USERNAME withMsg:@"Must be between 6-12 alphanumeric characters."];
    [self.emailAddressTextField addRegx:REGEX_EMAIL withMsg:@"Please enter a valid email address."];
    [self.passwordTextField addRegx:REGEX_PASSWORD withMsg:@"Must be between 6-40 characters and contain at least 1 uppercase character and 1 digit."];
    [self.confirmPasswordTextField addRegx:REGEX_PASSWORD withMsg:@"Must be between 6-40 characters and contain at least 1 uppercase character and 1 digit."];
    [self.confirmPasswordTextField addConfirmValidationTo:self.passwordTextField withMsg:@"Passwords do not match."];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SignUp
{
    if([self.usernameTextField validate] & [self.emailAddressTextField validate] & [self.passwordTextField validate] & [self.confirmPasswordTextField validate]){
        
        
        
        //[accountController SignUpWithUsername:self.usernameTextField.text emailAddress:self.emailAddressTextField.text password:self.passwordTextField.text];
    }
    else
    {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButtonTapped:(id)sender {
}
@end
