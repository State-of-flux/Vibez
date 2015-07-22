//
//  VenueCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "VenueCollectionViewCell.h"
#import "UIFont+PIK.h"

@implementation VenueCollectionViewCell

-(void)setModel:(NSString *)venueName venueDescription:(NSString *)venueDescription venueImageData:(NSData *)venueImageData venueLocation:(NSString *)venueLocation
{
    self.venueNameLabel.text = venueName;
    self.venueDescriptionLabel.text = venueDescription;
    self.venueImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:venueImageData]];
    self.venueCLLocation = [self locationStringToCLLocation:venueLocation];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        //[self setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
        self.layer.borderColor = [UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:0.8f].CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.venueNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 30.0f, self.frame.size.width - 5, 25)];
        [self.venueNameLabel setTextAlignment:NSTextAlignmentCenter];
        self.venueNameLabel.font = [UIFont pik_montserratBoldWithSize:20.0f];
        self.venueNameLabel.textColor = [UIColor whiteColor];
        
        
        self.venueLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2, self.frame.size.width - 5, 25)];
        [self.venueLocationLabel setTextAlignment:NSTextAlignmentCenter];
        self.venueLocationLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
        self.venueLocationLabel.textColor = [UIColor whiteColor];
        
        self.venueImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plug.jpg"]];
        self.backgroundView = self.venueImage;
        
        UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7f];
        [self.contentView addSubview:darkOverlay];
        [self.contentView addSubview:self.venueNameLabel];
        [self.contentView addSubview:self.venueLocationLabel];
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
