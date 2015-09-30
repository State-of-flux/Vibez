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

+ (instancetype)createWithOrder:(PFObject *)order {
    UIStoryboard *storyboardMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    OrderInfoViewController *instance = (OrderInfoViewController *)[storyboardMain instantiateViewControllerWithIdentifier:NSStringFromClass([OrderInfoViewController class])];
    
    [instance setOrder:order];
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar:@"Order"];
    [self setupView];
    [self setPaymentValues];
    
    reachability = [Reachability reachabilityForInternetConnection];
    self.manager = [AFHTTPRequestOperationManager manager];
    
    //self.clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI0Y2JmMTM5YWRjMDk1NjQyZWNhMGE3ZWIxNTYzNzFhYmYyZDQ2ODhlZGYwZWM2ZTY0M2UzYjI5MWVlYzhhOGY3fGNyZWF0ZWRfYXQ9MjAxNS0wOC0yOVQxOTowMzoyMy4wODY2Mzk0MTQrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRBY2NvdW50SWQiOiJhY21ld2lkZ2V0c2x0ZHNhbmRib3giLCJjdXJyZW5jeUlzb0NvZGUiOiJVU0QifSwiY29pbmJhc2VFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRJZCI6IjM0OHBrOWNnZjNiZ3l3MmIiLCJ2ZW5tbyI6Im9mZiJ9";
    
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
    
    NSMutableString *priceTotalString = [NSMutableString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [[self calculateOverallPrice] floatValue]];
    
//    [priceTotalString appendString:[NSMutableString stringWithFormat:NSLocalizedString(@" + £%.2f BF x%ld", @"Booking Fee"), [[[self.order objectForKey:@"event"] objectForKey:@"bookingFee"] floatValue], [[self.order objectForKey:@"quantity"] integerValue]]];
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        
    }
    
    return cell;
}

-(void)setNavBar:(NSString*)titleText
{
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelOrder:)];
    self.navigationItem.leftBarButtonItem = buttonCancel;
    [self.navigationItem setTitle:titleText];
}

- (void)cancelOrder:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonCheckoutPressed:(id)sender {
    
    if([reachability isReachable])
    {
        Braintree *braintree = [Braintree braintreeWithClientToken:self.clientToken];
        BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];
        
        dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(userDidCancelPayment)];
        
        PFObject *event = [self.order objectForKey:@"event"];
        NSDecimalNumber *price = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"price"] integerValue]];
        NSDecimalNumber *bookingFee = [[NSDecimalNumber alloc] initWithInteger:[[event objectForKey:@"bookingFee"] integerValue]];
        
        NSDecimalNumber *overallPrice = [self addNumber:price andOtherNumber:bookingFee withQuantity:[[self.order objectForKey:@"quantity"] integerValue]];
        
        //Customize the UI
        dropInViewController.summaryTitle = [event objectForKey:@"eventName"];
        dropInViewController.summaryDescription = [event objectForKey:@"eventDescription"];
        dropInViewController.displayAmount = [NSString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [overallPrice floatValue]];
        
        [self.order saveInBackground]; // TO BE REMOVED, JUST FOR TESTING AT THE MOMENT
        
        [self presentViewController:[dropInViewController withNavigationController]
                           animated:YES
                         completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)getToken
{
    // TODO: Switch this URL to your own authenticated API
    NSURL *clientTokenURL = [NSURL URLWithString:@"https://protected-brook-8899.herokuapp.com/token.php"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection
     sendAsynchronousRequest:clientTokenRequest
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if(!connectionError) {
             // TODO: Handle errors in [(NSHTTPURLResponse *)response statusCode] and connectionError
             NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             // Initialize `Braintree` once per checkout session
             self.braintree = [Braintree braintreeWithClientToken:clientToken];
             self.clientToken = clientToken;
             self.buttonCheckout.enabled = TRUE;
         } else {
             if([(NSHTTPURLResponse *)response statusCode] == 0)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem while obtaining connecting to the payment processor, please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alertView show];
             }
             else if ([(NSHTTPURLResponse *)response statusCode] == 1)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem while obtaining connecting to the payment processor, please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                 [alertView show];
             }
         }
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
    [self.manager POST:@"https://protected-brook-8899.herokuapp.com/payment-methods.php"
            parameters:@{@"paymentMethodNonce": paymentMethodNonce,
                         @"amount": self.overallPrice}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSString *transactionID = responseObject[@"transaction"][@"id"];
                   self.transactionIDLabel.text = [[NSString alloc] initWithFormat:@"Transaction ID: %@", transactionID];
                   [self.order saveInBackground];
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
               }];
}

//- (void)postNonceToServer:(NSString *)paymentMethodNonce {
//    // Update URL with your server
//    NSURL *paymentURL = [NSURL URLWithString:@"https://your-server.example.com/payment-methods"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
//    request.HTTPBody = [[NSString stringWithFormat:@"payment_method_nonce=%@", paymentMethodNonce] dataUsingEncoding:NSUTF8StringEncoding];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               // TODO: Handle success and failure
//                           }];
//}

-(NSDecimalNumber *)addNumber:(NSDecimalNumber *)num1 andOtherNumber:(NSDecimalNumber *)num2 withQuantity:(NSInteger)quantity
{
    NSDecimalNumber *added = [[NSDecimalNumber alloc] initWithInt:0];
    NSDecimalNumber *quantityDec = [[NSDecimalNumber alloc] initWithInteger:quantity];
    
    NSDecimalNumber *overall = [added decimalNumberByAdding:[num1 decimalNumberByAdding:num2]];
    
    return [overall decimalNumberByMultiplyingBy:quantityDec];
}

@end
