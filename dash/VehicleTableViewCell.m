//
//  VehicleTableViewCell.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 07/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "VehicleTableViewCell.h"

@implementation VehicleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText :(NSString*)vehicleImg1 : (NSString*)vehicleColor : (NSString*)vehicleNumber : (NSString*)vehicleMake : (NSString*)vehicleModal{
    
    backView.layer.borderColor = [UIColor clearColor].CGColor;
    backView.layer.borderWidth = 1.5;
    backView.layer.cornerRadius = 5.0;
    [backView setClipsToBounds:YES];
    
    NSURL *imageURL = [NSURL URLWithString:vehicleImg1];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            vehicleImg.image = [UIImage imageWithData:imageData];
        });
    });

   // NSData *data = [[NSData alloc]initWithBase64EncodedString:vehicleImg1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // vehicleImg.image = [UIImage imageWithData:data];
    
    
    
    
    vehicleNameLbl.text = @"";
    vehicleColorLbl.text = [NSString stringWithFormat:@"%@,%@",vehicleColor,vehicleMake];
    vehicleNumberLbl.text = [NSString stringWithString:vehicleNumber];
    //vehicleMakeLbl.text = [NSString stringWithString:vehicleMake];
    vehicleModalLbl.text = [NSString stringWithString:vehicleModal];
    
}

@end
