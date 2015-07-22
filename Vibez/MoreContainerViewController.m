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

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.logoutCell setTarget:self action:@selector(logout)];
    [self.linkToFacebookCell setTarget:self action:@selector(linkToFacebook)];

}

- (void)logout {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate logout];
}

- (void)linkToFacebook {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate linkParseAccountToFacebook];
}

@end
