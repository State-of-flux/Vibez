//
//  LabelTitle.m
//  Vibez
//
//  Created by Harry Liddell on 19/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LabelTitle.h"

@implementation LabelTitle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.font = [UIFont pik_montserratBoldWithSize:18.0f];
        self.textColor = [UIColor whiteColor];
    }
    
    return self;
}
@end
