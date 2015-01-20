//
//  LocationManager.h
//  testApp
//
//  Created by Pavel Zagorskyy on 20.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerManager.h"
#import "AppDelegate.h"
#import "Weather.h"
#import "OtherInfo.h"


@interface LocationManager : NSObject <CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, copy) void(^didCompleteBlock)(CLLocation *location);
@property (nonatomic, copy) void(^didFailureBlock)(NSError *error);



- (void)fetchWithCompletitionSuccess:(void (^)(CLLocation *currentLoc))blockSuccess
                             failure:(void (^)(NSError *error))blockFailure;



- (void) didComplete:(CLLocation *)location;
- (void) didFailure:(NSError *)error;









@end
