//
//  LocationViewController.h
//  Vibez
//
//  Created by Harry Liddell on 16/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>

@interface LocationViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSString *pinTitle;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;

@property (assign, nonatomic) CLLocationDegrees latCoord;
@property (assign, nonatomic) CLLocationDegrees longCoord;

@end
