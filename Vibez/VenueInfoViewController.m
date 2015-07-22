//
//  VenueInfoViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueInfoViewController.h"

@interface VenueInfoViewController ()

@end

@implementation VenueInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons:@"Plug"];
    // Do any additional setup after loading the view.
}

-(void)setTopBarButtons:(NSString*)titleText
{
    UIBarButtonItem *buttonLocation = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buttonLocationPressed)];
    
    self.navigationItem.rightBarButtonItem = buttonLocation;
    self.navigationItem.title = titleText;
}

-(void)buttonLocationPressed
{
    [self performSegueWithIdentifier:@"toMapSegue" sender:self];
    NSLog(@"location button clicked");
}

@end
