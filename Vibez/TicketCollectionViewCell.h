//
//  TableCollectionViewCell.h
//  Vibez
//
//  Created by Harry Liddell on 28/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *ticketNameLabel;
@property (strong, nonatomic) UILabel *ticketDateLabel;
@property (strong, nonatomic) UILabel *ticketVenueLabel;
@property (strong, nonatomic) UIImageView *ticketImage;
@property (strong, nonatomic) UIImageView *chevronImage;
@property (strong, nonatomic) UIImageView *isValidImage;

@end
