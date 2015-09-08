//
//  PIKLabel.m
//  Vibez
//
//  Created by Harry Liddell on 19/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LabelNormalText.h"
#import "UIFont+PIK.h"
#import "UIColor+Piktu.h"

@implementation LabelNormalText

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.font = [UIFont pik_avenirNextRegWithSize:16.0f];
        self.textColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
