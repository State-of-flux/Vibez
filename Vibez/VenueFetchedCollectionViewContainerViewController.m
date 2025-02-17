//
//  VenueFetchedCollectionViewContainerViewController.m
//  Vibez
//
//  Created by Harry Liddell on 21/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueFetchedCollectionViewContainerViewController.h"
#import "VenueCollectionViewCell.h"
#import "UIColor+Piktu.h"
#import "UIFont+PIK.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Reachability/Reachability.h>

@interface VenueFetchedCollectionViewContainerViewController () <SQKManagedObjectControllerDelegate>
{
    Reachability *reachability;
    BOOL isRefreshing;
}
@end

@implementation VenueFetchedCollectionViewContainerViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    self = [super initWithCollectionViewLayout:flowLayout
                                       context:[PIKContextManager mainContext]
                              searchingEnabled:YES];
    
    if (self) {
        self.view.backgroundColor = [UIColor pku_lightBlack];
        reachability = [Reachability reachabilityForInternetConnection];
        [self.collectionView registerClass:[VenueCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([VenueCollectionViewCell class])];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setAlwaysBounceVertical:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedNotification:)
                                                     name:@"appDidBecomeActive"
                                                   object:nil];
    }
    
    return self;
}

- (void)receivedNotification:(NSNotification *)notification {
    if([[notification name] isEqualToString:@"appDidBecomeActive"]) {
        [self refresh:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchBarAppearance];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView setEmptyDataSetSource:self];
    [self.collectionView setEmptyDataSetDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!isRefreshing) {
        [self refresh:nil];
    }
}

- (void)setSearchBarAppearance {
    [self.searchBar setPlaceholder:@"Search for venues"];
    [self.searchBar setBarTintColor:[UIColor pku_lightBlack]];
    [self.searchBar setTintColor:[UIColor pku_purpleColor]];
    [self.searchBar setTranslucent:NO];
    [self.searchBar setBackgroundColor:[UIColor pku_blackColor]];
    [self.searchBar setBarStyle:UIBarStyleBlack];
    [self.searchBar setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.searchBar setTintColor:[UIColor whiteColor]];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)refresh:(id)sender
{
    isRefreshing = YES;
    
    __weak typeof(self) weakSelf = self;
    
    if([reachability isReachable])
    {
        [Venue getAllFromParseWithSuccessBlock:^(NSArray *objects)
         {
             NSError *error;
             
             NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
             [Venue importVenues:objects intoContext:newPrivateContext];
             [Venue deleteInvalidVenuesInContext:newPrivateContext];
             [newPrivateContext save:&error];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[self collectionView] reloadData];
                 [[self collectionView] reloadEmptyDataSet];
             });
             
             if(error)
             {
                 NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
             }
             
             [weakSelf.refreshControl endRefreshing];
             isRefreshing = NO;
         }
                                  failureBlock:^(NSError *error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
             [weakSelf.refreshControl endRefreshing];
             isRefreshing = NO;
         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert setTintColor:[UIColor pku_purpleColor]];
        [alert show];
        [weakSelf.refreshControl endRefreshing];
        isRefreshing = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Venue *venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //venue.venueDescription = @"Updated";
    //[[venue managedObjectContext] save:nil];
    //[venue saveToParse];
    
    Venue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self setVenue:venue];
    [self.parentViewController performSegueWithIdentifier:@"venueToVenueInfoSegue" sender:self];
}

#pragma mark - Fetched Request

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    request = [Venue sqk_fetchRequest]; //Create ticket additions
    
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"town" ascending:YES]];
    
    NSMutableSet *subpredicates = [NSMutableSet set];
    
    if (searchString.length)
    {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString]];
    }
    
    //[subpredicates addObject:[NSPredicate predicateWithFormat:@"town >= %@", [NSDate date]]];
    
    
    [request setPredicate:[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates.allObjects]];
    
    return request;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureItemCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    VenueCollectionViewCell *venueCell = (VenueCollectionViewCell *)cell;
    Venue *venue = [fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([venue name]) {
        [[venueCell venueNameLabel] setText:[venue name]];
    }
    
    if ([venue town]) {
        [[venueCell venueTownLabel] setText:[venue town]];
    }
    
    if ([venueCell venueImage]) {
        [[venueCell venueImage] sd_setImageWithURL:[NSURL URLWithString:[venue image]]
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if(error) {
                 NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
             }
         }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self fetchedResultsController:self.fetchedResultsController
                 configureItemCell:cell
                       atIndexPath:indexPath];
}

#pragma mark - UICollectionView Delegates

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCollectionViewCell* cell = (VenueCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VenueCollectionViewCell class]) forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[VenueCollectionViewCell alloc] init];
    }
    
    [self fetchedResultsController:[self fetchedResultsController]
                 configureItemCell:cell
                       atIndexPath:indexPath];
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

#pragma mark - DZN Empty Data Set Delegates

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;//[UIImage imageNamed:@"plug.jpg"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No venues found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"There are no venues in your current location, try again later or change your location.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_avenirNextRegWithSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor pku_greyColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self refresh:self];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self refresh:self];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:16.0f], NSForegroundColorAttributeName : [UIColor pku_purpleColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"TAP TO REFRESH", @"TAP TO REFRESH") attributes:attributes];
}

#pragma mark - Collection View Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self collectionView] setEmptyDataSetSource:nil];
    [[self collectionView] setEmptyDataSetDelegate:nil];
}

@end
