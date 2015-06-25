//
//  TicketsTabViewController.h
//  Vibez
//
//  Created by Harry Liddell on 31/05/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "TicketDataSource.h"

@interface TicketsTabViewController : GlobalViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet TicketDataSource *ticketDataSource;

@end
