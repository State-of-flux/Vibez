//
//  VenuesViewController.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "WhatsOnTestViewController.h"

@interface WhatsOnTestViewController ()
{
    PFUser* user;
}
@end

@implementation WhatsOnTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [PFUser currentUser];
    
    self.navigationItem.titleView = [self setTopBarButtons:user.username];
    [self.navigationItem setHidesBackButton:YES];
    
    //static NSString *eventCellIdentifier = @"EventCell";
    //static NSString *venueCellIdentifier = @"VenueCell";
    
//    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:eventCellIdentifier];
//    [self.collectionView registerClass:[VenueCollectionViewCell class] forCellWithReuseIdentifier:venueCellIdentifier];
//    [self.collectionView setDelegate:self];
    
    //self.isEventDataDisplayed = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(UIView*)setTopBarButtons:(NSString*)titleText
{

    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[titleText stringByAppendingString:@"'s Vibes"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    // [self.advSegmentedControl setFont:[UIFont fontWithName:@"Futura-Medium" size:14.0f]];
    
    return titleLabel;
}

@end
