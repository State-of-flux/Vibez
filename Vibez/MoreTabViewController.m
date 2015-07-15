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
    [self setNavBar:@"More"];
    
}

-(void)setNavBar:(NSString*)titleText
{
    //UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    //UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    //UIFont *customFont = [UIFont fontWithName:@"Futura-Medium" size:24.0];
    //NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    //[settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
    
    //self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
    //self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[titleText stringByAppendingString:@""]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont pik_avenirNextRegWithSize:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    self.navigationItem.titleView = titleLabel;
}

@end
