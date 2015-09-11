//
//  EventSelectorViewController.h
//  Vibez
//
//  Created by Harry Liddell on 06/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventSelectorViewController : UIViewController

typedef void(^completion)(BOOL);

+ (instancetype)create;

@end

