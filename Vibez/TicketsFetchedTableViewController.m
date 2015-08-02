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
    self = [super initWithContext:[PIKContextManager mainContext] searchingEnabled:NO style:UITableViewStylePlain];
    
    if (self)
    {
        self.view.backgroundColor = [UIColor pku_blackColor];
        
        reachability = [Reachability reachabilityForInternetConnection];
        
        NSFetchRequest *request = [Event sqk_fetchRequest];
        request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES] ];
        
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
    
    self.controller.delegate = self;
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
    TicketTableViewCell* cell = (TicketTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketTableViewCell class]) forIndexPath:theIndexPath];
    
    if (cell == nil) {
        cell = [[TicketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TicketTableViewCell class])];
    }
    
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
    //TicketTableViewCell *itemCell = (TicketTableViewCell *)cell;
    //Event *venue = [fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    Event *event = [self.controller.managedObjects objectAtIndex:indexPath.row];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMM"];
    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
    [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
    
    cell.ticketNameLabel.text = event.name;
    cell.ticketDateLabel.text = dateFormatString;
    
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [cell.ticketImage sd_setImageWithURL:[NSURL URLWithString:event.image]
                        placeholderImage:[UIImage imageNamed:@"plug.jpg"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    //    if(cell.ticketImage.image == nil)
    //    {
    //        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:event.image]];
    //        [NSURLConnection sendAsynchronousRequest:request
    //                                           queue:[NSOperationQueue mainQueue]
    //                               completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
    //         {
    //             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //             if (data) {
    //
    //                 dispatch_async(dispatch_get_main_queue(), ^{
    //                     cell.ticketImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
    //                 });
    //
    //
    //                 //cell.ticketImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plug.jpg"]];
    //             }
    //         }];
    //    }
}

@end
