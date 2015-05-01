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
    
    //NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:[self.eventDataSource.data count]];
}

-(void)setTopBarButtons
{
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
    
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

- (IBAction)segmentedControlTapped:(id)sender
{
    if([sender selectedSegmentIndex] == 0)
    {
        [self SwapCellsToEventData];
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        [self SwapCellsToVenueData];
    }
}
@end
