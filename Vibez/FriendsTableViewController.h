//
//  FriendsTableViewController.h
//  Vibez
//
//  Created by Harry Liddell on 16/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *sections;

@end
