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

@interface WhatsOnViewController () <UISearchBarDelegate>
{
    PFUser* user;
    FetchedCollectionViewContainerViewController *fetchVC;
}
@end

@implementation WhatsOnViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fetchVC = self.childViewControllers[0];
    
    user = [PFUser currentUser];
    self.navigationItem.titleView = [self setTopBarButtons:user.username];
    [self.navigationItem setHidesBackButton:YES];
}

-(UIView*)setTopBarButtons:(NSString*)titleText
{
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[titleText stringByAppendingString:@"'s Vibes"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont pik_montserratRegWithSize:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    // [self.advSegmentedControl setFont:[UIFont fontWithName:@"Futura-Medium" size:14.0f]];
    
    return titleLabel;
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
