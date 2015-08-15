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
#import "SQKFetchedCollectionViewController.h"
#import "VenueFetchedCollectionViewContainerViewController.h"
#import "UIColor+Piktu.h"
#import "EventInfoViewController.h"
#import "VenueInfoViewController.h"

@interface WhatsOnViewController ()
{
    PFUser* user;
    FetchedCollectionViewContainerViewController *eventVC;
    VenueFetchedCollectionViewContainerViewController *venueVC;
    CLLocationManager *manager;
}
@end

@implementation WhatsOnViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewSegmentedControl.clipsToBounds = YES;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor pku_blackColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.viewSegmentedControl.frame), CGRectGetHeight(self.viewSegmentedControl.frame)+1);
    
    [self.viewSegmentedControl.layer addSublayer:bottomBorder];
    
    eventVC = self.childViewControllers.lastObject;
    venueVC = self.childViewControllers.firstObject;
    self.currentVC = eventVC;
    
    user = [PFUser currentUser];
    //self.navigationItem.title = @"Hunt for Vibes";
    
    UIImageView *imageViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [imageViewTitle setImage:[UIImage imageNamed:@"logoTitleView"]];
    [imageViewTitle setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imageViewTitle;
    
    manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
    [manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        NSLog(@"Our new location: %@", location);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:@"Sheffield" forKey:@"currentLocation"];
        [defaults synchronize];
        
        NSString *thelocation = [defaults valueForKey:@"currentLocation"];
        NSLog(@"Our new location: %@", thelocation);
    }];
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
    switch ([sender selectedIndex]) {
        case 0:
            if (self.currentVC == venueVC) {
                [self addChildViewController:eventVC];
                //eventVC.view.frame = self.container.bounds;
                [self moveToNewController:eventVC];
            }
            break;
        case 1:
            if (self.currentVC == eventVC) {
                [self addChildViewController:venueVC];
                //venueVC.view.frame = self.container.bounds;
                [self moveToNewController:venueVC];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Animate Container Views

-(void)moveToNewController:(UIViewController *) newController {
    [self.currentVC willMoveToParentViewController:nil];
    [self transitionFromViewController:self.currentVC toViewController:newController duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil
                            completion:^(BOOL finished) {
                                [self.currentVC removeFromParentViewController];
                                [newController didMoveToParentViewController:self];
                                self.currentVC = newController;
                            }];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"eventToEventInfoSegue"])
    {
        EventInfoViewController *destinationVC = segue.destinationViewController;
        destinationVC.event = [eventVC event];
    }
    else if([segue.identifier isEqualToString:@"venueToVenueInfoSegue"])
    {
        VenueInfoViewController *destinationVC = segue.destinationViewController;
        destinationVC.venue = [venueVC venue];
    }
}

@end
