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
    
    NSMutableArray* allData = [[NSMutableArray alloc] initWithArray:[self getData]];
    NSMutableArray* artistNames = [[NSMutableArray alloc] initWithArray:[allData objectAtIndex:0]];
    cell.venueNameLabel.text = [artistNames objectAtIndex:indexPath.row];
    
    cell.venueImage = [[UIImageView alloc] initWithImage:[self filledImageFrom:[UIImage imageNamed:@"plug.jpg"] withColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]]];
    
    cell.backgroundView = cell.venueImage;
   
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

-(NSMutableArray *)getData
{
    NSArray* artistNames = [NSArray arrayWithObjects: @"Viper Rooms",
                            @"Plug",
                            @"Fez",
                            @"Tank",
                            @"Leadmill",
                            @"DQ",
                            @"Corporation",
                            nil];
    
//    NSArray* artistDates = [NSArray arrayWithObjects: @"21/09/2015",
//                            @"23/09/2015",
//                            @"25/09/2015",
//                            @"26/09/2015",
//                            @"30/09/2015",
//                            @"01/10/2015",
//                            @"17/11/2015",
//                            nil];
    
    NSMutableArray* arrayData = [[NSMutableArray alloc] initWithObjects:artistNames, nil];
    
    return arrayData;
}


@end
