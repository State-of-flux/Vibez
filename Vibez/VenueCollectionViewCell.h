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

@property (weak, nonatomic) IBOutlet NSString *venueName;
@property (weak, nonatomic) IBOutlet NSString *venueDescription;
@property (weak, nonatomic) IBOutlet NSString *eventVenue;
@property (weak, nonatomic) IBOutlet NSDate *eventDate;
@property (weak, nonatomic) IBOutlet NSData *eventPicture;
@property (weak, nonatomic) IBOutlet CLLocation *eventCLLocation;

@end
