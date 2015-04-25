//
//  VenueCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueCollectionViewCell.h"

@implementation VenueCollectionViewCell

-(void)setModel:(NSString *)venueName venueDescription:(NSString *)venueDescription venueImageData:(NSData *)venueImageData venueLocation:(NSString *)venueLocation
{
    self.venueNameLabel.text = venueName;
    self.venueDescriptionLabel.text = venueDescription;
    self.venueImage = [UIImage imageWithData:venueImageData];
    self.venueCLLocation = [self locationStringToCLLocation:venueLocation];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setBackgroundColor:[UIColor purpleColor]];
    }
    
    return self;
}

-(CLLocation *)locationStringToCLLocation:(NSString *)venueLocation
{
    NSString* latitudeString;
    NSString* longitudeString;
    int increment = 0;
    
    NSArray *lines = [venueLocation componentsSeparatedByString:@" "];
    
    for (NSString *line in lines)
    {
        if(increment == 1)
        {
            latitudeString = line;
        }
        if(increment == 3)
        {
            longitudeString = line;
        }
        
        increment++;
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitudeString floatValue]
                                                      longitude:[longitudeString floatValue]];
    
    return location;
}

@end
