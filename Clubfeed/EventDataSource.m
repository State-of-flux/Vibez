//
//  EventDataSource.m
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//


#import "EventDataSource.h"
#import "Event.h"
#import "EventCollectionViewCell.h"
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import "NSString+PIK.h"
#import "SQKFetchedCollectionViewController.h"

@implementation EventDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
    
//    NSArray *eventData = [[PIKContextManager mainContext] executeFetchRequest:[Event sqk_fetchRequest] error:nil];
//
//    Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEE dd MMM"];
//    
//    NSMutableString* dateFormatString = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:event.startDate]];
//    
//    [dateFormatString insertString:[NSString daySuffixForDate:event.startDate] atIndex:6];
//    
//    eventCell.eventNameLabel.text = event.name;
//    eventCell.eventDateLabel.text = dateFormatString;
    
    return eventCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //event.venueDescription = @"Updated";
    //[[event managedObjectContext] save:nil];
    //[event saveToParse];
    
    NSLog(@"Cell selected");
    
    //[self performSegueWithIdentifier:@"eventToEventInfoSegue" sender:self];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;//[self.data count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
