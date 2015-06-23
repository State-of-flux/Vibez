//
//  VenuesCollectionViewController.m
//  Vibez
//
//  Created by Harry Liddell on 22/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "FetchedCollectionViewContainerViewController.h"
#import "PIKContextManager.h"
#import "VenueCollectionViewCell.h"

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
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[VenueCollectionViewCell class] forCellWithReuseIdentifier:@"venueCell"];
    
    NSArray *test = [[PIKContextManager mainContext] executeFetchRequest:[Venue sqk_fetchRequest] error:nil];
    
    self.showsSectionsWhenSearching = NO;
}

#pragma mark -

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request = [Venue sqk_fetchRequest];
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
    VenueCollectionViewCell *itemCell = (VenueCollectionViewCell *)theItemCell;
    Venue *venue = [fetchedResultsController objectAtIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCollectionViewCell *cell = (VenueCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"venueCell" forIndexPath:indexPath];
    
    Venue *venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    cell.venueNameLabel.text = venue.name;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:venue.image]];

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self fetchedResultsController:self.fetchedResultsController
                 configureItemCell:cell
                       atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    venue.venueDescription = @"Updated";
    [[venue managedObjectContext] save:nil];
    [venue saveToParse];
    
    NSLog(@"Name : %@", venue.name);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/2;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

@end
