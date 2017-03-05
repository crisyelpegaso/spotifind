//
//  LocationUtils.m
//  Spotifind
//
//  Created by Maria cristina rodriguez on 3/5/17.
//  Copyright © 2017 Maria cristina rodriguez. All rights reserved.
//

#import "LocationUtils.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocationUtils

+(CLLocationCoordinate2D )getCurrentLocation{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;

}
@end
