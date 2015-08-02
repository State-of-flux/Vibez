//
//  PaymentViewController.h
//  Vibez
//
//  Created by Harry Liddell on 20/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKView.h"

@interface PaymentViewController : UIViewController <PTKViewDelegate>

@property(weak, nonatomic) PTKView *paymentView;

@end
