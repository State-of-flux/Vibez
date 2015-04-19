//
//  HomeViewController.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    NSString* eventReuseIdentifier;// = @"EventCell";
    NSString* venueReuseIdentifier;// = @"VenueCell";
}
@end

@implementation HomeViewController

#pragma mark - General Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    eventReuseIdentifier = @"EventCell";
    venueReuseIdentifier = @"VenueCell";
    
    //FAKFontAwesome *starIcon = [FAKFontAwesome starIconWithSize:15];
    
    [self setTopBarButtons];

}

-(void)setTopBarButtons
{
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning Received.");
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

#pragma mark - UICollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.eventsVenuesSegmentedControl.selectedSegmentIndex == 1)
    {
        EventCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:eventReuseIdentifier forIndexPath:indexPath];
        
        cell = [self displayEvents:collectionView withCell:cell cellForItemAtIndexPath:indexPath];
        
        return cell;
        
    }
    else if(self.eventsVenuesSegmentedControl.selectedSegmentIndex == 2)
    {
        VenueCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:venueReuseIdentifier forIndexPath:indexPath];
        
        cell = [self displayVenues:collectionView withCell:cell cellForItemAtIndexPath:indexPath];
        
        return cell;
    }

    return NULL;
}

-(EventCollectionViewCell *)displayEvents:(UICollectionView *)collectionView withCell:(EventCollectionViewCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return cell;
}

-(VenueCollectionViewCell *)displayVenues:(UICollectionView *)collectionView withCell:(VenueCollectionViewCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
