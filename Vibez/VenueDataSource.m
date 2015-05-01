//
//  VenueDataSource.m
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueDataSource.h"
#import "VenueCollectionViewCell.h"

@implementation VenueDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;//[self.data count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
