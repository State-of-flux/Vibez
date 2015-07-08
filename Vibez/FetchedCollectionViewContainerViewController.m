//
//  VenuesCollectionViewController.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "FetchedCollectionViewContainerViewController.h"
#import "UIColor+Piktu.h"
#import "NSString+PIK.h"

@interface FetchedCollectionViewContainerViewController ()

@end

@implementation FetchedCollectionViewContainerViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]
                                       context:[PIKContextManager mainContext]
                              searchingEnabled:YES];
    
    if (self)
    {
        self.view.backgroundColor = [UIColor pku_blackColor];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    static NSString *eventCellIdentifier = @"eventCell";
    static NSString *venueCellIdentifier = @"venueCell";
    
    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:eventCellIdentifier];
    [self.collectionView registerClass:[VenueCollectionViewCell class] forCellWithReuseIdentifier:venueCellIdentifier];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self.eventDataSource];
    
    //NSArray *eventData = [[PIKContextManager mainContext] executeFetchRequest:[Event sqk_fetchRequest] error:nil];
    //NSArray *venueData = [[PIKContextManager mainContext] executeFetchRequest:[Venue sqk_fetchRequest] error:nil];
    
    self.isEventDataDisplayed = YES;
    self.showsSectionsWhenSearching = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    __weak typeof(self) weakSelf = self;
    
    [Venue getAllFromParseWithSuccessBlock:^(NSArray *objects)
    {
        NSError *error;
        
        NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
        [Venue importVenues:objects intoContext:newPrivateContext];
        [Venue deleteInvalidVenuesInContext:newPrivateContext];
        [newPrivateContext save:&error];
        
        [weakSelf.refreshControl endRefreshing];
        
        if(error)
        {
            NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
        }
    }
    failureBlock:^(NSError *error)
    {
        NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
        [weakSelf.refreshControl endRefreshing];
    }];
    
    [Event getAllFromParseWithSuccessBlock:^(NSArray *objects)
    {
         NSError *error;
         
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Event importEvents:objects intoContext:newPrivateContext];
         [Event deleteInvalidEventsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         [weakSelf.refreshControl endRefreshing];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
     }
                              failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         [weakSelf.refreshControl endRefreshing];
     }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Venue *venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //venue.venueDescription = @"Updated";
    //[[venue managedObjectContext] save:nil];
    //[venue saveToParse];
    
    //NSLog(@"Name : %@", venue.name);
    
    //[self performSegueWithIdentifier:@"venueToVenueInfoSegue" sender:self];
    
    if(self.isEventDataDisplayed)
    {
        //[self performSegueWithIdentifier:@"eventToEventInfoSegue" sender:self];
    }
    else
    {
        //[self performSegueWithIdentifier:@"venueToVenueInfoSegue" sender:self];
    }
}

#pragma mark - Fetched Request

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    if(self.isEventDataDisplayed)
    {
        request = [Event sqk_fetchRequest];
    }
    else
    {
        request = [Venue sqk_fetchRequest];
    }
    
    request = [Event sqk_fetchRequest];
    
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    request.fetchBatchSize = 10;
    NSPredicate *filterPredicate = nil;
    if (searchString.length)
    {
        filterPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString];
    }
    
    [request setPredicate:filterPredicate];
    
    return request;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureItemCell:(UICollectionViewCell *)theItemCell atIndexPath:(NSIndexPath *)indexPath
{
    //VenueCollectionViewCell *itemCell = (VenueCollectionViewCell *)theItemCell;
    //Venue *venue = [fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self fetchedResultsController:self.fetchedResultsController
                 configureItemCell:cell
                       atIndexPath:indexPath];
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

#pragma mark - Collection View Flow Layout

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEventDataDisplayed)
    {
        EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
        
        Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE dd MMM"];
        
        NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
        
        [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
        
        eventCell.eventNameLabel.text = event.name;
        eventCell.eventDateLabel.text = dateFormatString;
        
        return eventCell;
    }
    else
    {
        VenueCollectionViewCell *venueCell = (VenueCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"venueCell" forIndexPath:indexPath];
        
        Venue *venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        venueCell.venueNameLabel.text = venue.name;
        NSString *uppercase = [venueCell.venueNameLabel.text uppercaseString];
        venueCell.venueNameLabel.text =  uppercase;
        venueCell.venueLocationLabel.text = venue.location;
        
        return venueCell;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}


@end
