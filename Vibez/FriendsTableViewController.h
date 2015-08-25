//
//  FriendsTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 16/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>
#import <Parse/Parse.h>

@interface FriendsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableDictionary *sections;
@property (nonatomic, strong) PFUser *currentUser;

@end
