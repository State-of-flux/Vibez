//
//  MoreTabViewController.m
//  Vibez
//
//  Created by Harry Liddell on 14/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "MoreTabViewController.h"
#import "UIColor+Piktu.h"
#import "UIFont+PIK.h"

@interface MoreTabViewController ()

@end

@implementation MoreTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar:@"MORE"];
}

-(void)setNavBar:(NSString*)titleText
{
    self.navigationItem.title = titleText;
}

@end
