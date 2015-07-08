//
//  TicketsFetchedTableViewController.m
//  Vibez
//
//  Created by Harry Liddell on 07/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketsFetchedTableViewController.h"
#import "NSString+PIK.h"
#import "UIFont+PIK.h"

@interface TicketsFetchedTableViewController () <SQKManagedObjectControllerDelegate>
{
    PFUser* user;
}
@end

@implementation TicketsFetchedTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithContext:[PIKContextManager mainContext] searchingEnabled:YES style:UITableViewStylePlain];
    
    if (self)
    {
        self.view.backgroundColor = [UIColor pku_blackColor];
        
        NSFetchRequest *request = [Event sqk_fetchRequest];
        request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO] ];
        
        self.controller =
        [[SQKManagedObjectController alloc] initWithFetchRequest:request
                                            managedObjectContext:[PIKContextManager mainContext]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[TicketTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([TicketTableViewCell class])];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.controller.delegate = self;
    [self.controller performFetch:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    user = [PFUser currentUser];
    self.navigationItem.titleView = [self setNavBar:user.username];

}

-(UIView*)setNavBar:(NSString*)titleText
{
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[titleText stringByAppendingString:@"'s Tickets"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont pik_montserratRegWithSize:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    return titleLabel;
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
     }];}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fetchedResultsController:self.fetchedResultsController
                     configureCell:cell
                       atIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    TicketTableViewCell* cell = (TicketTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketTableViewCell class]) forIndexPath:theIndexPath];
    
    [self configureCell:cell atIndexPath:theIndexPath];
    
    return cell;
}

#pragma mark - Fetch Request Search

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

- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                   configureCell:(UITableViewCell *)cell
                     atIndexPath:(NSIndexPath *)indexPath
{
    TicketTableViewCell *itemCell = (TicketTableViewCell *)cell;
    Event *venue = [fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    Event *event = [self.controller.managedObjects objectAtIndex:indexPath.row];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
    [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
    
    cell.ticketNameLabel.text = event.name;
    cell.ticketDateLabel.text = dateFormatString;
    cell.ticketVenueLabel.text = event.name;
}

@end
