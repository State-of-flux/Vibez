//
//  TicketsFetchedTableViewController.m
//  Vibez
//
//  Created by Harry Liddell on 07/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketsFetchedTableViewController.h"
#import "NSString+PIK.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Reachability/Reachability.h>

@interface TicketsFetchedTableViewController () <SQKManagedObjectControllerDelegate>
{
    PFUser* user;
    Reachability *reachability;
}
@end

@implementation TicketsFetchedTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithContext:[PIKContextManager mainContext] searchingEnabled:YES style:UITableViewStylePlain];
    
    if (self)
    {
        [self.view setBackgroundColor:[UIColor pku_blackColor]];
        
        self.tableView.tableFooterView = [[UIView alloc] init];
        reachability = [Reachability reachabilityForInternetConnection];
        
        [self.tableView setEmptyDataSetDelegate:self];
        [self.tableView setEmptyDataSetSource:self];
    }
    
    return self;
}

//-(NSSet *)findAllIndividualEvents
//{
//    NSArray *states = [self.controller.managedObjects valueForKey:@"objectId"];
//    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:states];
//    NSSet *uniqueTickets = [orderedSet set];
//
//    return uniqueTickets;
//}
//
//- (NSArray *)arrangeDuplicatesForTicket:(Ticket *)ticket
//{
//    NSMutableArray *arrayOfMultipleTickets = [NSMutableArray array];
//
//    for(Ticket *otherTicket in self.controller.managedObjects)
//    {
//        if([otherTicket.eventID isEqualToString:ticket.eventID])
//        {
//            [arrayOfMultipleTickets addObject:otherTicket];
//        }
//    }
//
//    return [arrayOfMultipleTickets copy];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedTicketSent:)
                                                 name:@"Ticket Sent To Friend"
                                               object:nil];
    
    [self setNavBar:@"Tickets"];
    
    [self.tableView registerClass:[TicketTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([TicketTableViewCell class])];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)setNavBar:(NSString*)titleText
{
    self.navigationItem.title = titleText;
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
            
            [self reloadFetchedResultsControllers];
            
            NSError *errorFetch;
            
            [weakSelf.refreshControl endRefreshing];
            
            if(error)
            {
                NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
            }
            
            if(errorFetch)
            {
                NSLog(@"Fetch Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
            }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    TicketTableViewCell* cell = (TicketTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketTableViewCell class])];
    
    if (cell == nil) {
        cell = [[TicketTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:NSStringFromClass([TicketTableViewCell class])];
    }
    
    [self fetchedResultsController:[self activeFetchedResultsController]
                     configureCell:cell
                       atIndexPath:theIndexPath];
    
    return cell;
}

#pragma mark - Fetch Request Search

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    request = [Ticket sqk_fetchRequest]; //Create ticket additions
    
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"eventDate" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES] ];
    
    NSMutableSet *subpredicates = [NSMutableSet set];
    
    if (searchString.length)
    {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"eventName CONTAINS[cd] %@", searchString]];
    }
    
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"eventDate >= %@", [NSDate date]]];
    
    
    [request setPredicate:[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates.allObjects]];
    
    return request;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   configureCell:(UITableViewCell *)cell
                     atIndexPath:(NSIndexPath *)indexPath
{
    TicketTableViewCell *ticketCell = (TicketTableViewCell *)cell;
    Ticket *ticket = [fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDate *date = [ticket eventDate];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:date]];
    
    [dateFormatString insertString:[NSString daySuffixForDate:date] atIndex:6];
    
    ticketCell.ticketNameLabel.text = ticket.eventName;
    ticketCell.ticketDateLabel.text = dateFormatString;
    [ticketCell setBackgroundColor:[UIColor pku_lightBlack]];
    
    if(ticket.image)
    {
        [ticketCell.ticketImage sd_setImageWithURL:[NSURL URLWithString:ticket.image]
                                  placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if(error)
             {
                 NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
             }
         }];
    }
}

-(void)receivedTicketSent:(id)sender
{
    //[self.controller.managedObjectContext deleteObject:self.ticketSelected];
    //[self.fetchedResultsController.managedObjectContext deleteObject:self.ticketSelected];
    //[self.controller performFetch:nil];
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ticket *ticket = [self.activeFetchedResultsController objectAtIndexPath:indexPath];;
    [self setTicketSelected:ticket];
    self.indexPathSelected = indexPath;
    [self.parentViewController performSegueWithIdentifier:@"showTicketToDisplayTicketSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
