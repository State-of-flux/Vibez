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

@property (weak, nonatomic) IBOutlet NSString *eventName;
@property (weak, nonatomic) IBOutlet NSString *eventDescription;
@property (weak, nonatomic) IBOutlet NSString *eventGenres;
@property (weak, nonatomic) IBOutlet NSString *eventVenueName;
@property (weak, nonatomic) IBOutlet NSDate *eventDate;
@property (weak, nonatomic) IBOutlet NSData *eventPicture;
@property (weak, nonatomic) IBOutlet CLLocation *eventCLLocation;

@end
