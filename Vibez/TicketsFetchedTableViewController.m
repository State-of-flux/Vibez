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
        
        NSFetchRequest *request = [Ticket sqk_fetchRequest];
        //request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"event" ascending:YES] ];
        
        self.controller =
        [[SQKManagedObjectController alloc] initWithFetchRequest:request
                                            managedObjectContext:[PIKContextManager mainContext]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBar:@"Tickets"];
    
    [self.tableView registerClass:[TicketTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([TicketTableViewCell class])];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.searchController.searchBar setBarTintColor:[UIColor pku_lightBlack]];
    [self.searchController.searchBar setTranslucent:NO];
    [self.searchController.searchBar setBackgroundColor:[UIColor pku_blackColor]];
    [self.searchController.searchBar setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.searchController.searchBar setBarStyle:UIBarStyleBlack];
    
    
    [self.controller setDelegate:self];
    [self.controller performFetch:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
             
             [weakSelf.refreshControl endRefreshing];
             
            if(error)
            {
                NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
            }
          
            [self.tableView reloadData];
            
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fetchedResultsController:self.fetchedResultsController
                     configureCell:cell
                       atIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    TicketTableViewCell* cell = (TicketTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketTableViewCell class])];
    
    if (cell == nil) {
        cell = [[TicketTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:NSStringFromClass([TicketTableViewCell class])];
    }
    
    [self configureCell:cell atIndexPath:theIndexPath];
    
    return cell;
}

#pragma mark - Fetch Request Search

- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString
{
    NSFetchRequest *request;
    
    request = [Ticket sqk_fetchRequest]; //Create ticket additions
    
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES] ];
    //request.fetchBatchSize = 10;
    NSPredicate *filterPredicate = nil;
    
    if (searchString.length)
    {
        filterPredicate = [NSPredicate predicateWithFormat:@"eventName CONTAINS[cd] %@", searchString];
    }
    
    [request setPredicate:filterPredicate];
    
    return request;
}

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   configureCell:(UITableViewCell *)cell
                     atIndexPath:(NSIndexPath *)indexPath
{
    //TicketTableViewCell *itemCell = (TicketTableViewCell *)cell;
    //Event *venue = [fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ticket *ticket = [self.controller.managedObjects objectAtIndex:indexPath.row];
    [self setTicket:ticket];
    [self.parentViewController performSegueWithIdentifier:@"showTicketToDisplayTicketSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.controller.managedObjects count];
}

- (void)configureCell:(UITableViewCell *)theCell
          atIndexPath:(NSIndexPath *)indexPath
{
    TicketTableViewCell *cell = (TicketTableViewCell *)theCell;
    Ticket *ticket = [self.controller.managedObjects objectAtIndex:indexPath.row];
    
    NSDate *date = [ticket eventDate];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:date]];
    
    [dateFormatString insertString:[NSString daySuffixForDate:date] atIndex:6];
    
    cell.ticketNameLabel.text = ticket.eventName;
    cell.ticketDateLabel.text = dateFormatString;
    [cell setBackgroundColor:[UIColor pku_lightBlack]];
    [cell.detailTextLabel setText:@"2x"];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    
    [cell.ticketImage sd_setImageWithURL:[NSURL URLWithString:ticket.image]
                        placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if(error)
         {
            NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
     }];
}

@end
