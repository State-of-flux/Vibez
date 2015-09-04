//
//  ScannerViewController.h
//  Vibez
//
//  Created by Harry Liddell on 03/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>

@interface ScannerViewController : UIViewController

@property (strong, nonatomic) MTBBarcodeScanner *scanner;

@end
