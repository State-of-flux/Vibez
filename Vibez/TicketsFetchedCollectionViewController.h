//
//  TicketsFetchedCollectionViewController.h
//  Vibez
//
//  Created by Harry Liddell on 28/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedCollectionViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "PIKContextManager.h"
#import "Ticket+Additions.h"
#import "TicketCollectionViewCell.h"

@interface TicketsFetchedCollectionViewController : SQKFetchedCollectionViewController <SQKManagedObjectControllerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) PIKContextManager *contextManager;
@property (nonatomic, strong) NSIndexPath *indexPathSelected;
@property (nonatomic, strong) Ticket *ticketSelected;
//@property (nonatomic, strong)

@end
