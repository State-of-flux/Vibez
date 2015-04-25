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

@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImage *venueImage;
@property (weak, nonatomic) IBOutlet CLLocation *venueCLLocation;

-(void)setModel:(NSString *)venueName venueDescription:(NSString *)venueDescription venueImageData:(NSData *)venueImageData venueLocation:(NSString *)venueLocation;
-(id)initWithFrame:(CGRect)frame;

@end
