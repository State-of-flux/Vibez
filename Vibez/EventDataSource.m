//
//  EventDataSource.m
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventDataSource.h"
#import "EventCollectionViewCell.h"

@implementation EventDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //EventCollectionViewCell* cell = [[EventCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    EventCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
    
    //[cell setModel:[self.data objectForKey:@"eventName"] eventDescription:[self.data objectForKey:@"eventDescription"] eventGenres:[self.data objectForKey:@"eventGenres"] eventVenueName:[self.data objectForKey:@"eventVenueName"] eventDate:[self.data objectForKey:@"eventDate"] eventImageData:[self.data objectForKey:@"eventImageData"] eventLocation:[self.data objectForKey:@"eventLocation"]];
    
    cell.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, 25)];
    CGPoint a;
    a.x = cell.frame.size.width/2;
    a.y = cell.frame.size.height/2;
    [cell.eventNameLabel setCenter:a];
    
    cell.eventNameLabel.font = [UIFont fontWithName:@"Avenir Next" size:20];
    cell.eventNameLabel.textColor = [UIColor whiteColor];
    cell.eventNameLabel.text = @"Sbtrkt";
    
    cell.eventVenueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, collectionView.frame.size.width, 25)];
    cell.eventVenueNameLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    cell.eventVenueNameLabel.textColor = [UIColor whiteColor];
    cell.eventVenueNameLabel.text = @"Plug";
    
    cell.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, collectionView.frame.size.width, 25)];
    cell.eventDateLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];
    cell.eventDateLabel.textColor = [UIColor whiteColor];
    cell.eventDateLabel.text = @"21/09/2015";


    
    [cell.contentView addSubview:cell.eventNameLabel];
    [cell.contentView addSubview:cell.eventVenueNameLabel];
    
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
