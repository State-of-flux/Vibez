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
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventInfoViewController.h"

@interface FetchedCollectionViewContainerViewController () <SQKManagedObjectControllerDelegate>

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
        
        NSFetchRequest *request = [Event sqk_fetchRequest];
        request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES] ];
        request.
        //request.fetchBatchSize = 25;
        
        self.controller =
        [[SQKManagedObjectController alloc] initWithFetchRequest:request
                                            managedObjectContext:[PIKContextManager mainContext]];
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

    //self.showsSectionsWhenSearching = NO;
    
    self.controller.delegate = self;
    [self.controller performFetch:nil];
    
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
    
    [self setIndexPathEventSelected:indexPath];
    [self.parentViewController performSegueWithIdentifier:@"eventToEventInfoSegue" sender:self];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"eventToEventInfoSegue"])
//    {
//        EventInfoViewController *destinationVC = segue.destinationViewController;
//        destinationVC.imageSelected = self.imageSelected;
//    }
}

#pragma mark - Fetched Request

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    request = [Event sqk_fetchRequest]; //Create ticket additions
    
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

#pragma mark - UICollectionView Delegates

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
    
    //NSArray *eventData = [[PIKContextManager mainContext] executeFetchRequest:[Event sqk_fetchRequest] error:nil];
    
    Event *event = [self.controller.managedObjects objectAtIndex:indexPath.row];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
    
    [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
    
    eventCell.eventNameLabel.text = event.name;
    eventCell.eventDateLabel.text = dateFormatString;
    
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [eventCell.eventImage sd_setImageWithURL:[NSURL URLWithString:event.image]
                        placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    return eventCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.controller.managedObjects count];
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
