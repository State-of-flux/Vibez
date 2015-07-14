//
//  WhatsOnViewController.m
//  Vibez
//
//  Created by Harry Liddell on 01/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "WhatsOnViewController.h"
#import "FetchedCollectionViewContainerViewController.h"
#import "UIFont+PIK.h"
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>

@interface WhatsOnViewController () 
{
    PFUser* user;
    FetchedCollectionViewContainerViewController *fetchVC;
    CLLocationManager *manager;
}
@end

@implementation WhatsOnViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fetchVC = self.childViewControllers[0];
    
    user = [PFUser currentUser];
    [self setNavBar:@"Hunt for Vibes"];
    
    manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    [manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        NSLog(@"Our new location: %@", location);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //NSString *lat = location.coordinate.latitude;
        //NSString *lon = ;
        
        [defaults setValue:@"blahblah" forKey:@"currentLocation"];
        [defaults synchronize];

        NSString *thelocation = [defaults valueForKey:@"currentLocation"];
        NSLog(@"Our new location: %@", thelocation);

    }];
    
}

-(void)setNavBar:(NSString*)titleText
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning Received.");
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

#pragma mark - UISegmentedControl

- (IBAction)advsegmentedControlTapped:(id)sender
{
    if([sender selectedIndex] == 0)
    {
        [fetchVC SwapCellsToEventData];
    }
    else if ([sender selectedIndex] == 1)
    {
        [fetchVC SwapCellsToVenueData];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"whatsOnToContainerViewSegue"])
    {
        
    }
    else if([segue.identifier isEqualToString:@"eventToEventInfoSegue"])
    {
    
    }
    else if([segue.identifier isEqualToString:@"venueToVenueInfoSegue"])
    {
    
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
