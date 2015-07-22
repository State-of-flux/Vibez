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

    eventVC = self.childViewControllers.lastObject;
    venueVC = self.childViewControllers[0];
    self.currentVC = eventVC;
    
    user = [PFUser currentUser];
    self.navigationItem.title = @"Hunt for Vibes";
    
    manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    [manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        NSLog(@"Our new location: %@", location);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:@"blahblah" forKey:@"currentLocation"];
        [defaults synchronize];

        NSString *thelocation = [defaults valueForKey:@"currentLocation"];
        NSLog(@"Our new location: %@", thelocation);

    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.view.clipsToBounds && !self.view.hidden && self.view.alpha > 0) {
        for (UIView *subview in self.view.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self.view];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
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
    [self transitionFromViewController:self.currentVC toViewController:newController duration:.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil
                            completion:^(BOOL finished) {
                                [self.currentVC removeFromParentViewController];
                                [newController didMoveToParentViewController:self];
                                self.currentVC = newController;
                            }];
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

@end
