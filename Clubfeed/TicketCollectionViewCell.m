//
//  TableCollectionViewCell.m
//  Vibez
//
//  Created by Harry Liddell on 28/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketCollectionViewCell.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@implementation TicketCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor pku_lighterBlack];
        
        self.ticketNameLabel = [[UILabel alloc] init];
        self.ticketNameLabel.textColor = [UIColor whiteColor];
        self.ticketNameLabel.font = [UIFont pik_avenirNextBoldWithSize:16.0f];
        
        self.ticketDateLabel = [[UILabel alloc] init];
        self.ticketDateLabel.textColor = [UIColor pku_greyColor];
        self.ticketDateLabel.font = [UIFont pik_avenirNextRegWithSize:14.0f];
        
        self.ticketImage = [[UIImageView alloc] init];
        self.chevronImage = [[UIImageView alloc] init];
        self.isValidImage = [[UIImageView alloc] init];
    }
    
    return self;
}

- (CALayer *)prefix_addUpperBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness inset:(CGFloat)inset
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(inset, 0, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(inset, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
    
    return border;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    UIView * selectedBackgroundView = [[UIView alloc] init];
//    [selectedBackgroundView setBackgroundColor:[UIColor pku_lightBlack]]; // set color here
//    [self setSelectedBackgroundView:selectedBackgroundView];
//}

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
    CGFloat paddingDouble = padding * 2;
    
    self.ticketImage.frame = CGRectMake(padding, padding, height - paddingDouble, height - paddingDouble);
    
    self.ticketImage.layer.masksToBounds = YES;
    self.ticketImage.layer.cornerRadius = height/2 - padding;
    [[self ticketImage] setContentMode:UIViewContentModeScaleAspectFill];
    
    UIView* darkOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ticketImage.frame.size.width, self.ticketImage.frame.size.height)];
    darkOverlay.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.65f];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    [self.chevronImage setFrame:CGRectMake(width - 25, 35, 10, 17.5)];
    [self.chevronImage setImage:[factory createImageForIcon:NIKFontAwesomeIconChevronRight]];
    [self.chevronImage setTintColor:[UIColor lightGrayColor]];
    [self.chevronImage setCenter:CGPointMake(self.chevronImage.frame.origin.x, height/2)];
    
    [factory setColors:@[[UIColor whiteColor], [UIColor whiteColor]]];
    
    [self.isValidImage setFrame:CGRectMake(CGRectGetMinX([self.chevronImage frame]) - 25, 35, 15, 15)];
    [self.isValidImage setImage:[factory createImageForIcon:NIKFontAwesomeIconTicket]];
    [self.isValidImage setCenter:CGPointMake(self.isValidImage.frame.origin.x, height/2)];
    
    self.ticketNameLabel.frame = CGRectMake(CGRectGetMaxX(self.ticketImage.frame) + padding, height / 4.2, width, 20);
    self.ticketDateLabel.frame = CGRectMake(CGRectGetMaxX(self.ticketImage.frame) + padding, height / 1.8, width / 2, 20);
    
    [self.layer addSublayer:[self prefix_addUpperBorder:UIRectEdgeBottom color:[UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1.0f] thickness:0.3f inset:self.ticketImage.frame.size.width + paddingDouble]];
    
    [self.contentView addSubview:self.ticketNameLabel];
    [self.contentView addSubview:self.ticketDateLabel];
    [self.contentView addSubview:self.ticketImage];
    //[self.ticketImage addSubview:darkOverlay];
    [self.contentView addSubview:self.chevronImage];
    [self.contentView addSubview:self.isValidImage];
    //[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

@end
