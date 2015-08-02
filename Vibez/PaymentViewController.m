//
//  PaymentViewController.m
//  Vibez
//
//  Created by Harry Liddell on 20/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PTKView *view = [[PTKView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.paymentView = view;
    self.paymentView.delegate = self;
    
    //view.cardNumberField = [[PTKTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/5)];
    
    [self.view addSubview:self.paymentView];
}

- (void)paymentView:(PTKView *)view withCard:(PTKCard *)card isValid:(BOOL)valid
{
    // Toggle navigation, for example
    //self.saveButton.enabled = valid;
}


@end
