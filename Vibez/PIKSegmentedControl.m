//
//  PIKSegmentedControl.m
//  Vibez
//
//  Created by Harry Liddell on 18/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "PIKSegmentedControl.h"
#import "UIColor+Piktu.h"

@implementation PIKSegmentedControl

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void) setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self displayNewSelectedIndex];
}

- (void) setItems:(NSMutableArray *)items {
    _items = items;
    
    [self setupLabels];
}

- (void) setSelectedLabelColor:(UIColor *)selectedLabelColor {
    _selectedLabelColor = selectedLabelColor;
    
    [self setSelectedColors];
}

- (void) setUnselectedLabelColor:(UIColor *)unselectedLabelColor {
    _unselectedLabelColor = unselectedLabelColor;
    
    [self setSelectedColors];
}

- (void) setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    
    [self setSelectedColors];
}

- (void) setupView {
    
    self.selectedIndex = 0;
    self.items = [NSMutableArray arrayWithArray:@[@"Events", @"Venues"]];
    
    self.selectedLabelColor = [UIColor whiteColor];
    self.unselectedLabelColor = [UIColor lightGrayColor];
    self.thumbColor = [UIColor pku_purpleColor];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 2.0f;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setupLabels];
    
    [self addIndividualItemConstraints:[self labels] mainView:self padding:0];
    
    [self insertSubview:[self thumbView] atIndex:0];
}

- (void) setupLabels {
    
    for (UILabel *label in [self labels]) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
    
    for (int i = 1; i < [[self items] count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        [label setText:[[self items] objectAtIndex:i-1]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[self font]];
        [label setTextColor: i == 1 ? [self selectedLabelColor] : [self unselectedLabelColor]];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:label];
        [[self labels] addObject:label];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect selectedFrame = [self bounds];
    CGFloat newWidth = CGRectGetWidth(selectedFrame) / [[self items] count];
    selectedFrame.size.width = newWidth;
    
    [[self thumbView] setFrame:selectedFrame];
    [[self thumbView] setBackgroundColor:[self thumbColor]];
    [[[self thumbView] layer] setCornerRadius:0.0f];
    [self displayNewSelectedIndex];
}

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    
    NSNumber *calculatedIndex;
    
    NSInteger index;
    
    for (UILabel *label in [self labels]) {
        if (CGRectContainsPoint([label frame], location)) {
            calculatedIndex = [NSNumber numberWithInteger:index];
        }
        
        index++;
    }
    
    if (calculatedIndex != nil) {
        [self setSelectedIndex:[calculatedIndex integerValue]];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return false;
}

- (void) displayNewSelectedIndex {
    for (UILabel *item in [self labels]) {
        [item setTextColor:[self unselectedLabelColor]];
    }
    
    UILabel *label = [[self labels] objectAtIndex:[self selectedIndex]];
    [label setTextColor:[self selectedLabelColor]];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.5 options:0 animations:^{
        [[self thumbView] setFrame:[label frame]];
    } completion:nil];
}

- (void) addIndividualItemConstraints:(NSArray *)items mainView:(UIView *)mainView padding:(CGFloat)padding {
    //NSArray *constraints = [mainView constraints];
    
    NSUInteger index = 0;
    
    for (UIView *button in items) {
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *rightConstraint;
        
        if (index == [items count] - 1) {
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
        } else {
            UIView *nextButton = [items objectAtIndex:index + 1];
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-padding];
        }
        
        NSLayoutConstraint *leftConstraint;
        
        if (index == 0) {
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
        } else {
            UIView *previousButton = [items objectAtIndex:index - 1];
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:padding];
            
            UIView *firstItem = [items objectAtIndex:0];
            
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstItem attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
            
            [mainView addConstraint:widthConstraint];
        }
        
        [mainView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
        
        index++;
    }
}

- (void) setSelectedColors {
    for (UILabel *label in [self labels]) {
        [label setTextColor:[self unselectedLabelColor]];
    }
    
    if ([[self labels] count] > 0) {
        UILabel *label = [[self labels] objectAtIndex:0];
        [label setTextColor:[self selectedLabelColor]];
    }
    
    [[self thumbView] setBackgroundColor:[self thumbColor]];
}

- (void) setFont:(UIFont *)font {
    _font = font;
    
    for (UILabel *label in [self items]) {
        [label setFont:font];
    }
}

@end
