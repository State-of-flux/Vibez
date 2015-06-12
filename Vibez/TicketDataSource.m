//
//  TicketDataSource.m
//  Vibez
//
//  Created by Harry Liddell on 12/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketDataSource.h"
#import "TicketTableViewCell.h"
#import "UIColor+Piktu.h"

@implementation TicketDataSource


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TicketCell" forIndexPath:indexPath];
    
    NSMutableArray* allData = [[NSMutableArray alloc] initWithArray:[self getData]];
    
    NSMutableArray* artistNames = [[NSMutableArray alloc] initWithArray:[allData objectAtIndex:0]];
    NSMutableArray* artistDates = [[NSMutableArray alloc] initWithArray:[allData objectAtIndex:1]];
    
    cell.ticketNameLabel.text = [artistNames objectAtIndex:indexPath.row];
    cell.ticketVenueLabel.text = [artistDates objectAtIndex:indexPath.row];
    cell.ticketDateLabel.text = [artistDates objectAtIndex:indexPath.row];
    cell.ticketImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plug.jpg"]];
    cell.contentView.backgroundColor = [UIColor pku_blackColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSMutableArray *)getData
{
    NSArray* artistNames = [NSArray arrayWithObjects: @"SBTRKT",
                            @"Ella Henderson",
                            @"Daft Punk",
                            @"Caribou",
                            @"Madeon",
                            @"Tchami",
                            @"Gorgon City",
                            nil];
    
    NSArray* artistDates = [NSArray arrayWithObjects: @"Thursday 15th June",
                            @"Friday 16th June",
                            @"Monday 19th June",
                            @"Tuesday 20th June",
                            @"Tuesday 20th June",
                            @"Thursday 22nd June",
                            @"Friday 23rd June",
                            nil];
    
    NSMutableArray* arrayData = [[NSMutableArray alloc] initWithObjects:artistNames, artistDates, nil];
    
    return arrayData;
}

@end
