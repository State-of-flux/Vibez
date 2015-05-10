//
//  VenueCollectionViewCell.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VenueCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *venueDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *venueImage;
@property (strong, nonatomic) IBOutlet CLLocation *venueCLLocation;

-(void)setModel:(NSString *)venueName venueDescription:(NSString *)venueDescription venueImageData:(NSData *)venueImageData venueLocation:(NSString *)venueLocation;
-(id)initWithFrame:(CGRect)frame;

@end
