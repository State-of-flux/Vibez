//
//  OrderInfoViewController.h
//  Vibez
//
//  Created by Harry Liddell on 19/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoViewController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *labelEventName;
@property (strong, nonatomic) UILabel *labelPriceTotal;
@property (strong, nonatomic) UILabel *labelQuantity;
@property (strong, nonatomic) UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UIButton *buttonCheckout;
- (IBAction)buttonCheckoutPressed:(id)sender;

@end
