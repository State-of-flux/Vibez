//
//  LoginTableViewController.m
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "LoginTableViewController.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import "AccountController.h"
#import <Reachability/Reachability.h>

@interface LoginTableViewController () {
    Reachability *reachability;
}

@end

@implementation LoginTableViewController

#pragma mark - App Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:NSLocalizedString(@"LOGIN", nil)];
    [self setupTableView];
    
    reachability = [Reachability reachabilityForInternetConnection];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self textFieldEmailUsername] setText:@"harry"];
    [[self textFieldPassword] setText:@"pass123"];
}

- (void)setupTableView {
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setAllowsSelection:NO];
    [[self tableView] setBackgroundColor:[UIColor pku_lightBlack]];
    [[self tableView] setTableFooterView:[UIView new]];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    [self addBorder:UIRectEdgeBottom color:[UIColor pku_greyColorWithAlpha:0.2f] thickness:0.5f view:[self contentViewEmailUsername]];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    
    [factory setSize:20.0f];
    [factory setColors:@[[UIColor whiteColor], [UIColor whiteColor]]];
    [[self buttonLoginWithFacebook] setImage:[factory createImageForIcon:NIKFontAwesomeIconFacebookSquare] forState:UIControlStateNormal];
    [[self buttonLoginWithFacebook] setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    factory = [NIKFontAwesomeIconFactory tabBarItemIconFactory];
    [factory setSize:12.0f];
    [factory setColors:@[[UIColor pku_greyColor], [UIColor pku_greyColor]]];
    [[self imageViewEmailUsername] setImage:[factory createImageForIcon:NIKFontAwesomeIconUser]];
    [[self imageViewPassword] setImage:[factory createImageForIcon:NIKFontAwesomeIconLock]];
    [[self textFieldEmailUsername] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldPassword] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - TableView Delegate Methods

- (IBAction)buttonLoginPressed:(id)sender {
    if (![reachability isReachable]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showStandardHUD:[self hud] target:self title:NSLocalizedString(@"Logging in....", nil) message:nil];
    
    [AccountController loginWithUsernameOrEmail:[[self textFieldEmailUsername] text] andPassword:[[self textFieldPassword] text] sender:self];
}

- (IBAction)buttonLoginWithFacebookPressed:(id)sender {
    if (![reachability isReachable]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showStandardHUD:[self hud] target:self title:NSLocalizedString(@"Logging in...", nil) message:NSLocalizedString(@"with Facebook", nil)];
    
    [AccountController loginWithFacebook:self];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[self tableView] frame]), 40)];
//        
//        UILabel *labelOr = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([view frame]), CGRectGetHeight([view frame]))];
//        [labelOr setText:NSLocalizedString(@"or", nil)];
//        [labelOr setTextAlignment:NSTextAlignmentCenter];
//        [labelOr setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightLight]];
//        [labelOr setTextColor:[UIColor whiteColor]];
//        [view addSubview:labelOr];
//        
//        return view;
//    }
//    else if (section == 1) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[self tableView] frame]), 40)];
//        
//        UIButton *buttonForgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
//        [buttonForgotPassword setFrame:CGRectMake(0, 0, CGRectGetWidth([view frame]), CGRectGetHeight([view frame]))];
//        [buttonForgotPassword setTitle:NSLocalizedString(@"Forgot your password?", nil) forState:UIControlStateNormal];
//        [[buttonForgotPassword titleLabel] setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightLight]];
//        [[buttonForgotPassword titleLabel] setTextColor:[UIColor whiteColor]];
//        [buttonForgotPassword addTarget:self action:@selector(buttonForgotPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [view addSubview:buttonForgotPassword];
//        
//        return view;
//    }
//    
//    return [UIView new];
//}

- (void)buttonForgotPasswordPressed:(id)sender {
    NSLog(@"Forgot Password pressed.");
    //[self resignFirstResponder];
    [AccountController forgotPasswordWithEmail:[[self textFieldEmailUsername] text] sender:self];
}

#pragma mark - UITextField delegate methods

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    switch ([textField tag]) {
//        case 0:
//            [[self textFieldEmailUsername] setBackgroundColor:[UIColor pku_lightBlackAndAlpha:0.8f]];
//            break;
//        case 1:
//            [[self textFieldEmailUsername] setBackgroundColor:[UIColor pku_lightBlackAndAlpha:0.8f]];
//            break;
//            
//        default:
//            break;
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch ([textField tag]) {
        case 0:
            [[self textFieldPassword] becomeFirstResponder];
            break;
        case 1:
            [self buttonLoginPressed:self];
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

@end
