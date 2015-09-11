//
//  ScannerViewController.m
//  Vibez
//
//  Created by Harry Liddell on 03/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "ScannerViewController.h"
#import <Reachability/Reachability.h>

@interface ScannerViewController ()
{
    Reachability *reachability;
}
@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    reachability = [Reachability reachabilityForInternetConnection];
    
    self.controller = [[SQKManagedObjectController alloc] initWithFetchRequest:[Ticket sqk_fetchRequest] managedObjectContext:[PIKContextManager mainContext]];
    [self.controller setDelegate:self];
    
    //[self.scanView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    [self startScanning];
}

- (void)startScanning {
    self.scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]
                                                              previewView:self.scanView];
    
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            
            
            //            if ([self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
            //                [self.uniqueCodes addObject:code.stringValue];
            //                NSLog(@"Found unique code: %@", code.stringValue);
            //            }
            
            NSLog(@"Here is my code: %@", code.stringValue);
        }
    }];
}

- (void)refresh:(id)sender
{
    if([reachability isReachable])
    {
        [Ticket getTicketsForUserFromParseWithSuccessBlock:^(NSArray *objects) {
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please connect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
