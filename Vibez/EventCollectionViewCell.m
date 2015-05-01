//
//  EventCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventCollectionViewCell.h"

@implementation EventCollectionViewCell

-(void)setModel:(NSString *)eventName eventDescription:(NSString *)eventDescription eventGenres:(NSString *)eventGenres eventVenueName:(NSString *)eventVenueName eventDate:(NSString *)eventDate eventImageData:(NSData *)eventImageData eventLocation:(NSString *)eventLocation
{
    self.eventNameLabel.text = eventName;
    self.eventDescriptionLabel.text = eventDescription;
    self.eventGenresLabel.text = eventGenres;
    self.eventDateLabel.text = eventDate;
    self.eventPictureImage = [UIImage imageWithData:eventImageData];
    self.eventCLLocation = [self locationStringToCLLocation:eventLocation];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setBackgroundColor:[UIColor blackColor]];
        //self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
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
