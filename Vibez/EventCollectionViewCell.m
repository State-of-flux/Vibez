//
//  EventCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventCollectionViewCell.h"
#import "UIFont+PIK.h"

@implementation EventCollectionViewCell

-(void)setModel:(NSString *)eventName eventDescription:(NSString *)eventDescription eventGenres:(NSString *)eventGenres eventVenueName:(NSString *)eventVenueName eventDate:(NSString *)eventDate eventImageData:(NSData *)eventImageData eventLocation:(NSString *)eventLocation
{
    self.eventNameLabel.text = eventName;
    self.eventDescriptionLabel.text = eventDescription;
    self.eventGenresLabel.text = eventGenres;
    self.eventDateLabel.text = eventDate;
    self.eventImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:eventImageData]];
    self.eventCLLocation = [self locationStringToCLLocation:eventLocation];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        //[self setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
        self.layer.borderColor = [UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:0.8f].CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 30.0f, self.frame.size.width - 5, 25)];
        [self.eventNameLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:20.0f];
        self.eventNameLabel.textColor = [UIColor whiteColor];
        
        self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2, self.frame.size.width - 5, 25)];
        [self.eventDateLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
        self.eventDateLabel.textColor = [UIColor whiteColor];
    
        self.eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7f];
        [self.contentView addSubview:self.eventImage];
        [self.contentView addSubview:darkOverlay];
        [self.contentView addSubview:self.eventNameLabel];
        [self.contentView addSubview:self.eventDateLabel];
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
