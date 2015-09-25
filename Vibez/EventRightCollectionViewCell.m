//
//  EventRightCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 25/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "EventRightCollectionViewCell.h"
#import "UIFont+PIK.h"
#import "UIColor+Piktu.h"

@implementation EventRightCollectionViewCell


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
        CGFloat padding = 4.0f;
        CGFloat paddingDouble = padding * 2;
        
        self.innerView = [[UIView alloc] initWithFrame:CGRectMake(outerFrame.origin.x + paddingDouble, outerFrame.origin.y + padding, outerFrame.size.width - (paddingDouble *2), outerFrame.size.height - (paddingDouble))];
        CGRect innerFrame = self.innerView.frame;
        [self.contentView addSubview:self.innerView];
        
        //[self setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
        //self.layer.borderColor = [UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f].CGColor;
        //self.layer.borderWidth = 0.5f;
        
        self.innerView.layer.masksToBounds = YES;
        self.innerView.layer.cornerRadius = 4.0f;
        //self.layer.shadowOffset = CGSizeMake(0, 0);
        //self.layer.shadowRadius = 3;
        //self.layer.shadowOpacity = 0.5;
        
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
