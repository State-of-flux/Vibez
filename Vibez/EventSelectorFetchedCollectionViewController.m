//
//  EventSelectorFetchedCollectionViewController.m
//  Vibez
//
//  Created by Harry Liddell on 06/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventSelectorFetchedCollectionViewController.h"
#import <Reachability/Reachability.h>
#import "NSString+PIK.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EventSelectorFetchedCollectionViewController ()
{
    Reachability *reachability;
}
@end

@implementation EventSelectorFetchedCollectionViewController

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
    
    
    
    [self.collectionView registerClass:[EventSelectorCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EventSelectorCollectionViewCell class])];
    
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
        
        [Event getEventsFromParseForAdmin:[PFUser currentUser] withSuccessBlock:^(NSArray *objects) {
            NSError *error;
            
            NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
            [Event importEvents:objects intoContext:newPrivateContext];
            [Event deleteInvalidEventsInContext:newPrivateContext];
            [newPrivateContext save:&error];
            
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
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Fetching data...";
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self setEventSelected:event];
    self.indexPathSelected = indexPath;
    
    PFObject *eventObject = [PFObject objectWithoutDataWithClassName:@"Event" objectId:event.eventID];
    
    [Ticket getTicketsForEvent:eventObject fromParseWithSuccessBlock:^(NSArray *objects)
     {
         NSError *error;
         
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Ticket importTickets:objects intoContext:newPrivateContext];
         [Ticket deleteInvalidTicketsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
         
         [self.hud setHidden:YES];
         [self.view setUserInteractionEnabled:YES];
         [Event setEventIdForAdmin:event.eventID withName:event.name];
         [self.navigationController.navigationBar setUserInteractionEnabled:NO];
         [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
     }
                  failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A problem occured while trying to fetch the data, please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
         [alertView show];
         [self.hud setHidden:YES];
         [self.navigationController.navigationBar setUserInteractionEnabled:NO];
         [self.view setUserInteractionEnabled:YES];
     }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventSelectorCollectionViewCell* cell = (EventSelectorCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EventSelectorCollectionViewCell class]) forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[EventSelectorCollectionViewCell alloc] init];
    }
    
    [self fetchedResultsController:[self fetchedResultsController]
                 configureItemCell:cell
                       atIndexPath:indexPath];
    
    return cell;
}

-(void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureItemCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    EventSelectorCollectionViewCell *ticketCell = (EventSelectorCollectionViewCell *)cell;
    Event *event = [fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDate *date = [event startDate];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:date]];
    
    [dateFormatString insertString:[NSString daySuffixForDate:date] atIndex:6];
    
    ticketCell.ticketNameLabel.text = event.name;
    ticketCell.ticketDateLabel.text = dateFormatString;
    [ticketCell setBackgroundColor:[UIColor pku_lightBlack]];
    
    [ticketCell.ticketImage sd_setImageWithURL:[NSURL URLWithString:event.image]
                              placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
     }];
    
}

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    request = [Event sqk_fetchRequest]; //Create ticket additions
    
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSMutableSet *subpredicates = [NSMutableSet set];
    
    if (searchString.length)
    {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString]];
    }
    
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"startDate >= %@", [NSDate date]]];
    
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
    NSString *text = @"No tickets found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"You currently have no tickets, get tickets from the Find tab and feel the Vibes.";
    
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
