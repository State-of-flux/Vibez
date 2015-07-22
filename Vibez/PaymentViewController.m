//
//  PaymentViewController.m
//  Vibez
//
//  Created by Harry Liddell on 20/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "PaymentViewController.h"
#import "PTKView.h"

@interface PaymentViewController () <PTKViewDelegate>

@property(weak, nonatomic) PTKView *paymentView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PTKView *view = [[PTKView alloc] initWithFrame:CGRectMake(15,20,290,55)];
    self.paymentView = view;
    self.paymentView.delegate = self;
    [self.view addSubview:self.paymentView];
}

- (void)paymentView:(PTKView *)view withCard:(PTKCard *)card isValid:(BOOL)valid
{
    // Toggle navigation, for example
   // self.saveButton.enabled = valid;
}


@end
