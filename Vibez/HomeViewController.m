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

//FAKFontAwesome *starIcon = [FAKFontAwesome starIconWithSize:15];

@implementation HomeViewController

#pragma mark - General Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopBarButtons];
    
    eventReuseIdentifier = @"EventCell";
    venueReuseIdentifier = @"VenueCell";
    
    //[self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:self.eventDataSource.d];
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

-(void)SwapCollectionViewOut
{
    //NSArray *newData = [[NSArray alloc] initWithObjects:@"otherData", nil];
    
    [self.collectionView performBatchUpdates:^
     {
         //[self.collectionView deleteItemsAtIndexPaths:itemsToRemove];
         //[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:indexPath.section]]];
         //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
         
         //int resultsSize = [self.data count]; //data is the previous array of data
         //[self.data addObjectsFromArray:newData];
         //NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
         
         //for (int i = resultsSize; i < resultsSize + newData.count; i++) {
         //    [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i
         //                                                      inSection:0]];
         //}
         //[self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
     } completion:nil];
}

//-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray *)itemPaths
//{
//    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
//    
//    for (NSIndexPath *itemPath  in itemPaths)
//    {
//        [indexSet addIndex:itemPath.row];
//    }
//    
//    [self.apps removeObjectsAtIndexes:indexSet];
//}
//
//-(void)insertItems:(NSArray*)items ToDataSourceAtIndexPaths:(NSArray  *)itemPaths
//{
//    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
//    
//    for (NSIndexPath *itemPath  in itemPaths)
//    {
//        [indexSet addIndex:itemPath.row];
//    }
//    
//    [self.apps insertObjects:items atIndexes:indexSet];
//}
//
//-(void)reloadDataSmooth
//{
//    [self.collectionView performBatchUpdates:^
//    {
//        NSMutableArray *arrayWithIndexPathsDelete = [NSMutableArray array];
//        NSMutableArray *arrayWithIndexPathsInsert = [NSMutableArray array];
//        
//        int itemCount = [self.items count];
//        
//        for (int d = 0; d<itemCount; d++)
//        {
//            [arrayWithIndexPathsDelete addObject:[NSIndexPath indexPathForRow:d inSection:0]];
//        }
//        
//        [self deleteItemsFromDataSourceAtIndexPaths:arrayWithIndexPathsDelete];
//        [self.collectionView deleteItemsAtIndexPaths:arrayWithIndexPathsDelete];
//        
//        int newItemCount = [newItems count];
//        
//        for (int i=0; i < newAppCount; i++)
//        {
//            [arrayWithIndexPathsInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        }
//        
//        [self insertItems:newItems ToDataSourceAtIndexPaths:arrayWithIndexPathsInsert];
//        
//        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPathsInsert];
//    }
//                                  completion:nil];
//}

//-(void)RefreshData:(UISwipeGestureRecognizer *)downGesture
//{
//    
//}

@end
