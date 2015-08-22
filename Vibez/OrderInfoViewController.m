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
#import "UIViewController+NavigationController.h"

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
//    CGFloat padding = 8;
//    CGFloat paddingDouble = 8;
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height;
//    
//    // LABELS
//    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( paddingDouble, paddingDouble, width, height - self.buttonCheckout.frame.size.height - 100)];
//    
//    [self.view addSubview:self.scrollView];
//    
//    self.labelEventName = [[LabelTitle alloc] initWithFrame:CGRectMake(paddingDouble, 0, width / 2, 50)];
//    [self.labelEventName setText:[[self.order objectForKey:@"event"] objectForKey:@"eventName"]];
//    
//    self.labelPriceTotal = [[LabelNormalText alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.labelEventName.frame) + padding, width/2, 50)];
//    [self.labelPriceTotal setText:@"Price Total"];
//    
//    self.labelQuantity = [[LabelNormalText alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.labelPriceTotal.frame) + padding, width/2, 50)];
//    [self.labelQuantity setText:@"Quantity"];
//    
//    self.labelDate = [[LabelNormalText alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.labelQuantity.frame) + padding, width/2, 50)];
//    [self.labelDate setText:@"Event Date"];
//    
//    // VALUES
//    
//    self.labelPriceTotalValue = [[LabelNormalText alloc] initWithFrame:CGRectMake(width/2, CGRectGetMaxY(self.labelEventName.frame) + padding, width/2, 50)];
//    
//    NSMutableString *priceTotalString = [NSMutableString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [[[self.order objectForKey:@"event"] objectForKey:@"price"] floatValue]];
//    
//    [priceTotalString appendString:[NSMutableString stringWithFormat:NSLocalizedString(@" + £%.2f Booking Fee", @"Booking Fee"), [[[self.order objectForKey:@"event"] objectForKey:@"bookingFee"] floatValue]]];
//    
//    [self.labelPriceTotalValue setText:priceTotalString];
//    
//    self.labelQuantityValue = [[LabelNormalText alloc] initWithFrame:CGRectMake(width/2, CGRectGetMaxY(self.labelPriceTotal.frame) + padding, self.view.frame.size.width, 50)];
//    [self.labelQuantityValue setText:[self.order objectForKey:@"quantity"]];
//    
//    self.labelDateValue = [[LabelNormalText alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelQuantity.frame) + padding, self.view.frame.size.width, 50)];
//    [self.labelDateValue setText:[[self.order objectForKey:@"event"] objectForKey:@"eventDate"]];
//    
//    [self.scrollView addSubview:self.labelEventName];
//    [self.scrollView addSubview:self.labelEventNameValue];
//    
//    [self.scrollView addSubview:self.labelPriceTotal];
//    [self.scrollView addSubview:self.labelPriceTotalValue];
//    
//    [self.scrollView addSubview:self.labelQuantity];
//    [self.scrollView addSubview:self.labelQuantityValue];
//    
//    [self.scrollView addSubview:self.labelDate];
//    [self.scrollView addSubview:self.labelDateValue];
//    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.labelDate.frame))];
}

-(void)setNavBar:(NSString*)titleText
{
    [self.navigationItem setTitle:titleText];
}

- (IBAction)buttonCheckoutPressed:(id)sender {
    BTClient *client = [[BTClient alloc] initWithClientToken:@"asd"];
    self.paymentVC = [[BTDropInViewController alloc] initWithClient:client];
    
    [self presentViewController:[self.paymentVC withNavigationControllerWithModalPresentationStyle:UIModalPresentationOverCurrentContext] animated:YES completion:nil];
    
    //[self performSegueWithIdentifier:@"orderInfoToBuySegue" sender:self];
}

- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod
{
    
}

- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController
{
    
}

@end
