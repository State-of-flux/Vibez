//
//  WhatsOnViewController.m
//  Vibez
//
//  Created by Harry Liddell on 01/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "WhatsOnViewController.h"

@interface WhatsOnViewController () <UISearchBarDelegate>
{
    PFUser* user;
}
@end

@implementation WhatsOnViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create the magnifying glass button
    _searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
    self.navigationItem.rightBarButtonItem = _searchBarButtonItem;
    
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    
    user = [PFUser currentUser];
    
    self.navigationItem.titleView = [self setTopBarButtons:user.username];
    [self.navigationItem setHidesBackButton:YES];
    
    static NSString *eventCellIdentifier = @"EventCell";
    static NSString *venueCellIdentifier = @"VenueCell";
    
    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:eventCellIdentifier];
    [self.collectionView registerClass:[VenueCollectionViewCell class] forCellWithReuseIdentifier:venueCellIdentifier];
    [self.collectionView setDelegate:self];
    
    self.isEventDataDisplayed = YES;
}

-(UIView*)setTopBarButtons:(NSString*)titleText
{
//    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
//    
//    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
//    
//    UIFont *customFont = [UIFont fontWithName:@"Futura-Medium" size:24.0];
//    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
//    [settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
//    
//    //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
//    
//    //self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
//    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning Received.");
}

-(void)SwapCellsToEventData
{
    self.isEventDataDisplayed = true;
    [self.collectionView setDataSource:self.eventDataSource];
    [self.collectionView reloadData];
}

-(void)SwapCellsToVenueData
{
    self.isEventDataDisplayed = false;
    [self.collectionView setDataSource:self.venueDataSource];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEventDataDisplayed)
    {
        [self performSegueWithIdentifier:@"eventToEventInfoSegue" sender:self];
    }
    else if (!self.isEventDataDisplayed)
    {
        [self performSegueWithIdentifier:@"venueToVenueInfoSegue" sender:self];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"eventToEventInfoSegue"])
    {
    
    }
    else if([segue.identifier isEqualToString:@"venueToVenueInfoSegue"])
    {
        //VenueCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    }
}

- (void)searchButtonTapped:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        _searchButton.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        // remove the search button
        self.navigationItem.rightBarButtonItem = nil;
        // add the search bar (which will start out hidden).
        self.navigationItem.titleView = _searchBar;
        _searchBar.alpha = 0.0;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _searchBar.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [_searchBar becomeFirstResponder];
                         }];
        
    }];
}

#pragma mark UISearchBarDelegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
   
    [UIView animateWithDuration:0.5f animations:^{
        _searchBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.navigationItem.titleView = [self setTopBarButtons:user.username];
        self.navigationItem.rightBarButtonItem = _searchBarButtonItem;
        _searchButton.alpha = 0.0;
        
        // set this *after* adding it back
        [UIView animateWithDuration:0.5f animations:^ {
            _searchButton.alpha = 1.0;
            //_searchBar.text = @"";
        }];
    }];
    
}// called when cancel button pressed

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
