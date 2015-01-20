//
//  ViewController.m
//  testApp
//
//  Created by Pavel Zagorskyy on 19.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize managedObjectContext, weatherResultArray, mainTable, sunRiseTime, sunSetTime, time, locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate sharedDelegate];
    [self getLocationAndWeather];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)getLocationAndWeather
{
    locationManager = [[LocationManager alloc] init];
    
    [locationManager fetchWithCompletitionSuccess:^(CLLocation *currentLoc) {
        [self getWeatherWithLocation:currentLoc];
        
        [mainTable reloadData];

    } failure:^(NSError *error) {
        [self takeWeatherFromCoreData];
        [mainTable reloadData];
    }];
    


}
#pragma mark Save & Fetch from Core Data our Weather

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%li", [weatherResultArray count]);
    
    return [weatherResultArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}


- (MainTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Weather *objectWeather = [weatherResultArray objectAtIndex:(long)indexPath.row];
    MainTableViewCell *cell = [mainTable dequeueReusableCellWithIdentifier:@"weatherCell" forIndexPath:indexPath];
    cell.weatherLabel.text = [NSString stringWithFormat:@"%@",objectWeather.weatherInfo];
    cell.informationLabel.text = [NSString stringWithFormat:@"%@",objectWeather.weatherExplanation];
    cell.highestTempLabel.text = [NSString stringWithFormat:@"%@",objectWeather.tempMax];
    cell.lowestTempLabel.text = [NSString stringWithFormat:@"%@",objectWeather.tempMin];
    
    [self getTimeFromCoreData:objectWeather];
    
    cell.sunriseTimeLabel.text = sunRiseTime;
    cell.sunsetTimeLabel.text = sunSetTime;
    cell.dateLabel.text = time;
    
    
    return cell;
}

- (NSArray *)takeWeatherFromCoreData {
    
    managedObjectContext = [AppDelegate sharedDelegate].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:managedObjectContext];
    [request setEntity:description];
    NSError *requestError = nil;
    weatherResultArray = [[self.managedObjectContext executeFetchRequest:request error:&requestError] mutableCopy];
    
    if (requestError) {
        NSLog(@"%@" , [requestError localizedDescription]);
    }
    
    NSLog(@"%@", weatherResultArray);
    
    return weatherResultArray;
}
-(void)getWeatherWithLocation:(CLLocation *)location
{
    NSNumber *latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
    
    [[ServerManager sharedManager]
     getWeatherWithLatitude:latitude longtitude:longitude onSuccess:^(NSArray *weather)
     {
         [self saveWeatherWithArray:weather];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
     }];
}

-(void)saveWeatherWithArray:(NSArray *)weatherArray
{
    [AppDelegate sharedDelegate];
    managedObjectContext = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest * allWeatherInfo = [[NSFetchRequest alloc] init];
    [allWeatherInfo setEntity:[NSEntityDescription entityForName:@"Weather" inManagedObjectContext:self.managedObjectContext]];
    [allWeatherInfo setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * allWeatherArray = [managedObjectContext executeFetchRequest:allWeatherInfo error:&error];
    
    for (NSManagedObject *allWeather in allWeatherArray) {
        [managedObjectContext deleteObject:allWeather];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    
    
    for (NSDictionary *weather in weatherArray)
    {
        if ([weather objectForKey:@"I"])
        {
            Weather *weatherObject = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:self.managedObjectContext];
            weatherObject.weatherInfo = [weather objectForKey:@"I"];
            weatherObject.weatherExplanation = [weather objectForKey:@"S"];
            weatherObject.sunRiseTime = [weather objectForKey:@"SrT"];
            weatherObject.sunSetTime = [weather objectForKey:@"SsT"];
            weatherObject.time = [weather objectForKey:@"T"];
            weatherObject.tempMax = [weather objectForKey:@"TempMax"];
            weatherObject.tempMin = [weather objectForKey:@"TempMin"];
            
            OtherInfo *otherInfoObject = [NSEntityDescription insertNewObjectForEntityForName:@"OtherInfo" inManagedObjectContext:self.managedObjectContext];
            
            weatherObject.otherInfo = otherInfoObject;
            
            NSDictionary *otherInfo = [weatherArray lastObject];
            
            weatherObject.otherInfo.longitude = [otherInfo objectForKey:@"Lg"];
            weatherObject.otherInfo.latitude = [otherInfo objectForKey:@"Lt"];
            weatherObject.otherInfo.timeZone = [NSNumber numberWithInteger:[[otherInfo objectForKey:@"Os"] integerValue]];
            weatherObject.otherInfo.localityOfTimeZone = [otherInfo objectForKey:@"Tz"];
            
            NSError *error;
            if ([managedObjectContext save:&error])
            {
                NSLog(@"%@", weatherObject);
                NSLog(@"%@ %@ %@ %@", weatherObject.otherInfo.longitude, weatherObject.otherInfo.latitude,
                      weatherObject.otherInfo.timeZone, weatherObject.otherInfo.localityOfTimeZone);
                
            }
            else
            {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    }
    [self takeWeatherFromCoreData];
    [mainTable reloadData];
    
}



-(void)getTimeFromCoreData:(Weather *)weatherObject
{
    
    NSDate *timeUnform = [NSDate dateWithTimeIntervalSince1970:[weatherObject.time doubleValue]];
    NSDate *sunRiseTimeUnform = [NSDate dateWithTimeIntervalSince1970:[weatherObject.sunRiseTime doubleValue]];
    NSDate *sunSetTimeUnform = [NSDate dateWithTimeIntervalSince1970:[weatherObject.sunSetTime doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSDateFormatter *dateFormatterForDate = [[NSDateFormatter alloc]init];
    [dateFormatterForDate setDateFormat:@"MMM:ccc:d"];
    
    
    sunRiseTime = [dateFormatter stringFromDate:sunRiseTimeUnform];
    sunSetTime = [dateFormatter stringFromDate:sunSetTimeUnform];
    time = [dateFormatterForDate stringFromDate:timeUnform];
    

    
    NSLog(@"%@ %@ &&&&&&&&&&&&&&&&&", sunRiseTime, sunSetTime);
}






















@end
