//
//  SignUpViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "TextFieldValidator.h"

@interface SignUpViewController : GlobalViewController

@property (weak, nonatomic) IBOutlet TextFieldValidator *usernameTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *emailAddressTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *passwordTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *submitButton;

- (IBAction)submitButtonTapped:(id)sender;


@end
