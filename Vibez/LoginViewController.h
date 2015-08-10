//
//  LoginViewController.h
//  Vibez
//
//  Created by Harry Liddell on 16/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import <Bolts/Bolts.h>
#import <Parse/Parse.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Foundation/Foundation.h>

@interface LoginViewController : GlobalViewController <FBSDKLoginTooltipViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FacebookLoginButton;
- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)signUpButtonTapped:(id)sender;
- (IBAction)FacebookLoginButtonTapped:(id)sender;

typedef void(^completion)(BOOL);

@end
