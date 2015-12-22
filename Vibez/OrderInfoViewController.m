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
#import "Ticket+Additions.h"

#define kBTendpoint @"https://protected-brook-8899.herokuapp.com"
//#define kBTendpoint @"http://192.168.1.13:8080"


@interface OrderInfoViewController () {
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
    [self setNavBar:@"ORDER"];
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
            
            if ([[[self.eventInfoData objectAtIndex:indexPath.row] objectForKey:@"Id"] isEqualToString:@"eventId"]) {
                [cell setTag:100];
            } else if ([[[self.eventInfoData objectAtIndex:indexPath.row] objectForKey:@"Id"] isEqualToString:@"dateId"]) {
                [cell setTag:101];
            }
            
            break;
        case 1:
            name = [[self.paymentData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.paymentData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            
            if ([[[self.paymentData objectAtIndex:indexPath.row] objectForKey:@"Id"] isEqualToString:@"pricePerTicketId"]) {
                [cell setTag:102];
            } else if ([[[self.paymentData objectAtIndex:indexPath.row] objectForKey:@"Id"] isEqualToString:@"quantityId"]) {
                [cell setTag:103];
            }
            
            break;
        case 2:
            name = [[self.totalData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.totalData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            
            if ([[[self.totalData objectAtIndex:indexPath.row] objectForKey:@"Id"] isEqualToString:@"totalId"]) {
                [cell setTag:104];
            }
            
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
    
    if([cell tag] == 100)
    {
        [self setEventCell:cell];
    }
    else if([cell tag] == 101)
    {
        [self setDateCell:cell];
    }
    else if([cell tag] == 102)
    {
        [self setIndexPathPricePerTicket:indexPath];
        [self setPricePerTicketCell:cell];
    }
    else if([cell tag] == 103)
    {
        [self setQuantityCell:cell];
    }
    else if([cell tag] == 104)
    {
        [self setTotalCell:cell];
    }
    
    return cell;
}

- (void)setEventCell:(UITableViewCell *)cell {
    if ([[[self order] objectForKey:@"event"] objectForKey:@"eventName"]) {
        [[cell detailTextLabel] setText:[[[self order] objectForKey:@"event"] objectForKey:@"eventName"]];
    }
}

- (void)setDateCell:(UITableViewCell *)cell {
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEE dd MMM YYYY" options:0
                                                              locale:[NSLocale currentLocale]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    if ([[self.order objectForKey:@"event"] objectForKey:@"eventDate"]) {
        NSString *dateString = [dateFormatter stringFromDate:[[self.order objectForKey:@"event"] objectForKey:@"eventDate"]];
        [[cell detailTextLabel] setText:dateString];
    }
}

- (void)setPricePerTicketCell:(UITableViewCell *)cell {
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    [[cell accessoryView] setTintColor:[UIColor pku_purpleColor]];
    [[cell detailTextLabel] setText:[NSMutableString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [[self pricePerTicket] floatValue]]];
}

- (void)setQuantityCell:(UITableViewCell *)cell {
    if ([self.order objectForKey:@"quantity"]) {
        [[cell detailTextLabel] setText:[[self.order objectForKey:@"quantity"] stringValue]];
    }
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
    if ([[self indexPathPricePerTicket] isEqual:indexPath]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:NSLocalizedString(@"A small booking fee is applied to tickets to cover the cost of the transaction and support us! Look at our Terms and Conditions for more details.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)setNavBar:(NSString*)titleText
{
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelOrder:)];
    [[self navigationItem] setLeftBarButtonItem:buttonCancel];
    [[self navigationItem] setTitle:titleText];
}

- (void)cancelOrder:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonCheckoutPressed:(id)sender {

    [MBProgressHUD showStandardHUD:[self hud] target:[self navigationController] title:NSLocalizedString(@"Processing Order", nil) message:NSLocalizedString(@"Please wait...", nil)];

    if([reachability isReachable]) {
        [[self hud] setDetailsLabelText:NSLocalizedString(@"Checking quantities...", nil)];
        
        NSString *eventId = [[[self order] objectForKey:@"event"] objectForKey:@"eventID"];
        
        if ([eventId length] > 0) {
            [Event quantityRemainingFromParseWithId:eventId withBlock:^(BOOL succeeded, int quantityRemaining, NSError *error) {
                if (succeeded) {
                    if ((quantityRemaining - [self quantity]) >= 0) {
                        [[self hud] setDetailsLabelText:NSLocalizedString(@"Getting token...", nil)];
                        [self getTokenAndShowBrainTree];
                    } else {
                        [MBProgressHUD hideStandardHUD:[self hud] target:[self navigationController]];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problem", nil) message:NSLocalizedString(@"We ran out of tickets for this event! Sorry about that.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Fucks sake", nil) otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                }
            }];
        } else {
            [MBProgressHUD hideStandardHUD:[self hud] target:[self navigationController]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Event could not be found", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    } else {
        [MBProgressHUD hideStandardHUD:[self hud] target:[self navigationController]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please reconnect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)showBrainTreeViewController {
    Braintree *braintree = [Braintree braintreeWithClientToken:[self clientToken]];
    [self setDropInViewController:[braintree dropInViewControllerWithDelegate:self]];
    
    [self dropInViewController].navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                             target:self
                                                             action:@selector(userDidCancelPayment)];
    
    [[self dropInViewController] setTitle:NSLocalizedString(@"PAYMENT", nil)];
    
    PFObject *event = [[self order] objectForKey:@"event"];
    
    //Customize the UI
    [[self dropInViewController] setSummaryTitle:[event objectForKey:@"eventName"]];
    
    NSString *description = [event objectForKey:@"eventDescription"];
    NSString *shortString = ([description length] > 155 ? [description substringToIndex:155] : description);
    
    [[self dropInViewController] setSummaryDescription:shortString];
    [[self dropInViewController] setDisplayAmount:[NSString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [self.overallPrice floatValue]]];
    [[self dropInViewController] setCallToActionText:NSLocalizedString(@"Pay for Tickets", nil)];
    [self presentViewController:[[self dropInViewController] withNavigationController]
                       animated:YES
                     completion:nil];
}

-(void)getTokenAndShowBrainTree {
    
    [[self hud] setDetailsLabelText:NSLocalizedString(@"Fetching token...", nil)];
    
    // TODO: Switch this URL to your own authenticated API
    NSURL *clientTokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/token.php", kBTendpoint]];
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
         [MBProgressHUD hideStandardHUD:[self hud] target:[self navigationController]];
     }];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    [MBProgressHUD showStandardHUD:[self hud] target:[[self dropInViewController] navigationController] title:NSLocalizedString(@"Authorising Payment", nil) message:NSLocalizedString(@"Please wait...", nil)];
    // Payment has succeeded, so now we can save all the orders to parse.
    [self postNonceToServer:[paymentMethod nonce]];
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
                    
                    [self dismissViewControllerAnimated:NO completion:^{
                        [[self parentViewController] dismissViewControllerAnimated:NO completion:^{
                            [self notifyDelegateWithSuccess:YES];
                        }];
                    }];
                } else {
                    NSLog(@"Error when decrementing quantity: %@", [error localizedDescription]);
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
                [MBProgressHUD hideStandardHUD:[self hud] target:[[self dropInViewController] navigationController]];
            }];
        } else {
            [MBProgressHUD hideStandardHUD:[self hud] target:[[self dropInViewController] navigationController]];
            NSLog(@"Error: %@", [error localizedDescription]);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dropInViewControllerWillComplete:(BTDropInViewController *)viewController {
    NSLog(@"PAYMENT WILL COMPLETE");
}

-(void)userDidCancelPayment{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark POST NONCE TO SERVER method
- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    [[self manager] POST:[NSString stringWithFormat:@"%@/payment-methods.php", kBTendpoint]
              parameters:@{@"paymentMethodNonce": paymentMethodNonce,
                           @"amount": [[self overallPrice] stringValue]}
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     if([responseObject isKindOfClass:[NSDictionary class]]) {
                         if([[responseObject objectForKey:@"success"] boolValue]) {
                             //NSDictionary *tx  = [[responseObject objectForKey:@"response"] objectForKey:@"transaction"];
                             //NSLog(@"TX: %@", [tx objectForKey:@"id"]);
                             [self uploadOrderToParse];
                             NSLog(@"TRANSACTION SUCCESSFUL: %@", [[self overallPrice] stringValue]);
                         }
                     }
                     
                     //NSString *transactionID = responseObject[@"transaction"][@"id"];
                     //self.transactionIDLabel.text = [[NSString alloc] initWithFormat:@"Transaction ID: %@", transactionID];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [MBProgressHUD hideStandardHUD:[self hud] target:[[self dropInViewController] navigationController]];
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
    switch (section) {
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
    return [[self data] count];
}

#pragma mark - UIPickerView Methods

- (void)showQuantityPicker:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"How many tickets?", nil)
                                            rows:[self.arrayOfQuantities copy]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           if ([selectedValue integerValue] == [[[self order] objectForKey:@"quantity"] integerValue]) {
                                               return;
                                           }
                                           
                                           [self setQuantitySelected:[selectedValue integerValue]];
                                           
                                           if([self quantitySelected])
                                           {
                                               [MBProgressHUD showStandardHUD:[self hud] target:[self navigationController] title:NSLocalizedString(@"Loading", nil) message:NSLocalizedString(@"Modifying order", nil)];
                                               
                                               [Ticket getAmountOfTicketsUserOwnsOnEventPFObject:[[self order] objectForKey:@"event"] withBlock:^(int quantityOfTickets, NSError *error) {
                                                   
                                                   if (!error) {
                                                       if((quantityOfTickets + [self quantitySelected]) <= 10)
                                                       {
                                                           //[self createOrderAndProceed];
                                                           NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                                                           [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                                                           NSNumber *quantityValue = [numFormatter numberFromString:selectedValue];
                                                           [[self order] setObject:quantityValue forKey:@"quantity"];
                                                           [self setPaymentValues];
                                                           [[self tableView] reloadData];
                                                       }
                                                       else
                                                       {
                                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid", @"Invalid") message:[NSString stringWithFormat:NSLocalizedString(@"You can only buy up to 10 tickets per event. You currently have %ld.", nil), quantityOfTickets] delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                                                           [alert show];
                                                       }
                                                   } else {
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"A problem occurred while trying to count your tickets, please try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                                                       [alert show];
                                                   }
                                                   
                                                   [MBProgressHUD hideStandardHUD:[self hud] target:[self navigationController]];
                                               }];
                                           }
                                           else
                                           {
                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"An error occured, restarting the app my resolve this issue.", @"An error occured, restarting the app my resolve this issue.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                                               [alert show];
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     } origin:sender];
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self arrayOfQuantities] count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.arrayOfQuantities[row];
}

- (void)notifyDelegateWithSuccess:(BOOL)success {
    if (_delegate) {
        [_delegate paymentSuccessful:success];
    }
}

@end
