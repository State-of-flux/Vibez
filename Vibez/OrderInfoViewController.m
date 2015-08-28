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
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import <Reachability/Reachability.h>
#import <CardIO/CardIO.h>

@interface OrderInfoViewController ()
{
    Reachability *reachability;
}
@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar:@"Order"];
    [self setupView];
    [self setPaymentValues];
    
    reachability = [Reachability reachabilityForInternetConnection];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self getToken];
}

- (void)setPaymentValues
{
    PFObject *event = [self.order objectForKey:@"event"];
    self.price = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"price"] integerValue]];
    self.bookingFee = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"bookingFee"] integerValue]];
    self.overallPrice = [self addNumber:self.price andOtherNumber:self.bookingFee withQuantity:[[self.order objectForKey:@"quantity"] integerValue]];
}

- (void)setupView
{
    CGFloat statusBarFrame = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat padding = 8;
    CGFloat paddingDouble = 16;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat heightWithoutNavOrTabOrStatus = (height - (navBarHeight + tabBarHeight + statusBarFrame));
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heightWithoutNavOrTabOrStatus - self.buttonCheckout.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    self.labelEventName = [[LabelTitle alloc] initWithFrame:CGRectMake(paddingDouble, 0, width / 2, 50)];
    [self.labelEventName setText:[[self.order objectForKey:@"event"] objectForKey:@"eventName"]];
    
    self.labelPriceTotal = [[LabelNormalText alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.labelEventName.frame) + padding, width/2, 50)];
    [self.labelPriceTotal setText:@"Price Total"];
    
    self.labelQuantity = [[LabelNormalText alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.labelPriceTotal.frame) + padding, width/2, 50)];
    [self.labelQuantity setText:@"Quantity"];
    
    self.labelDate = [[LabelNormalText alloc] initWithFrame:CGRectMake(paddingDouble, CGRectGetMaxY(self.labelQuantity.frame) + padding, width/2, 50)];
    [self.labelDate setText:@"Event Date"];
    
    // VALUES
    
    self.labelPriceTotalValue = [[LabelNormalText alloc] initWithFrame:CGRectMake(width/2, CGRectGetMaxY(self.labelEventName.frame) + padding, width/2, 50)];
    
    
    NSMutableString *priceTotalString = [NSMutableString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [self calculateOverallPrice]];
    
    [priceTotalString appendString:[NSMutableString stringWithFormat:NSLocalizedString(@" + £%.2f BF x%ld", @"Booking Fee"), [[[self.order objectForKey:@"event"] objectForKey:@"bookingFee"] floatValue], [[self.order objectForKey:@"quantity"] integerValue]]];
    
    [self.labelPriceTotalValue setText:priceTotalString];
    
    self.labelQuantityValue = [[LabelNormalText alloc] initWithFrame:CGRectMake(width/2, CGRectGetMaxY(self.labelPriceTotal.frame) + padding, self.view.frame.size.width, 50)];
    [self.labelQuantityValue setText:[[self.order objectForKey:@"quantity"] stringValue]];
    
    self.labelDateValue = [[LabelNormalText alloc] initWithFrame:CGRectMake(width/2, CGRectGetMaxY(self.labelQuantity.frame) + padding, self.view.frame.size.width, 50)];
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE dd MMM YYYY" options:0
                                                              locale:[NSLocale currentLocale]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    NSLog(@"System time: %@", [dateFormatter stringFromDate:[NSDate date]]);
    NSString *dateString = [dateFormatter stringFromDate:[[self.order objectForKey:@"event"] objectForKey:@"eventDate"]];
    
    [self.labelDateValue setText:dateString];
    
    [self.scrollView addSubview:self.labelEventName];
    [self.scrollView addSubview:self.labelEventNameValue];
    
    [self.scrollView addSubview:self.labelPriceTotal];
    [self.scrollView addSubview:self.labelPriceTotalValue];
    
    [self.scrollView addSubview:self.labelQuantity];
    [self.scrollView addSubview:self.labelQuantityValue];
    
    [self.scrollView addSubview:self.labelDate];
    [self.scrollView addSubview:self.labelDateValue];
    
    [self.scrollView setContentSize:CGSizeMake(width, CGRectGetMaxY(self.labelDate.frame))];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    [self.buttonCheckout setImage:[factory createImageForIcon:NIKFontAwesomeIconLock] forState:UIControlStateNormal];
    [self.buttonCheckout setTintColor:[UIColor whiteColor]];
}

- (NSDecimalNumber *)calculateOverallPrice
{
    PFObject *event = [self.order objectForKey:@"event"];
    NSDecimalNumber *price = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"price"] integerValue]];
    NSDecimalNumber *bookingFee = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"bookingFee"] integerValue]];
    NSDecimalNumber *overallPrice = [self addNumber:price andOtherNumber:bookingFee withQuantity:[[self.order objectForKey:@"quantity"] integerValue]];
    
    return overallPrice;
}

-(void)setNavBar:(NSString*)titleText
{
    [self.navigationItem setTitle:titleText];
}

- (IBAction)buttonCheckoutPressed:(id)sender {
    
    /*
    if([reachability isReachable])
    {
        Braintree *braintree = [Braintree braintreeWithClientToken:self.clientToken];
        BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];
        
        dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(userDidCancelPayment)];
        
        PFObject *event = [self.order objectForKey:@"event"];
        
        //Customize the UI
        dropInViewController.summaryTitle = [event objectForKey:@"eventName"];
        dropInViewController.summaryDescription = [event objectForKey:@"eventDescription"];
        
        NSDecimalNumber *price = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"price"] integerValue]];
        NSDecimalNumber *bookingFee = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"bookingFee"] integerValue]];
        
        NSDecimalNumber *overallPrice = [self addNumber:price andOtherNumber:bookingFee withQuantity:[[self.order objectForKey:@"quantity"] integerValue]];
        dropInViewController.displayAmount = [NSString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [overallPrice floatValue]];
        
        [self presentViewController:[dropInViewController withNavigationController]
                           animated:YES
                         completion:nil];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
     */
    
    [self.order saveInBackground];
}

- (void)getToken {
    [self.manager GET:@"http://127.0.0.1:3000/token"
           parameters: nil
              success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                  self.clientToken = responseObject[@"clientToken"];
                  self.buttonCheckout.enabled = TRUE;
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    [self postNonceToServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidCancelPayment{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark POST NONCE TO SERVER method
- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    [self.manager POST:@"http://127.0.0.1:3000/payment"
            parameters:@{@"payment_method_nonce": paymentMethodNonce}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSString *transactionID = responseObject[@"transaction"][@"id"];
                   self.transactionIDLabel.text = [[NSString alloc] initWithFormat:@"Transaction ID: %@", transactionID];
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
               }];
}

-(NSDecimalNumber *)addNumber:(NSDecimalNumber *)num1 andOtherNumber:(NSDecimalNumber *)num2 withQuantity:(NSInteger)quantity
{
    NSDecimalNumber *added = [[NSDecimalNumber alloc] initWithInt:0];
    NSDecimalNumber *quantityDec = [[NSDecimalNumber alloc] initWithInteger:quantity];
    
    NSDecimalNumber *overall = [added decimalNumberByAdding:[num1 decimalNumberByAdding:num2]];
    
    return [overall decimalNumberByMultiplyingBy:quantityDec];
}

@end
