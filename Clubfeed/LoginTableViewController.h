//
//  LoginTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Vibes.h"

@interface LoginTableViewController : UITableViewController

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmailUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPassword;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoginWithFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonForgotPassword;

@property (weak, nonatomic) IBOutlet UIView *contentViewEmailUsername;
@property (weak, nonatomic) IBOutlet UIView *contentViewPassword;

- (IBAction)buttonLoginPressed:(id)sender;
- (IBAction)buttonLoginWithFacebookPressed:(id)sender;
- (IBAction)buttonForgotPasswordPressed:(id)sender;

@end
