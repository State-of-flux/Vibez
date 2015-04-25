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
    EventCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
    
    //[cell setModel:[self.data objectForKey:@"eventName"] eventDescription:[self.data objectForKey:@"eventDescription"] eventGenres:[self.data objectForKey:@"eventGenres"] eventVenueName:[self.data objectForKey:@"eventVenueName"] eventDate:[self.data objectForKey:@"eventDate"] eventImageData:[self.data objectForKey:@"eventImageData"] eventLocation:[self.data objectForKey:@"eventLocation"]];
    
    
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
