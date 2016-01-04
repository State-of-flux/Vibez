//
//  ScannerViewController.m
//  Vibez
//
//  Created by Harry Liddell on 03/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "ScannerViewController.h"
#import <Reachability/Reachability.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import "RKDropdownAlert.h"
#import "EventSelectorViewController.h"
#import "UIViewController+NavigationController.h"

@interface ScannerViewController ()
{
    Reachability *reachability;
}
@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    reachability = [Reachability reachabilityForInternetConnection];
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [factory setSize:25.0f];
    
    [self.buttonTorch setImage:[factory createImageForIcon:NIKFontAwesomeIconFlash] forState:UIControlStateNormal];
    [self.buttonTorch setTintColor:[UIColor whiteColor]];
    
    [self.buttonRefresh setImage:[factory createImageForIcon:NIKFontAwesomeIconRefresh] forState:UIControlStateNormal];
    [self.buttonRefresh setTintColor:[UIColor whiteColor]];
    
    [self checkIfEventIsSelected];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self checkIfEventIsSelected];
    
    if (![Event eventIdForAdmin]) {
        [[self buttonEventName] setTitle:@"SELECT EVENT" forState:UIControlStateNormal];
    } else {
        [self setupView];
    }
}

- (void)checkIfEventIsSelected {
    if ([Event eventIdForAdmin]) {
        [self setupView];
    } else {
        EventSelectorViewController *vc = [EventSelectorViewController create];
        [self presentViewController:[vc withNavigationControllerWithOpaque] animated:self completion:nil];
    }
}

- (void)setupView {
    self.controller = [[SQKManagedObjectController alloc] initWithFetchRequest:[Ticket sqk_fetchRequest] managedObjectContext:[PIKContextManager mainContext]];
    [self.controller setDelegate:self];
    
    NSError *error;
    [self.controller fetchRequest];
    [self.controller performFetch:&error];
    
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    self.uniqueCodes = [NSMutableArray array];
    
    [self.buttonEventName setTitle:[[Event eventNameForAdmin] uppercaseString] forState:UIControlStateNormal];
    
    if(![self scanner]) {
        [self startScanning];
    }
}

- (void)startScanning {
    self.scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]
                                                              previewView:self.scanView];
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        
        // PAUSE THE SCANNER WHILE THE RESPONSE OCCURS
        //[self.scanner stopScanning];
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(setIsShowingScanResponseToNo)
                                           userInfo:nil
                                            repeats:NO];
            [[self scanner] freezeCapture];
            [self handleCode:code];
        }
    }];
}

- (void)handleCode:(AVMetadataMachineReadableCodeObject *)code {
    
    // If qr code has not already been scanned, then search through all tickets on the device.
    // If a ticket is found to match the qr code, set the property hasBeenUsed to true on the ticket and save it to Parse.
    // If the ticket has not been found, then it must not exist, recommend refreshing the data, or say that it's not valid.
    if ([self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound)
    {
        [self.uniqueCodes addObject:code.stringValue];
        NSLog(@"Found unique code: %@", code.stringValue);
        
        if ([[self.controller managedObjects] count] == 0) {
            [self invalidTicket:nil];
        }
        
        BOOL ticketFound = NO;
        Ticket *ticketScanned;
        
        for(Ticket *ticket in [self.controller managedObjects]) {
            if ([ticket.ticketID isEqualToString:code.stringValue]) {
                ticketFound = YES;
                ticketScanned = ticket;
                break;
            }
        }
        
        if (ticketFound && ticketScanned) {
            // VALID TICKET, NOT SCANNED
            if([ticketScanned.hasBeenUsed isEqualToNumber:@0]) {
                [self validTicketFound:ticketScanned];
            }
            
            // VALID TICKET, ALREADY SCANNED
            else if([ticketScanned.hasBeenUsed isEqualToNumber:@1]) {
                [self validTicketFoundAlreadyScanned:ticketScanned];
            }
        } else {
            [self invalidTicket:ticketScanned];
        }
    }
    // This code has already been scanned before, so it must either be a valid ticket that has already been scanned
    // Or it must not be an invalid ticket.
    // Or it is a code that has already been scanned, but wasn't found on the system because the data wasn't up to date.
    else
    {
        if ([[self.controller managedObjects] count] == 0) {
            [self invalidTicket:nil];
        }
        
        BOOL ticketFound = NO;
        Ticket *ticketScanned;
        
        for(Ticket *ticket in [self.controller managedObjects]) {
            if ([ticket.ticketID isEqualToString:code.stringValue]) {
                ticketFound = YES;
                ticketScanned = ticket;
                break;
            }
        }
        
        if (ticketFound && ticketScanned) {
            // VALID TICKET, NOT SCANNED
            if([ticketScanned.hasBeenUsed isEqualToNumber:@0]) {
                [self validTicketFound:ticketScanned];
            }
            
            // VALID TICKET, ALREADY SCANNED
            else if([ticketScanned.hasBeenUsed isEqualToNumber:@1]) {
                [self validTicketFoundAlreadyScanned:ticketScanned];
            }
        } else {
            [self invalidTicket:ticketScanned];
        }
    }
    
    [self performSelector:@selector(unfreezeCaptureOnScanner) withObject:nil afterDelay:2.0f];
    
}

- (void)unfreezeCaptureOnScanner {
    [[self scanner] unfreezeCapture];
}

- (void)setIsShowingScanResponseToYes {
    [self setIsShowingScanResponse:YES];
}

- (void)setIsShowingScanResponseToNo {
    [self setIsShowingScanResponse:NO];
}

- (void)validTicketFound:(Ticket *)ticket {
    [ticket setHasBeenUsed:[NSNumber numberWithBool:YES]];
    [ticket saveToParse];
    [MBProgressHUD showSuccessHUD:[self hud] target:self title:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"Ticket valid", nil)];
    
    //[RKDropdownAlert title:[NSString stringWithFormat:@"Ticket scanned"] message:nil backgroundColor:[UIColor pku_SuccessColor] textColor:[UIColor whiteColor] time:1.0];
}

