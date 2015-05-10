//
//  HomeViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "HomeViewController.h"
#import "EventCollectionViewCell.h"
#import "VenueCollectionViewCell.h"

@interface HomeViewController ()
{

}
@end

//FAKFontAwesome *starIcon = [FAKFontAwesome starIconWithSize:15];

@implementation HomeViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTopBarButtons];
    
    static NSString *eventCellIdentifier = @"EventCell";
    static NSString *venueCellIdentifier = @"VenueCell";
    
    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:eventCellIdentifier];
    [self.collectionView registerClass:[VenueCollectionViewCell class] forCellWithReuseIdentifier:venueCellIdentifier];
    [self.collectionView setDelegate:self];
    
    self.isEventDataDisplayed = YES;
    
    
}

-(void)setTopBarButtons
{
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    UIFont *customFont = [UIFont fontWithName:@"Futura-Medium" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
    
    self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"Find Your Vibe"];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    self.navigationItem.titleView = titleLabel;
    
    [self.advSegmentedControl setFont:[UIFont fontWithName:@"Futura-Medium" size:14.0f]];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning Received.");
}

-(void)SwapCellsToEventData
{
    [self.collectionView setDataSource:self.eventDataSource];
    [self.collectionView reloadData];
}

-(void)SwapCellsToVenueData
{
    [self.collectionView setDataSource:self.venueDataSource];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@""])
    {
        
    }
}

-(void)searchAction
{
    NSLog(@"search button clicked");
}

-(void)settingsAction
{
    NSLog(@"settings button clicked");
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UISegmentedControl

- (IBAction)advsegmentedControlTapped:(id)sender
{
    if([sender selectedIndex] == 0)
    {
        [self SwapCellsToEventData];
    }
    else if ([sender selectedIndex] == 1)
    {
        [self SwapCellsToVenueData];
    }
}
@end
