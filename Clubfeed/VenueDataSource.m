//
//  VenueDataSource.m
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueDataSource.h"
#import "Venue.h"
#import "Venue+Additions.h"
#import "VenueCollectionViewCell.h"

@implementation VenueDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCollectionViewCell *venueCell = (VenueCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"venueCell" forIndexPath:indexPath];
//    
//    Venue *venue = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    
//    venueCell.venueNameLabel.text = venue.name;
//    NSString *uppercase = [venueCell.venueNameLabel.text uppercaseString];
//    venueCell.venueNameLabel.text =  uppercase;
//    venueCell.venueLocationLabel.text = venue.location;
    
    return venueCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;//[self.data count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
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


@end
