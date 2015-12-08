//
//  locationListTableViewCell.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 06/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "locationListTableViewCell.h"

@implementation locationListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)locationName :(NSString*)locationAddress{
    
    backView.layer.borderColor = [UIColor clearColor].CGColor;
    backView.layer.borderWidth = 1.5;
    backView.layer.cornerRadius = 5.0;
    [backView setClipsToBounds:YES];

    locationNameLbl.text = [NSString stringWithString:locationName];
    locationAddressLbl.text = [NSString stringWithString:locationAddress];
}
@end
