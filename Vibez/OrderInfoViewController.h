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
#import <AFNetworking/AFNetworking.h>

@interface OrderInfoViewController : GlobalViewController <BTDropInViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Braintree *braintree;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
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

@property (strong, nonatomic) NSDecimalNumber *price;
@property (strong, nonatomic) NSDecimalNumber *bookingFee;
@property (strong, nonatomic) NSDecimalNumber *pricePerTicket;
@property (strong, nonatomic) NSDecimalNumber *overallPrice;
@property (nonatomic) NSInteger quantity;

@property (weak, nonatomic) IBOutlet UILabel *transactionIDLabel;
@property (strong, nonatomic) NSString *clientToken;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) PFObject *order;

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *eventInfoData;
@property (strong, nonatomic) NSArray *paymentData;
@property (strong, nonatomic) NSArray *totalData;
@property (strong, nonatomic) NSMutableArray *arrayOfQuantities;

@property (weak, nonatomic) IBOutlet UIButton *buttonCheckout;
- (IBAction)buttonCheckoutPressed:(id)sender;
+ (instancetype)createWithOrder:(PFObject *)order;

@end
