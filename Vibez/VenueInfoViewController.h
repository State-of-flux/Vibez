//
//  VenueInfoViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"

@interface VenueInfoViewController : GlobalViewController

@property (strong, nonatomic) UIImageView *eventImageView;
@property (strong, nonatomic) UILabel *eventNameLabel;
@property (strong, nonatomic) UILabel *eventDateLabel;
@property (strong, nonatomic) UILabel *eventDateEndLabel;
@property (strong, nonatomic) UITextView *eventDescriptionTextView;
@property (strong, nonatomic) UILabel *eventVenueLabel;

@property (strong, nonatomic) UIImage *imageSelected;

@property (strong, nonatomic) UIScrollView *scrollView;

@end
