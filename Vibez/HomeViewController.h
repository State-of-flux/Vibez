//
//  HomeViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "SwipeView.h"
#import "EventCollectionViewCell.h"
#import "VenueCollectionViewCell.h"

@interface HomeViewController : GlobalViewController <UICollectionViewDataSource, UICollectionViewDelegate, SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) IBOutlet SwipeView *swipeView;

@end
