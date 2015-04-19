//
//  LoginViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender {
     [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
}

- (IBAction)signUpButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"loginToSignUpSegue" sender:self];
}

@end
