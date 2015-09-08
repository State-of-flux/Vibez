//
//  LocationViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()
{
    CLLocationManager *manager;
}
@end

@implementation LocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.annotations = [NSMutableArray array];
    
    manager = [CLLocationManager updateManagerWithAccuracy:10.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    [manager setDelegate:self];
    [manager requestWhenInUseAuthorization];
    [manager startUpdatingLocation];
    
    self.coordinateUser = self.mapView.userLocation.location.coordinate;
   
    [self.mapView setShowsUserLocation:YES];
    
    //[self setUserAnnotation];
    [self setVenueAnnotation];
    
    //CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:self.latCoord longitude:self.longCoord];
    
    float maxLat = -200;
    float maxLong = -200;
    float minLat = MAXFLOAT;
    float minLong = MAXFLOAT;
    
    for (int i=0 ; i < 2 ; i++) {
        CLLocationCoordinate2D location1 = self.coordinateUser;
        CLLocationCoordinate2D location2 = self.coordinateVenue;
        
        if (location1.latitude < minLat) {
            minLat = location1.latitude;
        }
        
        if (location2.latitude < minLat) {
            minLat = location2.latitude;
        }
        
        //
        
        if (location1.longitude < minLong) {
            minLong = location1.longitude;
        }
        
        if (location2.longitude < minLong) {
            minLong = location2.longitude;
        }
        
        //
        
        if (location1.latitude > maxLat) {
            maxLat = location1.latitude;
        }
        
        if (location2.latitude > maxLat) {
            maxLat = location2.latitude;
        }
        
        //
        
        if (location1.longitude > maxLong) {
            maxLong = location1.longitude;
        }
        
        if (location2.longitude > maxLong) {
            maxLong = location2.longitude;
        }
    }
    
    //Center point
    
    //CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat + minLat) * 0.5, (maxLong + minLong) * 0.5);
    
    
    
    
//    
//    
//    NSMutableArray *arrayOfCoordinates = [NSMutableArray array];
//    [arrayOfCoordinates addObject:self.mapView.userLocation.location];
//    [arrayOfCoordinates addObject:self.coordinateVenue];
//    
//    
//    CLLocationDegrees minLat,minLng,maxLat,maxLng;
//    
//    for(CLLocationCoordinate2D coordinate in coordinates) {
//        minLat = MIN(minLat, coordinate.latitude);
//        minLng = MIN(minLng, coordinate.longitude);
//        
//        maxLat = MAX(maxLat, coordinate.latitude);
//        maxLng = MAX(maxLng, coordinate.longitude);
//    }
//    
//    CLLocationCoordinate2D coordinateOrigin = CLLocationCoordinate2DMake(minLat, minLng);
//    CLLocationCoordinate2D coordinateMax = CLLocationCoordinate2DMake(maxLat, maxLng);
//    
//    MKMapPoint upperLeft = MKMapPointForCoordinate(coordinateOrigin);
//    MKMapPoint lowerRight = MKMapPointForCoordinate(coordinateMax);
//    
//    //Create the map rect
//    MKMapRect mapRect = MKMapRectMake(upperLeft.x,
//                                      upperLeft.y,
//                                      lowerRight.x - upperLeft.x,
//                                      lowerRight.y - upperLeft.y);
//    
//    //Create the region
//    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
//    
//    //THIS HAS THE CENTER, it should include spread
//    CLLocationCoordinate2D centerCoordinate = region.center;
    
    
    
    
    
    //[self.mapView showAnnotations:self.annotations animated:YES];
    
    //MKCoordinateRegion region = [self regionForAnnotations:self.annotations];
    //[self.mapView setRegion:region animated:YES];
    
    
    
}

MKCoordinateRegion coordinateRegionForCoordinates(CLLocationCoordinate2D *coords, NSUInteger coordCount) {
    MKMapRect r = MKMapRectNull;
    for (NSUInteger i=0; i < coordCount; ++i) {
        MKMapPoint p = MKMapPointForCoordinate(coords[i]);
        r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
    }
    return MKCoordinateRegionForMapRect(r);
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    if ([annotations count] == 0)
    {
        region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 1000, 1000);
    }
    
    else if ([annotations count] == 1)
    {
        id <MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations)
        {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.12;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self.mapView regionThatFits:region];
}

