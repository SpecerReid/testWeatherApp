//
//  MainTableViewCell.h
//  testApp
//
//  Created by Pavel Zagorskyy on 20.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highestTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowestTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
