//
//  LoginTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 10/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewEmailUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPassword;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

- (IBAction)buttonLoginPressed:(id)sender;

@end
