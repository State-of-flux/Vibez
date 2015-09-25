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
        CGFloat padding = 5.0f;
        CGFloat paddingDouble = padding * 2;
        
        // The inner view has to be 5 points inwards on every side.
        
        self.innerView = [[UIView alloc] initWithFrame:CGRectMake(outerFrame.origin.x + paddingDouble, outerFrame.origin.y + padding, outerFrame.size.width - padding, outerFrame.size.height - padding)];
        CGRect innerFrame = self.innerView.frame;
        [self.contentView addSubview:self.innerView];
        
        self.innerView.layer.masksToBounds = YES;
        self.innerView.layer.cornerRadius = 5.0f;
        
        self.contentView.layer.shadowOffset = CGSizeMake(0.2, 0.2); //%%% this shadow will hang slightly down and to the right
        self.contentView.layer.shadowRadius = 1; //%%% I prefer thinner, subtler shadows, but you can play with this
        self.contentView.layer.shadowOpacity = 0.2; //%%% same thing with this, subtle is better for me
        
        //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
        self.contentView.layer.shadowPath = path.CGPath;
        
        self.eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, innerFrame.size.height/2 - 50.0f, innerFrame.size.width - 8, 50)];
        [self.eventNameLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventNameLabel.font = [UIFont pik_montserratBoldWithSize:20.0f];
        self.eventNameLabel.textColor = [UIColor whiteColor];
        self.eventNameLabel.numberOfLines = 2;
        
        self.eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, innerFrame.size.height/2, innerFrame.size.width - 5, 25)];
        [self.eventDateLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventDateLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
        self.eventDateLabel.textColor = [UIColor whiteColor];
        
        self.eventPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, innerFrame.size.height -30, innerFrame.size.width - 5, 25)];
        [self.eventPriceLabel setTextAlignment:NSTextAlignmentCenter];
        self.eventPriceLabel.font = [UIFont pik_avenirNextBoldWithSize:14.0f];
        self.eventPriceLabel.textColor = [UIColor pku_purpleColor];
    
        self.eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, innerFrame.size.width, innerFrame.size.height)];
        
        UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, innerFrame.size.width, innerFrame.size.height)];
        darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.65f];
        [self.innerView addSubview:self.eventImage];
        [self.innerView addSubview:darkOverlay];
        [self.innerView addSubview:self.eventNameLabel];
        [self.innerView addSubview:self.eventDateLabel];
        [self.innerView addSubview:self.eventPriceLabel];
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
