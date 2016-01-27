//
//  UserCollectionViewCell.h
//  Vibez
//
//  Created by Harry Liddell on 04/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *ticketNameLabel;
@property (strong, nonatomic) UILabel *ticketDateLabel;
@property (strong, nonatomic) UILabel *ticketVenueLabel;
@property (strong, nonatomic) UIImageView *ticketImage;
@property (strong, nonatomic) UIImageView *chevronImage;

@end
