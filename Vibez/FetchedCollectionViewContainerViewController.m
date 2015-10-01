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
#import "UIFont+PIK.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventInfoViewController.h"
#import <Reachability/Reachability.h>

@interface FetchedCollectionViewContainerViewController ()
{
    Reachability *reachability;
}
@end

@implementation FetchedCollectionViewContainerViewController

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
        self.view.backgroundColor = [UIColor pku_lightBlack];
        reachability = [Reachability reachabilityForInternetConnection];
        [self.collectionView setEmptyDataSetSource:self];
        [self.collectionView setEmptyDataSetDelegate:self];
        [self.collectionView setAlwaysBounceVertical:YES];
    }
    
    return self;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchBar resignFirstResponder];
}

-(NSDate*)dateNoTime:(NSDate*)myDate
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EventCollectionViewCell class])];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.searchBar setPlaceholder:@"Search for events"];
    [self.searchBar setBarTintColor:[UIColor pku_lightBlack]];
    [self.searchBar setTranslucent:NO];
    [self.searchBar setBackgroundColor:[UIColor pku_blackColor]];
    [self.searchBar setBarStyle:UIBarStyleBlack];
    [self.searchBar setKeyboardAppearance:UIKeyboardAppearanceDark];
    
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
        
        [Event getAllFromParseWithSuccessBlock:^(NSArray *objects)
         {
             NSError *error;
             
             NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
             [Event importEvents:objects intoContext:newPrivateContext];
             [Event deleteInvalidEventsInContext:newPrivateContext];
             [newPrivateContext save:&error];
             
             [self.collectionView reloadData];
             
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self setEvent:event];
    [self.parentViewController performSegueWithIdentifier:@"eventToEventInfoSegue" sender:self];
}

#pragma mark - Fetched Request

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

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureItemCell:(UICollectionViewCell *)theItemCell atIndexPath:(NSIndexPath *)indexPath
{
    EventCollectionViewCell *eventCell = (EventCollectionViewCell *)theItemCell;
    Event *event = [fetchedResultsController objectAtIndexPath:indexPath];
    
//    if (!(indexPath.row % 2 == 0)) {
//        [eventCell.contentView setBackgroundColor:[UIColor redColor]];
//    } else if ((indexPath.row % 2 == 0)) {
//        [eventCell.contentView setBackgroundColor:[UIColor blueColor]];
//    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
    
    [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
    
    [eventCell.eventNameLabel setText:[event name]];
    [eventCell.eventDateLabel setText:dateFormatString];
    
    NSString *eventPriceString;
    
    if([event price] && [event bookingFee]) {
        NSDecimalNumber *overallPrice = [self addNumber:[event price] andOtherNumber:[event bookingFee]];
        eventPriceString = [NSString stringWithFormat:NSLocalizedString(@"£%.2f", @"Price of item"), [overallPrice floatValue]];
    }
    
    if([[event quantity] isEqualToNumber:@0]) {
        eventCell.eventPriceLabel.text = @"SOLD OUT";
        [eventCell.eventPriceLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        [eventCell.eventPriceLabel setTextColor:[UIColor pku_purpleColor]];
        //eventCell.eventPriceLabel.text = eventPriceString; //eventPriceString
        eventCell.eventPriceLabel.text = @""; //eventPriceString
    }
    
    [eventCell.eventPriceLabel sizeToFit];
    [eventCell.eventPriceLabel setCenter:CGPointMake(eventCell.frame.size.width/2, eventCell.frame.size.height - 15.0f)];
    
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [eventCell.eventImage sd_setImageWithURL:[NSURL URLWithString:event.image]
                            placeholderImage:nil
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
}

#pragma mark - UICollectionView Delegates

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventCollectionViewCell* cell = (EventCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EventCollectionViewCell class]) forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[EventCollectionViewCell alloc] init];
    }
    
    [self fetchedResultsController:[self fetchedResultsController]
                 configureItemCell:cell
                       atIndexPath:indexPath];
    
    return cell;
}

-(NSDecimalNumber *)addNumber:(NSDecimalNumber *)num1 andOtherNumber:(NSDecimalNumber *)num2
{
    NSDecimalNumber *added = [[NSDecimalNumber alloc] initWithInt:0];
    return [added decimalNumberByAdding:[num1 decimalNumberByAdding:num2]];
}

#pragma mark - DZN Empty Data Set Delegates

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;//[UIImage imageNamed:@"plug.jpg"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No events found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"There are no events occuring in your current location, try again later or change your location.";
    
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

@end
