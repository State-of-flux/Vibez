//
//  MoreContainerViewController.m
//  Vibez
//
//  Created by Harry Liddell on 14/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "MoreContainerViewController.h"
#import "AppDelegate.h"

@interface MoreContainerViewController ()

@end

@implementation MoreContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.logoutCell setTarget:self action:@selector(logout)];
    
}

- (void)logout {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate logout];
}

@end
