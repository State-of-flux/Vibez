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

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

#pragma mark - App Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:NSLocalizedString(@"REGISTER", nil)];
    [self setupTableView];
}

- (void)setupTableView {
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setAllowsSelection:NO];
    [[self tableView] setBackgroundColor:[UIColor pku_lightBlack]];
    [[self tableView] setTableFooterView:[UIView new]];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory tabBarItemIconFactory];
    [factory setColors:@[[UIColor pku_greyColor], [UIColor pku_greyColor]]];
    [[self imageViewEmail] setImage:[factory createImageForIcon:NIKFontAwesomeIconEnvelope]];
    [[self imageViewUsername] setImage:[factory createImageForIcon:NIKFontAwesomeIconUser]];
    [[self imageViewPassword] setImage:[factory createImageForIcon:NIKFontAwesomeIconLock]];
    
    [[self textFieldEmail] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldUsername] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[self textFieldPassword] setValue:[UIColor pku_greyColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
    }
}

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)buttonRegisterPressed:(id)sender {
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth([[self tableView] frame]) - 15, 40)];
    
    UIButton *buttonForgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonForgotPassword setFrame:CGRectMake(0, 0, CGRectGetWidth([view frame]), CGRectGetHeight([view frame]))];
    [buttonForgotPassword setTitle:NSLocalizedString(@"By registering, you are agreeing to Clubfeed's Terms and Conditions.", nil) forState:UIControlStateNormal];
    [[buttonForgotPassword titleLabel] setFont:[UIFont systemFontOfSize:10.0f weight:UIFontWeightLight]];
    [[buttonForgotPassword titleLabel] setTextColor:[UIColor whiteColor]];
    [[buttonForgotPassword titleLabel] setNumberOfLines:2];
    [[buttonForgotPassword titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [buttonForgotPassword addTarget:self action:@selector(buttonTermsAndConditionsPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:buttonForgotPassword];
    
    return view;
}

- (void)buttonTermsAndConditionsPressed:(id)sender {
    NSLog(@"Pressed");
}

@end
