//
//  RegisterTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Vibes.h"

@interface RegisterTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPassword;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIView *contentViewEmail;
@property (weak, nonatomic) IBOutlet UIView *contentViewUsername;
@property (weak, nonatomic) IBOutlet UIView *contentViewPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegisterWithFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonTermsConditionsPrivacy;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowPassword;

@property (nonatomic) BOOL isShowingPassword;

- (IBAction)buttonRegisterPressed:(id)sender;
- (IBAction)buttonRegisterWithFacebookPressed:(id)sender;
- (IBAction)buttonTermsConditionsPrivacyPressed:(id)sender;
- (IBAction)buttonShowPasswordPressed:(id)sender;

@end
