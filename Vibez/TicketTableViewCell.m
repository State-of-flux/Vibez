//
//  TicketTableViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 12/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "UIColor+Piktu.h"
#import "UIFont+PIK.h"

@implementation TicketTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.backgroundColor = [UIColor pku_blackColor];
        
        
        self.ticketNameLabel = [[UILabel alloc] init];
        self.ticketNameLabel.textColor = [UIColor whiteColor];
        self.ticketNameLabel.font = [UIFont pik_montserratBoldWithSize:18.0f];
        
        self.ticketVenueLabel = [[UILabel alloc] init];
        self.ticketVenueLabel.textColor = [UIColor pku_greyColor];
        self.ticketVenueLabel.font = [UIFont pik_montserratRegWithSize:16.0f];
        
        self.ticketDateLabel = [[UILabel alloc] init];
        self.ticketDateLabel.textColor = [UIColor pku_greyColor];
        self.ticketDateLabel.font = [UIFont pik_montserratRegWithSize:16.0f];
        
        self.ticketImage = [[UIImageView alloc] init];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    self.ticketImage.frame = CGRectMake(0, 0, height, height);
    self.ticketImage.image = [UIImage imageNamed:@"ticket.jpg"];
    
    self.ticketNameLabel.frame = CGRectMake(CGRectGetWidth(self.ticketImage.frame) + 5, height / 5, width, 20);
    self.ticketVenueLabel.frame = CGRectMake(CGRectGetWidth(self.ticketImage.frame) + 5, height / 1.75, width / 2, 20);
    self.ticketDateLabel.frame = CGRectMake(CGRectGetMaxX(self.ticketVenueLabel.frame) + 5, height / 1.75, width / 2, 20);
    

    [self.contentView addSubview:self.ticketNameLabel];
    [self.contentView addSubview:self.ticketVenueLabel];
    [self.contentView addSubview:self.ticketDateLabel];
    [self.contentView addSubview:self.ticketImage];
}

@end
