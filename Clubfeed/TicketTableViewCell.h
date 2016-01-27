//
//  TicketTableViewCell.h
//  Vibez
//
//  Created by Harry Liddell on 12/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ticketNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ticketDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *ticketVenueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ticketImage;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
