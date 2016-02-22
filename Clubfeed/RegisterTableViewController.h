//
//  RegisterTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Vibes.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>

@interface RegisterTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewFirstName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLastName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDOB;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPassword;

@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelDOB;
@property (strong, nonatomic) ActionSheetDatePicker *pickerDOB;

@property (weak, nonatomic) IBOutlet UIView *contentViewFirstName;
@property (weak, nonatomic) IBOutlet UIView *contentViewLastName;
@property (weak, nonatomic) IBOutlet UIView *contentViewEmail;
@property (weak, nonatomic) IBOutlet UIView *contentViewDOB;
@property (weak, nonatomic) IBOutlet UIView *contentViewPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegisterWithFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonTermsConditionsPrivacy;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonDOB;

@property (nonatomic) BOOL isShowingPassword;

- (IBAction)buttonRegisterPressed:(id)sender;
- (IBAction)buttonRegisterWithFacebookPressed:(id)sender;
- (IBAction)buttonTermsConditionsPrivacyPressed:(id)sender;
- (IBAction)buttonShowPasswordPressed:(id)sender;
- (IBAction)buttonDOBPressed:(id)sender;

@end
