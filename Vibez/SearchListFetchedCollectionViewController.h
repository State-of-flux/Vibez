//
//  SearchListFetchedCollectionViewController.h
//  Vibez
//
//  Created by Harry Liddell on 04/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedCollectionViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "PIKContextManager.h"
#import "Ticket+Additions.h"
#import "User+Additions.h"

@interface SearchListFetchedCollectionViewController : SQKFetchedCollectionViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSIndexPath *indexPathSelected;
@property (nonatomic, strong) Ticket *ticketSelected;
@property (nonatomic, strong) PFObject *event;

@end
