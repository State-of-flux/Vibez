//
//  PIKSegmentedControl.h
//  Vibez
//
//  Created by Harry Liddell on 18/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIKSegmentedControl : UIControl

@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *items;

@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) UIView *thumbView;
@property (strong, nonatomic) UIColor *selectedLabelColor;
@property (strong, nonatomic) UIColor *unselectedLabelColor;
@property (strong, nonatomic) UIColor *thumbColor;
@property (strong, nonatomic) UIColor *borderColor;

@property (strong, nonatomic) UIFont *font;

@end
