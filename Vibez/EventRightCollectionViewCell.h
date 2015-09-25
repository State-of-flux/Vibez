//
//  EventRightCollectionViewCell.h
//  Vibez
//
//  Created by Harry Liddell on 25/09/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface EventRightCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventGenresLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventVenueNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;
@property (strong, nonatomic) IBOutlet CLLocation *eventCLLocation;
@property (strong, nonatomic) UIView *innerView;

-(id)initWithFrame:(CGRect)frame;
-(void)setModel:(NSString *)eventName eventDescription:(NSString *)eventDescription eventGenres:(NSString *)eventGenres eventVenueName:(NSString *)eventVenueName eventDate:(NSString *)eventDate eventImageData:(NSData *)eventImageData eventLocation:(NSString *)eventLocation;


@end
