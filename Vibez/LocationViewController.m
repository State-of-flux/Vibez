//
//  LocationViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CLLocationDegrees latCoord = 53.3764;
    //CLLocationDegrees longCoord = -1.4716;
    
    self.pinTitle = @"Club";
    
    if(self.latCoord && self.longCoord)
    {
        [self setRegion];
        [self setMapPin];
    }
    else
    {
        //UIAlertView;
        //unwind segue
    }
}

-(void)setRegion
{
    self.coordinate = CLLocationCoordinate2DMake(self.latCoord, self.longCoord);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
}

-(void)setMapPin
{
    // Place a single pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.coordinate];
    [annotation setTitle:self.pinTitle]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
}

@end
