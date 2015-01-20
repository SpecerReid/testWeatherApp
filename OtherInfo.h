//
//  OtherInfo.h
//  testApp
//
//  Created by Pavel Zagorskyy on 19.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface OtherInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * localityOfTimeZone;
@property (nonatomic, retain) NSNumber * timeZone;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) Weather *infoForWeather;

@end
