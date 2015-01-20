//
//  Weather.h
//  testApp
//
//  Created by Pavel Zagorskyy on 19.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OtherInfo;

@interface Weather : NSManagedObject

@property (nonatomic, retain) NSString * weatherExplanation;
@property (nonatomic, retain) NSString * weatherInfo;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * sunSetTime;
@property (nonatomic, retain) NSNumber * sunRiseTime;
@property (nonatomic, retain) NSNumber * tempMin;
@property (nonatomic, retain) NSNumber * tempMax;
@property (nonatomic, retain) OtherInfo *otherInfo;

@end
