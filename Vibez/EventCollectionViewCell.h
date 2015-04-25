//
//  EventCollectionViewCell.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EventCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventGenresLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventVenueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UIImage *eventPictureImage;
@property (weak, nonatomic) IBOutlet CLLocation *eventCLLocation;

-(id)initWithFrame:(CGRect)frame;
-(void)setModel:(NSString *)eventName eventDescription:(NSString *)eventDescription eventGenres:(NSString *)eventGenres eventVenueName:(NSString *)eventVenueName eventDate:(NSString *)eventDate eventImageData:(NSData *)eventImageData eventLocation:(NSString *)eventLocation;


@end
