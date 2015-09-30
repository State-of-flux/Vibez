//
//  EventCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventCollectionViewCell.h"
#import "UIFont+PIK.h"
#import "UIColor+Piktu.h"

@implementation EventCollectionViewCell

-(void)setModel:(NSString *)eventName eventDescription:(NSString *)eventDescription eventGenres:(NSString *)eventGenres eventVenueName:(NSString *)eventVenueName eventDate:(NSString *)eventDate eventImageData:(NSData *)eventImageData eventLocation:(NSString *)eventLocation {
    self.eventNameLabel.text = eventName;
    self.eventDescriptionLabel.text = eventDescription;
    self.eventGenresLabel.text = eventGenres;
    self.eventDateLabel.text = eventDate;
    self.eventImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:eventImageData]];
    self.eventCLLocation = [self locationStringToCLLocation:eventLocation];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        
        CGRect outerFrame = self.contentView.frame;
        
        self.layer.borderColor = [UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:0.8f].CGColor;
        self.layer.borderWidth = 0.5f;
        
        self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, outerFrame.size.height/2 - 50.0f, outerFrame.size.width - 8, 50)];
        [self.eventNameLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:20.0f];
        self.eventNameLabel.textColor = [UIColor whiteColor];
        self.eventNameLabel.numberOfLines = 2;
        
        self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, outerFrame.size.height/2, outerFrame.size.width - 5, 25)];
        [self.eventDateLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
        self.eventDateLabel.textColor = [UIColor whiteColor];
        
        self.eventPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, outerFrame.size.height -30, outerFrame.size.width - 5, 25)];
        [self.eventPriceLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventPriceLabel.font = [UIFont pik_avenirNextBoldWithSize:14.0f];
        self.eventPriceLabel.textColor = [UIColor pku_purpleColor];
    
        self.eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, outerFrame.size.width, outerFrame.size.height)];
        
        UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, outerFrame.size.width, outerFrame.size.height)];
        darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.65f];
        [self.contentView addSubview:self.eventImage];
        [self.contentView addSubview:darkOverlay];
        [self.contentView addSubview:self.eventNameLabel];
        [self.contentView addSubview:self.eventDateLabel];
        [self.contentView addSubview:self.eventPriceLabel];
    }
    
    return self;
}

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
    
    return border;
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
