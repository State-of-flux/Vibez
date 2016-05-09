//
//  RegisterTableViewController.m
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "RegisterTableViewController.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import "AccountController.h"
#import "Validator.h"
#import <Reachability/Reachability.h>
#import <DateTools/DateTools.h>

@interface RegisterTableViewController (){
    Reachability *reachability;
}
@end

@implementation RegisterTableViewController

#pragma mark - App Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:NSLocalizedString(@"REGISTER", nil)];
    [self setupTableView];
    
    [self setIsShowingPassword:NO];
    
    reachability = [Reachability reachabilityForInternetConnection];
}

- (void)setupTableView {
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setAllowsSelection:NO];
    [[self tableView] setBackgroundColor:[UIColor pku_lightBlack]];
    [[self tableView] setTableFooterView:[UIView new]];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewFirstName]];
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewLastName]];
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewEmail]];
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewDOB]];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    
    [factory setSize:20.0f];
    [factory setColors:@[[UIColor whiteColor], [UIColor whiteColor]]];
    [[self buttonRegisterWithFacebook] setImage:[factory createImageForIcon:NIKFontAwesomeIconFacebookSquare] forState:UIControlStateNormal];
    [[self buttonRegisterWithFacebook] setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [factory setSize:12.0f];
    [factory setColors:@[[UIColor pku_greyColor], [UIColor pku_greyColor]]];
    
    [[self imageViewFirstName] setImage:[factory createImageForIcon:NIKFontAwesomeIconUser]];
    [[self imageViewLastName] setImage:[factory createImageForIcon:NIKFontAwesomeIconUserPlus]];
    [[self imageViewEmail] setImage:[factory createImageForIcon:NIKFontAwesomeIconEnvelope]];
    [[self imageViewDOB] setImage:[factory createImageForIcon:NIKFontAwesomeIconCalendar]];
    [[self imageViewPassword] setImage:[factory createImageForIcon:NIKFontAwesomeIconLock]];
    
    [[self textFieldFirstName] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldLastName] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldEmail] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self labelDOB] setTextColor:[UIColor pku_greyColor]];
    [[self textFieldPassword] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [[[self buttonTermsConditionsPrivacy] titleLabel] setNumberOfLines:2];
    [[[self buttonTermsConditionsPrivacy] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    
    [[self buttonShowPassword] setImage:[factory createImageForIcon:NIKFontAwesomeIconEye] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - TableView Delegate Methods

- (IBAction)buttonRegisterPressed:(id)sender {
    
    if(![reachability isReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alert setTintColor:[UIColor pku_purpleColor]];
        [alert show];
        return;
    }
    
    [MBProgressHUD showStandardHUD:[self hud] target:[self navigationController] title:NSLocalizedString(@"Registering", nil) message:nil];
    
    if([self SignUpValidation])
    {
        [AccountController signupWithEmail:[[self textFieldEmail] text] password:[[self textFieldPassword] text] firstName:[[self textFieldFirstName] text] lastName:[[self textFieldLastName] text] dob:[NSDate date] sender:self];
    }
}

-(BOOL)SignUpValidation {
    //if([Validator isValidUsername:[[self textFieldUsername] text]])
    //{
        if([Validator isValidEmail:[[self textFieldEmail] text]])
        {
            if([Validator isValidPassword:[[self textFieldPassword] text] confirmPassword:[[self textFieldPassword] text]])
            {
                return YES;
            }
        }
    //}
    
    [MBProgressHUD hideStandardHUD:[self hud] target:[self navigationController]];
    
    return NO;
}

- (void)buttonTermsAndConditionsPressed:(id)sender {
    
}

#pragma mark - UITextField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch ([textField tag]) {
        case 0:
            [[self textFieldLastName] becomeFirstResponder];
            break;
        case 1:
            [[self textFieldEmail] becomeFirstResponder];
            break;
        case 2:
            // DOB becomes first responder
            [self openDOBPicker];
            break;
        case 3:

            break;
        case 4:
            [self buttonRegisterPressed:self];
            break;
        default:
            break;
    }
    
    return NO;
}

- (void)openDOBPicker {
    
    NSDate *minDate = [NSDate date];
    [minDate dateBySubtractingYears:18];
    
    NSDate *maxDate = [NSDate date];
    [maxDate dateBySubtractingYears:120];
    
    if(![self selectedDOB]) {
        [self setSelectedDOB:minDate];
    }
    
    [self setPickerDOB:[[ActionSheetDatePicker alloc] initWithTitle:NSLocalizedString(@"Date of Birth", nil)
                                                                  datePickerMode:UIDatePickerModeDate
                                                                    selectedDate:[self selectedDOB]
                                                                     minimumDate:minDate
                                                                     maximumDate:maxDate
                                                                          target:self
                                                                          action:@selector(dobAction)
                                                                          origin:[self buttonDOB]]];
    
    [[self pickerDOB] showActionSheetPicker];
}

- (void)dobAction {
    
}

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness view:(UIView *)view
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth([view frame]), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight([view frame]) - thickness, CGRectGetWidth([view frame]), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight([view frame]));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth([view frame]) - thickness, 0, thickness, CGRectGetHeight([view frame]));
            break;
        default:
            break;
    }
    
    [border setBackgroundColor:[color CGColor]];
    [[view layer] addSublayer:border];
    
    return border;
}

- (IBAction)buttonRegisterWithFacebookPressed:(id)sender {
    //[[self buttonRegisterWithFacebook] setEnabled:NO];
    //[[self buttonRegister] setEnabled:NO];
    
    if (![reachability isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alert setTintColor:[UIColor pku_purpleColor]];
        [alert show];
        return;
    }
    
    [MBProgressHUD showStandardHUD:[self hud] target:[self navigationController] title:NSLocalizedString(@"Registering...", nil) message:NSLocalizedString(@"with Facebook", nil)];
    
    [AccountController loginWithFacebook:self];
}

- (IBAction)buttonTermsConditionsPrivacyPressed:(id)sender {
    NSLog(@"Terms Conditions and Privacy Policy button pressed.");
}

- (IBAction)buttonShowPasswordPressed:(id)sender {
    [[self textFieldPassword] setFont:[UIFont pik_avenirNextRegWithSize:14.0f]];
    
    if ([self isShowingPassword]) {
        [self setIsShowingPassword:NO];
        [[self textFieldPassword] setSecureTextEntry:YES];
    } else {
        [self setIsShowingPassword:YES];
        [[self textFieldPassword] setSecureTextEntry:NO];
    }
    
    //    [[self textFieldPassword] setFont:[UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular]];
    [[self textFieldPassword] setFont:[UIFont pik_avenirNextRegWithSize:14.0f]];
}

- (IBAction)buttonDOBPressed:(id)sender {
    [self openDOBPicker];
}

#define MAXLENGTH 40

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField tag] == 0 || [textField tag] == 1) {
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= MAXLENGTH || returnKey;
    }
    
    return YES;
}

@end
