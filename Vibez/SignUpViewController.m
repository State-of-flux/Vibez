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

@interface SignUpViewController ()
{
    AccountController* accountController;
    Validator* validator;
    NSMutableString* passwordErrorString;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    accountController = [[AccountController alloc] init];
    validator = [[Validator alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonTapped:(id)sender
{
    if([self SignUpValidation])
    {
        [self SignUpWithUsername:self.usernameTextField.text emailAddress:self.emailAddressTextField.text password:self.passwordTextField.text];
        
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
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"signUpToHomeSegue" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
