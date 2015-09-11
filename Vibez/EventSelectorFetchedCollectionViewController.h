//
//  EventSelectorFetchedCollectionViewController.h
//  Vibez
//
//  Created by Harry Liddell on 06/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedCollectionViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "PIKContextManager.h"
#import "EventSelectorCollectionViewCell.h"
#import "Event+Additions.h"
#import "Ticket+Additions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface EventSelectorFetchedCollectionViewController : SQKFetchedCollectionViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSIndexPath *indexPathSelected;
@property (nonatomic, strong) Event *eventSelected;
@property (strong, nonatomic) MBProgressHUD *hud;

@end
