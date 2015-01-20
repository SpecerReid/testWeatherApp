//
//  ServerManager.m
//  testApp
//
//  Created by Pavel Zagorskyy on 19.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager
@synthesize url,requestOperationManager;


+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        url = [NSURL URLWithString:@"http://weatheritapi.ds.trustsourcing.com/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) getWeatherWithLatitude:(NSNumber *)latitude
                     longtitude:(NSNumber *)longtitude
                      onSuccess:(void(^)(NSMutableArray *weather)) success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure

{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: latitude, @"latitude", longtitude, @"longtitude", nil];
    
    [self.requestOperationManager GET:@"getData" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *otherInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [responseObject objectForKey:@"Lg"],@"Lg",
                                    [responseObject objectForKey:@"Lt"],@"Lt",
                                    [responseObject objectForKey:@"Os"],@"Os",
                                    [responseObject objectForKey:@"Tz"],@"Tz",
                                    nil];
        
        NSLog(@" !!!!!!!!!!! %@", otherInfo);
        NSLog(@" %@", [responseObject class]);
        
        
        NSArray *weatherArray = [responseObject objectForKey:@"D"];
        NSMutableArray *weather = [NSMutableArray arrayWithArray:weatherArray];
    
        
        [weather addObject:otherInfo];
     
        NSLog(@"%@", weather);
        
        
         if (success) {
             success(weather);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         // HERACHIM TYT CHETO
         
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
         
     }];
}



@end
