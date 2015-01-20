//
//  LocationManager.m
//  testApp
//
//  Created by Pavel Zagorskyy on 20.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager
@synthesize locationManager, location, managedObjectContext, didCompleteBlock, didFailureBlock;

#pragma mark Location Manager methods


- (void) stopUpdateLocManager
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
}

- (void) didComplete:(CLLocation *)currentLocation
{
    didCompleteBlock(currentLocation);
    [self stopUpdateLocManager];
}

- (void) didFailure:(NSError *)error
{
    didFailureBlock(error);
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [locationManager startUpdatingLocation];
    }
}

- (void)fetchWithCompletitionSuccess:(void (^)(CLLocation *currentLoc))blockSuccess
                             failure:(void (^)(NSError *error))blockFailure
{
    didCompleteBlock = blockSuccess;
    didFailureBlock = blockFailure;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // iOS8+
        // Sending a message to avoid compile time error
        [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                   to:self.locationManager
                                                 from:self
                                             forEvent:nil];
    }
//    [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [self didFailure:error];
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

#pragma mark Get City Name by location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"isdjfjfk");
    location = [locations lastObject];
    
    [self didComplete:location];
    [self saveLocationToDefault];
    
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.locality;
         NSString *countryName = myPlacemark.country;
         NSLog(@"My city: %@ and countryName: %@", countryCode, countryName);
         
         
     }];
    
}

#pragma mark AFNetworking request & Save to NSUserDefaults last weather

-(void)saveLocationToDefault
{
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}







@end
