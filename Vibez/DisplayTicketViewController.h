//
//  DisplayTicketViewController.h
//  Vibez
//
//  Created by Harry Liddell on 07/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket+Additions.h"

@interface DisplayTicketViewController : UIViewController

@property (strong, nonatomic) UILabel* eventNameLabel;
@property (strong, nonatomic) UILabel* eventReferenceNumberLabel;
@property (strong, nonatomic) UIImageView* qrImageView;

@property (strong, nonatomic) Ticket *ticket;

@end
