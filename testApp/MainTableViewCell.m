//
//  MainTableViewCell.m
//  testApp
//
//  Created by Pavel Zagorskyy on 20.01.15.
//  Copyright (c) 2015 zagorskyy.com. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell
@synthesize weatherLabel,informationLabel,sunriseTimeLabel,sunsetTimeLabel,highestTempLabel,lowestTempLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
