//
//  AddFriendViewController.h
//  Vibez
//
//  Created by Harry Liddell on 23/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddFriendViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *buttonAddFriend;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;

- (IBAction)buttonAddFriendPressed:(id)sender;

@end
