//
//  SearchListFetchedCollectionViewController.m
//  Vibez
//
//  Created by Harry Liddell on 04/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SearchListFetchedCollectionViewController.h"
#import "NSString+PIK.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Reachability/Reachability.h>
#import "UserCollectionViewCell.h"

@interface SearchListFetchedCollectionViewController ()
{
    PFUser* user;
    Reachability *reachability;
}
@end

@implementation SearchListFetchedCollectionViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    self = [super initWithCollectionViewLayout:flowLayout
                                       context:[PIKContextManager mainContext]
                              searchingEnabled:YES];
    
    if (self)
    {
        self.view.backgroundColor = [UIColor pku_blackColor];
        reachability = [Reachability reachabilityForInternetConnection];
        [self.collectionView setEmptyDataSetSource:self];
        [self.collectionView setEmptyDataSetDelegate:self];
        [self.collectionView setAlwaysBounceVertical:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Vibes List"];
    
    [self.collectionView registerClass:[UserCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UserCollectionViewCell class])];
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.searchBar setBarTintColor:[UIColor pku_lightBlack]];
    [self.searchBar setTranslucent:NO];
    [self.searchBar setBackgroundColor:[UIColor pku_blackColor]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(id)sender
{
    if([reachability isReachable])
    {
        [self.refreshControl beginRefreshing];
        
        __weak typeof(self) weakSelf = self;
        
        [Ticket getTicketsForUserFromParseWithSuccessBlock:^(NSArray *objects) {
            NSError *error;
            
            NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
            [Ticket importTickets:objects intoContext:newPrivateContext];
            [Ticket deleteInvalidTicketsInContext:newPrivateContext];
            [newPrivateContext save:&error];
            
            [self reloadFetchedResultsControllerForSearch:nil];
            
            if(error)
            {
                NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
            }
            
            [weakSelf.refreshControl endRefreshing];
        }
                                              failureBlock:^(NSError *error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
             [weakSelf.refreshControl endRefreshing];
         }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please connect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UICollectionView Delegates

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];;
    [self setUserSelected:user];
    self.indexPathSelected = indexPath;
    //[self.parentViewController performSegueWithIdentifier:@"" sender:self];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCollectionViewCell* cell = (UserCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UserCollectionViewCell class]) forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UserCollectionViewCell alloc] init];
    }
    
    [self fetchedResultsController:[self fetchedResultsController]
                 configureItemCell:cell
                       atIndexPath:indexPath];
    
    return cell;
}

-(void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureItemCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UserCollectionViewCell *ticketCell = (UserCollectionViewCell *)cell;
    User *user = [fetchedResultsController objectAtIndexPath:indexPath];

    ticketCell.ticketNameLabel.text = user.username;
    [ticketCell setBackgroundColor:[UIColor pku_lightBlack]];
}

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    request = [User sqk_fetchRequest]; //Create ticket additions
    
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES] ];
    
    NSMutableSet *subpredicates = [NSMutableSet set];
    
    if (searchString.length)
    {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"username CONTAINS[cd] %@", searchString]];
        //[subpredicates addObject:[NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@", searchString]];
        //[subpredicates addObject:[NSPredicate predicateWithFormat:@"lastName CONTAINS[cd] %@", searchString]];
    }
    
    //[subpredicates addObject:[NSPredicate predicateWithFormat:@"eventDate >= %@", [NSDate date]]];
    
    [request setPredicate:[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates.allObjects]];
    
    return request;
}

#pragma mark - DZN Empty Data Set Delegates

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No users found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No users exist with that username or name.";
    
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

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self refresh:self];
}

-(void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self refresh:self];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:16.0f], NSForegroundColorAttributeName : [UIColor pku_purpleColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"TAP TO REFRESH", @"TAP TO REFRESH") attributes:attributes];
}
#pragma mark - Collection View Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width;
    CGFloat height = 70;//collectionView.frame.size.height/5.5;
    
    return CGSizeMake(width, height);
}

@end

