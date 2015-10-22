//
//  LocationViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LocationViewController.h"
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>

@interface LocationViewController () {
    CLLocationManager *manager;
}
@end

@implementation LocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Map"];
    
    PFGeoPoint *geoPoint = [[self venue] location];
    [self setLatCoord:[geoPoint latitude]];
    [self setLongCoord:[geoPoint longitude]];
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    [self.buttonGetDirections setImage:[factory createImageForIcon:NIKFontAwesomeIconLocationArrow] forState:UIControlStateNormal];
    
    [[self mapView] setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
    manager = [CLLocationManager updateManagerWithAccuracy:5.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    [manager setDelegate:self];
    [manager requestWhenInUseAuthorization];
    [manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        self.coordinateUser = self.mapView.userLocation.location.coordinate;
    }];
    
    [self.mapView setShowsUserLocation:YES];
    [self setVenueAnnotation];
    [self setRegion];
}

- (void)setVenueAnnotation {
    self.coordinateVenue = CLLocationCoordinate2DMake(self.latCoord, self.longCoord);
    
    MKPointAnnotation *annotationVenue = [[MKPointAnnotation alloc] init];
    [annotationVenue setCoordinate:self.coordinateVenue];
    [annotationVenue setTitle:[[self venue] name]];
    [annotationVenue setSubtitle:@"The Vibes await."];
    [self.mapView addAnnotation:annotationVenue];
    [[self annotations] addObject:annotationVenue];
    [self.mapView selectAnnotation:annotationVenue animated:YES];
}

-(void)setRegion {
    self.coordinateVenue = CLLocationCoordinate2DMake(self.latCoord, self.longCoord);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinateVenue, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}

- (IBAction)buttonGetDirectionsPressed:(id)sender {
    NSLog(@"Get directions pressed");
    
    UIActionSheet *actionSheetGetDirections = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Open in Apple Maps", nil), nil];
    
    [actionSheetGetDirections setTag:100];
    [actionSheetGetDirections showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Open in Apple Maps", nil)]) {
            [self openInAppleMaps];
        }
    }
}

-(void)openInAppleMaps {
    // Create an MKMapItem to pass to the Maps app
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinateVenue
                                                   addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    [mapItem setName:[[self venue] name]];
    // Set the directions mode to "Walking"
    // Can use MKLaunchOptionsDirectionsModeDriving instead
    NSDictionary *launchOptions = @{ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    // Get the "Current User Location" MKMapItem
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    // Pass the current location and destination map items to the Maps app
    // Set the direction mode in the launchOptions dictionary
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                   launchOptions:launchOptions];
}


@end
