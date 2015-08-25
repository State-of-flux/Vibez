//
//  TicketsFetchedTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 07/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedTableViewController.h"
#import "PIKContextManager.h"
#import "Ticket+Additions.h"
#import "TicketTableViewCell.h"
#import <UIScrollView+EmptyDataSet.h>

@interface TicketsFetchedTableViewController : SQKFetchedTableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) PIKContextManager *contextManager;
@property (nonatomic, strong) SQKManagedObjectController *controller;
@property (nonatomic, strong) NSIndexPath *indexPathSelected;
@property (nonatomic, strong) Ticket *ticketSelected;

- (void)refresh:(id)sender;

@end
