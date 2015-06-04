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
    
    NSMutableArray* allData = [[NSMutableArray alloc] initWithArray:[self getData]];
    
    NSMutableArray* artistNames = [[NSMutableArray alloc] initWithArray:[allData objectAtIndex:0]];
    NSMutableArray* artistDates = [[NSMutableArray alloc] initWithArray:[allData objectAtIndex:1]];
    
    cell.eventNameLabel.text = [artistNames objectAtIndex:indexPath.row];
    cell.eventDateLabel.text = [artistDates objectAtIndex:indexPath.row];
    
    //cell.eventPictureImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plug.jpg"]];
    //cell.eventPictureImage = [[UIImageView alloc] initWithImage:[self filledImageFrom:[UIImage imageNamed:@"plug.jpg"] withColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]]];
    //cell.backgroundView = cell.eventPictureImage;
    
    return cell;
}

-(UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
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
