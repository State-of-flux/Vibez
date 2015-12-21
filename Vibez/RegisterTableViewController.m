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
    
    reachability = [Reachability reachabilityForInternetConnection];
}

- (void)setupTableView {
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setAllowsSelection:NO];
    [[self tableView] setBackgroundColor:[UIColor pku_lightBlack]];
    [[self tableView] setTableFooterView:[UIView new]];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewEmail]];
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewUsername]];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    
    [factory setSize:20.0f];
    [factory setColors:@[[UIColor whiteColor], [UIColor whiteColor]]];
    [[self buttonRegisterWithFacebook] setImage:[factory createImageForIcon:NIKFontAwesomeIconFacebookSquare] forState:UIControlStateNormal];
    [[self buttonRegisterWithFacebook] setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [factory setSize:12.0f];
    [factory setColors:@[[UIColor pku_greyColor], [UIColor pku_greyColor]]];
    [[self imageViewEmail] setImage:[factory createImageForIcon:NIKFontAwesomeIconEnvelope]];
    [[self imageViewUsername] setImage:[factory createImageForIcon:NIKFontAwesomeIconUser]];
    [[self imageViewPassword] setImage:[factory createImageForIcon:NIKFontAwesomeIconLock]];
    
    [[self textFieldEmail] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldUsername] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldPassword] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [[[self buttonTermsConditionsPrivacy] titleLabel] setNumberOfLines:2];
    [[[self buttonTermsConditionsPrivacy] titleLabel] setTextAlignment:NSTextAlignmentCenter];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showStandardHUD:[self hud] target:self title:NSLocalizedString(@"Registering", nil) message:nil];
    
    if([self SignUpValidation])
    {
        [AccountController signupWithUsername:[[self textFieldUsername] text] email:[[self textFieldEmail] text] password:[[self textFieldPassword] text] sender:self];
    }
}

-(BOOL)SignUpValidation
{
    if([Validator isValidUsername:[[self textFieldUsername] text]])
    {
        if([Validator isValidEmail:[[self textFieldEmail] text]])
        {
            if([Validator isValidPassword:[[self textFieldPassword] text] confirmPassword:[[self textFieldPassword] text]])
            {
                return YES;
            }
        }
    }
    
    [MBProgressHUD hideStandardHUD:[self hud] target:self];
    
    return NO;
}

- (void)buttonTermsAndConditionsPressed:(id)sender {
    
}

#pragma mark - UITextField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch ([textField tag]) {
        case 0:
            [[self textFieldUsername] becomeFirstResponder];
            break;
        case 1:
            [[self textFieldPassword] becomeFirstResponder];
            break;
        case 2:
            [self buttonRegisterPressed:self];
            break;
            
        default:
            break;
    }
    
    return NO;
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
    if (![reachability isReachable]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showStandardHUD:[self hud] target:self title:NSLocalizedString(@"Registering...", nil) message:NSLocalizedString(@"with Facebook", nil)];
    
    [AccountController loginWithFacebook:self];
}

- (IBAction)buttonTermsConditionsPrivacyPressed:(id)sender {
    NSLog(@"Terms Conditions and Privacy Policy button pressed.");
}
@end
