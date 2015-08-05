//
//  BuyTicketViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import <PaymentKit/PTKView.h>

@interface BuyTicketViewController : GlobalViewController <PTKViewDelegate>

@property IBOutlet PTKView* paymentView;

@end