- (void)validTicketFoundAlreadyScanned:(Ticket *)ticket {
    [MBProgressHUD showInfoHUD:[self hud] target:self title:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"Ticket already scanned", nil)];
    //[RKDropdownAlert title:[NSString stringWithFormat:@"Ticket has already been scanned"] message:nil backgroundColor:[UIColor pku_purpleColor] textColor:[UIColor whiteColor] time:1.0];
}

- (void)validTicketNotScannedOnDevice:(Ticket *)ticket {
    [ticket setHasBeenUsed:@1];
    [ticket saveToParse];
    [MBProgressHUD showSuccessHUD:[self hud] target:self title:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"Ticket valid", nil)];
    
    //[RKDropdownAlert title:[NSString stringWithFormat:@"Ticket scanned"] message:nil backgroundColor:[UIColor pku_SuccessColor] textColor:[UIColor whiteColor] time:1.0];
}

- (void)invalidTicket:(Ticket *)ticket {
    
    [MBProgressHUD showFailureHUD:[self hud] target:self title:NSLocalizedString(@"Failed", nil) message:NSLocalizedString(@"Ticket invalid", nil)];
    
    //[RKDropdownAlert title:[NSString stringWithFormat:@"Ticket does not exist or data is out of date"] message:@"A refresh might be required" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1.0];
}

- (void)refresh:(id)sender
{
    if([reachability isReachable])
    {
        PFObject *eventObject = [PFObject objectWithoutDataWithClassName:@"Event" objectId:[Event eventIdForAdmin]];
        
        [Ticket getTicketsForEvent:eventObject fromParseWithSuccessBlock:^(NSArray *objects) {
            NSError *error;
            
            NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
            [Ticket importTickets:objects intoContext:newPrivateContext];
            [Ticket deleteInvalidTicketsInContext:newPrivateContext];
            [newPrivateContext save:&error];
            
            NSError *errorFetch;
            
            if(error)
            {
                NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
            }
            
            if(errorFetch)
            {
                NSLog(@"Fetch Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
            }
        }
                      failureBlock:^(NSError *error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please connect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert setTintColor:[UIColor pku_purpleColor]];
        [alert show];
    }
}

- (IBAction)buttonEventNamePressed:(id)sender {
    EventSelectorViewController *vc = [EventSelectorViewController create];
    [self presentViewController:[vc withNavigationControllerWithOpaque] animated:self completion:nil];
}

- (IBAction)buttonTorchPressed:(id)sender {
    if([self.scanner torchMode] == 0) {
        [self.scanner setTorchMode:1];
    } else if([self.scanner torchMode] == 1) {
        [self.scanner setTorchMode:0];
    }
}
- (IBAction)buttonRefreshPressed:(id)sender {
    [self refresh:self];
}



@end
