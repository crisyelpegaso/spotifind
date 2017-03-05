//
//  LocationUtils.h
//  Spotifind
//
//  Created by Maria cristina rodriguez on 3/5/17.
//  Copyright © 2017 Maria cristina rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtils : NSObject

+ (CLLocationCoordinate2D)getCurrentLocation;

@end
