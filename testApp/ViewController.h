//
//  ViewController.h
//  testApp
//
//  Created by Pavel Zagorskyy on 19.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LocationManager.h"
#import "MainTableViewCell.h"




@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *weatherResultArray;

@property (strong, nonatomic) NSString *sunRiseTime;
@property (strong, nonatomic) NSString *sunSetTime;
@property (strong, nonatomic) NSString *time;

@property (strong, nonatomic) LocationManager *locationManager;




@end



