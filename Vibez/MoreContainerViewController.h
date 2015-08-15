//
//  MoreContainerViewController.h
//  Vibez
//
//  Created by Harry Liddell on 14/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MoreContainerViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *accountData;
@property (strong, nonatomic) NSArray *filterData;
@property (strong, nonatomic) NSArray *controlData;


@end
