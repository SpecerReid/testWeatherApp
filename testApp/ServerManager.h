//
//  ServerManager.h
//  testApp
//
//  Created by Pavel Zagorskyy on 19.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ServerManager : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;


+ (ServerManager*) sharedManager;

- (void) getWeatherWithLatitude:(NSNumber *)latitude
                     longtitude:(NSNumber *)longtitude
                      onSuccess:(void(^)(NSMutableArray *weather))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;






@end
