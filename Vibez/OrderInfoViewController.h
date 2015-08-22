//
//  OrderInfoViewController.h
//  Vibez
//
//  Created by Harry Liddell on 19/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Braintree/Braintree.h>
#import "GlobalViewController.h"

@interface OrderInfoViewController : GlobalViewController <BTDropInViewControllerDelegate>

@property (strong, nonatomic) BTDropInViewController *paymentVC;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *labelEventName;
@property (strong, nonatomic) UILabel *labelPriceTotal;
@property (strong, nonatomic) UILabel *labelQuantity;
@property (strong, nonatomic) UILabel *labelDate;

@property (strong, nonatomic) UILabel *labelEventNameValue;
@property (strong, nonatomic) UILabel *labelPriceTotalValue;
@property (strong, nonatomic) UILabel *labelQuantityValue;
@property (strong, nonatomic) UILabel *labelDateValue;

@property (strong, nonatomic) PFObject *order;

@property (weak, nonatomic) IBOutlet UIButton *buttonCheckout;
- (IBAction)buttonCheckoutPressed:(id)sender;

@end
