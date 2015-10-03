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
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "Order+Additions.h"

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
    
    [self setArrayOfQuantities:[NSMutableArray array]];
    
    for(NSInteger i = 1; i <= 10; i++) {
        [self.arrayOfQuantities addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    reachability = [Reachability reachabilityForInternetConnection];
    [self setManager:[AFHTTPRequestOperationManager manager]];
}

- (void)setPaymentValues
{
    PFObject *event = [[self order] objectForKey:@"event"];
    [self setQuantity:[[[self order] objectForKey:@"quantity"] integerValue]];
    [self setPrice:[[NSDecimalNumber alloc] initWithFloat:[[event objectForKey:@"price"] floatValue]]];
    [self setBookingFee:[[NSDecimalNumber alloc] initWithFloat:[[event objectForKey:@"bookingFee"] floatValue]]];
    NSDecimalNumber *pricePerTicket = [[self price] decimalNumberByAdding:[self bookingFee]];
    [self setPricePerTicket:pricePerTicket];
    [self setOverallPrice:[self addNumber:[self price] andOtherNumber:[self bookingFee] withQuantity:[self quantity]]];
}

- (void)setupView {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Order" ofType:@"plist"];
    
    self.data = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"Sections"];
    self.eventInfoData = [self.data objectForKey:@"Event Info"];
    self.paymentData = [self.data objectForKey:@"Payment"];
    self.totalData = [self.data objectForKey:@"Total"];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    [self.buttonCheckout setImage:[factory createImageForIcon:NIKFontAwesomeIconLock] forState:UIControlStateNormal];
    [self.buttonCheckout setTintColor:[UIColor whiteColor]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    BOOL isInteractableCell;
    NSString *name = [[NSString alloc] init];
    
    switch (indexPath.section)
    {
        case 0:
            name = [[self.eventInfoData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.eventInfoData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            break;
        case 1:
            name = [[self.paymentData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.paymentData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            break;
        case 2:
            name = [[self.totalData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.totalData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            break;
        default:
            [cell.textLabel setText:@""];
    }
    
    [cell.textLabel setText:name];
    
    if(isInteractableCell)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        [cell setUserInteractionEnabled:NO];
    }
    
    if([[[cell textLabel] text] isEqualToString:@"Event"])
    {
        [self setEventCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Date"])
    {
        [self setDateCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Price per ticket"])
    {
        [self setPricePerTicketCell:cell];
        
    }
    else if([[[cell textLabel] text] isEqualToString:@"Quantity"])
    {
        [self setQuantityCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Total"])
    {
        [self setTotalCell:cell];
    }
    
    return cell;
}

- (void)setEventCell:(UITableViewCell *)cell {
    [[cell detailTextLabel] setText:[[[self order] objectForKey:@"event"] objectForKey:@"eventName"]];
}

- (void)setDateCell:(UITableViewCell *)cell {
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE dd MMM YYYY" options:0
                                                              locale:[NSLocale currentLocale]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    NSString *dateString = [dateFormatter stringFromDate:[[self.order objectForKey:@"event"] objectForKey:@"eventDate"]];
    [[cell detailTextLabel] setText:dateString];
}

- (void)setPricePerTicketCell:(UITableViewCell *)cell {
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    [[cell detailTextLabel] setText:[NSMutableString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [[self pricePerTicket] floatValue]]];
}

- (void)setQuantityCell:(UITableViewCell *)cell {
    [[cell detailTextLabel] setText:[[self.order objectForKey:@"quantity"] stringValue]];
}

- (void)setTotalCell:(UITableViewCell *)cell {
    NSMutableString *priceTotalString = [NSMutableString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [[self overallPrice] floatValue]];
    [[cell detailTextLabel] setText:priceTotalString];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([[[cell textLabel] text] isEqualToString:@"Quantity"]) {
        [self showQuantityPicker:cell];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
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
    if([reachability isReachable]) {
        [self getTokenAndShowBrainTree];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)showBrainTreeViewController {
    Braintree *braintree = [Braintree braintreeWithClientToken:[self clientToken]];
    BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];
    
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                             target:self
                                                             action:@selector(userDidCancelPayment)];
    
    PFObject *event = [[self order] objectForKey:@"event"];
    
    //Customize the UI
    [dropInViewController setSummaryTitle:[event objectForKey:@"eventName"]];
    [dropInViewController setSummaryDescription:[event objectForKey:@"eventDescription"]];
    [dropInViewController setDisplayAmount:[NSString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [self.overallPrice floatValue]]];
    [dropInViewController setCallToActionText:NSLocalizedString(@"Pay for Tickets", nil)];
    [self presentViewController:[dropInViewController withNavigationController]
                       animated:YES
                     completion:nil];
}

-(void)getTokenAndShowBrainTree {
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
             [self setClientToken:clientToken];
             
             if (clientToken) {
                 [self showBrainTreeViewController];
                 [[self buttonCheckout] setEnabled:YES];
             }
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
    // Payment has succeeded, so now we can save all the orders to parse.
    [self postNonceToServer:[paymentMethod nonce]];
    [self uploadOrderToParse];
}

- (void)uploadOrderToParse {
    // Create the tickets and set them to the order, then save.
    [[self order] setObject:[Order createTicketsForOrder:[self order]] forKey:@"tickets"];
    [[self order] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            PFObject *event = [[self order] objectForKey:@"event"];
            NSInteger quantity = [self quantity];
            [event incrementKey:@"quantity" byAmount:[NSNumber numberWithInteger:-quantity]];
            [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Successfully decremented the quantity");
                } else {
                    NSLog(@"Error when decrementing quantity: %@", [error localizedDescription]);
                }
            }];
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)userDidCancelPayment{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark POST NONCE TO SERVER method
- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    [[self manager] POST:@"https://protected-brook-8899.herokuapp.com/payment-methods.php"
              parameters:@{@"paymentMethodNonce": paymentMethodNonce,
                           @"amount": [[self overallPrice] stringValue]}
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSString *transactionID = responseObject[@"transaction"][@"id"];
                     self.transactionIDLabel.text = [[NSString alloc] initWithFormat:@"Transaction ID: %@", transactionID];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", [error localizedDescription]);
                      NSLog(@"Operation: %@", operation);
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [self.eventInfoData count];
        case 1:
            return [self.paymentData count];
        case 2:
            return [self.totalData count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0:
            return @"Event Information";
        case 1:
            return @"Price";
        case 2:
            return @"Total";
        default:
            return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

#pragma mark - UIPickerView Methods

- (void)showQuantityPicker:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"How many tickets?"
                                            rows:[self.arrayOfQuantities copy]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           
                                           NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                                           [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                                           NSNumber *quantityValue = [numFormatter numberFromString:selectedValue];
                                           [[self order] setObject:quantityValue forKey:@"quantity"];
                                           [self setPaymentValues];
                                           [[self tableView] reloadData];
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                       } origin:sender];
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.arrayOfQuantities count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.arrayOfQuantities[row];
}

@end
