//
//  RegisterTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPassword;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;

- (IBAction)buttonRegisterPressed:(id)sender;

@end
