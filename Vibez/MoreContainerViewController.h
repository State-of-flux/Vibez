//
//  MoreContainerViewController.h
//  Vibez
//
//  Created by Harry Liddell on 14/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Bohr/Bohr.h>

@interface MoreContainerViewController : BOTableViewController

@property (weak, nonatomic) IBOutlet BOTableViewCell *usernameCell;
@property (weak, nonatomic) IBOutlet BOTableViewCell *emailAddressCell;
@property (weak, nonatomic) IBOutlet BOTableViewCell *passwordCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *friendsCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *priceCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *logoutCell;
@property (weak, nonatomic) IBOutlet BOButtonTableViewCell *linkToFacebookCell;

@end
