//
//  ScannerViewController.m
//  Vibez
//
//  Created by Harry Liddell on 03/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "ScannerViewController.h"


@interface ScannerViewController ()

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]
                                                 previewView:self.view];
    
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

@end
