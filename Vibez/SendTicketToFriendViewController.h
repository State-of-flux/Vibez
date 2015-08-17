//
//  SendTicketToFriendViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket+Additions.h"

@interface SendTicketToFriendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendToFriend;

@property (strong, nonatomic) Ticket *ticket;

- (IBAction)buttonSendToFriendPressed:(id)sender;


@end
