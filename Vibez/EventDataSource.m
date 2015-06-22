//
//  EventDataSource.m
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Event.h"
#import "EventDataSource.h"
#import "EventCollectionViewCell.h"
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>

@implementation EventDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
    
    //[cell setModel:[self.data objectForKey:@"eventName"] eventDescription:[self.data objectForKey:@"eventDescription"] eventGenres:[self.data objectForKey:@"eventGenres"] eventVenueName:[self.data objectForKey:@"eventVenueName"] eventDate:[self.data objectForKey:@"eventDate"] eventImageData:[self.data objectForKey:@"eventImageData"] eventLocation:[self.data objectForKey:@"eventLocation"]];
    
    //NSMutableArray* allEvents = [[NSMutableArray alloc] initWithArray:[Event getEventsInBackground]];
    //NSMutableArray* event = [[NSMutableArray alloc] initWithArray:[allEvents objectAtIndex:indexPath.row]];
    
    PFQuery* query = [PFQuery queryWithClassName:@"Event"];
    [query fromLocalDatastore];
    [[query getObjectInBackgroundWithId:@"xWMyZ4YEGZ"] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            // something went wrong;
            return task;
        }
        
        
        // task.result will be your game score
        return task;
    }];
    
    //cell.eventNameLabel.text = [event objectAtIndex:0];
    //cell.eventDateLabel.text = [artistDates objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;//[self.data count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSMutableArray *)getData
{
//    NSArray* artistNames = [NSArray arrayWithObjects: @"SBTRKT",
//                        @"Ella Henderson",
//                        @"Daft Punk",
//                        @"Caribou",
//                        @"Madeon",
//                        @"Tchami",
//                        @"Gorgon City",
//                        nil];
//    
//    NSArray* artistDates = [NSArray arrayWithObjects: @"Thursday 15th June",
//                        @"Friday 16th June",
//                        @"Monday 19th June",
//                        @"Tuesday 20th June",
//                        @"Tuesday 20th June",
//                        @"Thursday 22nd June",
//                        @"Friday 23rd June",
//                        nil];
//  
//    NSMutableArray* arrayData = [[NSMutableArray alloc] initWithObjects:artistNames, artistDates, nil];
    //NSMutableArray* arrayData = [Event getEventsInBackground];
    
    return nil;
}

@end
