//
//  TicketsFetchedTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 07/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "SQKFetchedTableViewController.h"
#import "PIKContextManager.h"
#import "UIColor+Piktu.h"
#import "TicketTableViewCell.h"

@interface TicketsFetchedTableViewController : SQKFetchedTableViewController

@property (nonatomic, strong) PIKContextManager *contextManager;
@property (nonatomic, strong) SQKManagedObjectController *controller;

@end
