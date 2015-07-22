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
        self.ticketNameLabel.font = [UIFont pik_avenirNextBoldWithSize:18.0f];
        
        self.ticketDateLabel = [[UILabel alloc] init];
        self.ticketDateLabel.textColor = [UIColor pku_greyColor];
        self.ticketDateLabel.font = [UIFont pik_avenirNextRegWithSize:16.0f];
        
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
    CGFloat padding = 8;
    
    self.ticketImage.frame = CGRectMake(10, 10, height - 20, height - 20);
    self.ticketImage.image = [UIImage imageNamed:@"plug.jpg"];
    self.ticketImage.layer.masksToBounds = YES;
    self.ticketImage.layer.cornerRadius = 25.0f;
    
    self.separatorInset = UIEdgeInsetsMake(50, 0, self.bounds.size.width, 0);
    
    self.ticketNameLabel.frame = CGRectMake(CGRectGetMaxX(self.ticketImage.frame) + padding, height / 4.2, width, 20);
    self.ticketDateLabel.frame = CGRectMake(CGRectGetMaxX(self.ticketImage.frame) + padding, height / 1.8, width / 2, 20);

    [self.contentView addSubview:self.ticketNameLabel];
    [self.contentView addSubview:self.ticketDateLabel];
    [self.contentView addSubview:self.ticketImage];
}

@end
