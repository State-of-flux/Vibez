//
//  OrderInfoViewController.m
//  Vibez
//
//  Created by Harry Liddell on 19/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "LabelNormalText.h"
#import "LabelTitle.h"

@interface OrderInfoViewController ()

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar:@"Order"];
    [self setupView];
}

- (void)setupView
{
    CGFloat padding = 8;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.buttonCheckout.frame.size.height)];
    
    [self.view addSubview:self.scrollView];
    
    self.labelEventName = [[LabelTitle alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.labelEventName setText:@"Event Name"];
    
    self.labelPriceTotal = [[LabelNormalText alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelEventName.frame) + padding, self.view.frame.size.width, 50)];
    [self.labelPriceTotal setText:@"Price Total"];
    
    self.labelQuantity = [[LabelNormalText alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelPriceTotal.frame) + padding, self.view.frame.size.width, 50)];
    [self.labelQuantity setText:@"Quantity"];
    
    self.labelDate = [[LabelNormalText alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelQuantity.frame) + padding, self.view.frame.size.width, 50)];
    [self.labelDate setText:@"Event Date"];
    
    [self.scrollView addSubview:self.labelEventName];
    [self.scrollView addSubview:self.labelPriceTotal];
    [self.scrollView addSubview:self.labelQuantity];
    [self.scrollView addSubview:self.labelDate];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.labelDate.frame))];
}

-(void)setNavBar:(NSString*)titleText
{
    [self.navigationItem setTitle:titleText];
}

- (IBAction)buttonCheckoutPressed:(id)sender {
    [self performSegueWithIdentifier:@"orderInfoToBuySegue" sender:self];
}
@end
