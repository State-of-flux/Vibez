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

@interface WhatsOnViewController () {
    PFUser* user;
    FetchedCollectionViewContainerViewController *eventVC;
    VenueFetchedCollectionViewContainerViewController *venueVC;
}
@end

@implementation WhatsOnViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    self.viewSegmentedControl.clipsToBounds = YES;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor pku_blackColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.viewSegmentedControl.frame), CGRectGetHeight(self.viewSegmentedControl.frame)+1);
    
    //[self.viewSegmentedControl.layer addSublayer:bottomBorder];
    
    eventVC = self.childViewControllers.lastObject;
    venueVC = self.childViewControllers.firstObject;
    self.currentVC = eventVC;
    
    user = [PFUser currentUser];
    //self.navigationItem.title = @"Hunt for Vibes";
    
    UIImageView *imageViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [imageViewTitle setImage:[UIImage imageNamed:@"logoTitleView"]];
    [imageViewTitle setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imageViewTitle;
    
    //[self addBorder:UIRectEdgeBottom color:[UIColor blackColor] thickness:0.3f toView:self.viewSegmentedControl];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness toView:(UIView *)view
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(view.frame) - thickness, CGRectGetWidth(view.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(view.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(view.frame) - thickness, 0, thickness, CGRectGetHeight(view.frame));
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [view.layer addSublayer:border];
    
    return border;
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
