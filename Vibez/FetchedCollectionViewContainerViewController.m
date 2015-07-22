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
    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:eventCellIdentifier];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
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

    [self.parentViewController performSegueWithIdentifier:@"eventToEventInfoSegue" sender:self];
}

#pragma mark - Fetched Request

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request = [Event sqk_fetchRequest];
    
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
    //[self.collectionView setDataSource:self.eventDataSource];
    //[self.collectionView reloadData];
}

-(void)SwapCellsToVenueData
{
    self.isEventDataDisplayed = false;
    //[self.collectionView setDataSource:self.venueDataSource];
    //[self.collectionView reloadData];
}

#pragma mark - UICollectionView Delegates

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
    
    NSArray *eventData = [[PIKContextManager mainContext] executeFetchRequest:[Event sqk_fetchRequest] error:nil];
    
    Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
    
    [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
    
    eventCell.eventNameLabel.text = event.name;
    eventCell.eventDateLabel.text = dateFormatString;
    
    return eventCell;
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

#pragma mark - Collection View Flow Layout

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