- (void)setUserAnnotation
{
    MKPointAnnotation *annotationUser = [[MKPointAnnotation alloc] init];
    [annotationUser setCoordinate:self.coordinateUser];
    [annotationUser setTitle:@"You"]; //You can set the subtitle too]; //You can set the subtitle too
    [annotationUser setSubtitle:@"Get Moving"];
    [self.mapView addAnnotation:annotationUser];
    
    [[self annotations] addObject:annotationUser];
}

- (void)setVenueAnnotation
{
    self.coordinateVenue = CLLocationCoordinate2DMake(self.latCoord, self.longCoord);
    
    MKPointAnnotation *annotationVenue = [[MKPointAnnotation alloc] init];
    [annotationVenue setCoordinate:self.coordinateVenue];
    [annotationVenue setTitle:self.pinTitle]; //You can set the subtitle too
    [annotationVenue setSubtitle:@"Your destination"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotationVenue];
    
    [[self annotations] addObject:annotationVenue];
}

-(void)zoomOutForAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    
    MKMapPoint venuePoint = MKMapPointForCoordinate(self.coordinateVenue);
    MKMapRect venueRect = MKMapRectMake(venuePoint.x, venuePoint.y, 0, 0);
    
    MKMapPoint userPoint = MKMapPointForCoordinate(self.coordinateUser);
    MKMapRect userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
    
    zoomRect = MKMapRectUnion(userRect, venueRect);
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
}

-(void)zoomToFitMapAnnotations
{
    if([self.mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    CLLocationCoordinate2D bottomRightCoord;
    topLeftCoord.longitude = fmin(self.mapView.userLocation.location.coordinate.longitude, self.longCoord);
    topLeftCoord.latitude = fmax(self.mapView.userLocation.location.coordinate.latitude, self.latCoord);
    
    bottomRightCoord.longitude = fmax(self.mapView.userLocation.location.coordinate.longitude, self.longCoord);
    bottomRightCoord.latitude = fmin(self.mapView.userLocation.location.coordinate.latitude, self.latCoord);
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    CLLocationCoordinate2D userCoord = { self.latCoord, self.longCoord};
    region.center = userCoord;
    region.span.latitudeDelta = 0.01f;//fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = 0.01f;//fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;  // Add a little extra space on the sides
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}

//    manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
//
//    [manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {



//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//        [defaults setValue:@"Sheffield" forKey:@"currentLocation"];
//        [defaults synchronize];
//
//        NSString *thelocation = [defaults valueForKey:@"currentLocation"];
//        NSLog(@"Our new location: %@", thelocation);
//}];
//
//    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
//    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//    double inset = -zoomRect.size.width * 0.1; [self.mapView setVisibleMapRect:MKMapRectInset(zoomRect, inset, inset) animated:YES];
//    for (id <MKAnnotation> annotation in self.mapView.annotations)
//    {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//        zoomRect = MKMapRectUnion(zoomRect, pointRect);
//    }
//
//    [self.mapView setVisibleMapRect:zoomRect animated:YES];
//
//    self.pinTitle = @"Club";
//
//    //[self setRegion];
//    [self setVenuePin];

//-(void)setRegion
//{
//    self.coordinate = CLLocationCoordinate2DMake(self.latCoord, self.longCoord);
//
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinate, 500, 500);
//    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
//    [self.mapView setRegion:adjustedRegion animated:YES];
//    [self.mapView setShowsUserLocation:YES];
//}
//
//-(void)setVenuePin
//{
//    // Place a single pin
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    [annotation setCoordinate:self.coordinate];
//    [annotation setTitle:self.pinTitle]; //You can set the subtitle too
//    [self.mapView addAnnotation:annotation];
//}

@end
