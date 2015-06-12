//
//  EventDataSource.h
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EventDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) NSMutableArray* data;

-(void)setData:(NSMutableArray *)data;

@end
