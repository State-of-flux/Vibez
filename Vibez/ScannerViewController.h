//
//  ScannerViewController.h
//  Vibez
//
//  Created by Harry Liddell on 03/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>
#import "Event+Additions.h"
#import "Ticket+Additions.h"
#import <SQKDataKit/SQKManagedObjectController.h>

@interface ScannerViewController : UIViewController <SQKManagedObjectControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (strong, nonatomic) MTBBarcodeScanner *scanner;
@property (strong, nonatomic) Event *eventSelected;
@property (nonatomic, strong) SQKManagedObjectController *controller;

@end
