//
//  assignmentTableViewCell.m
//  dash
//
//  Created by Krishna_Mac_1 on 6/4/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "assignmentTableViewCell.h"
#import "assignmentsViewController.h"

@implementation assignmentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)vehicleName :(NSString*)serviceType : (NSString*) descp : (NSString*) time : (NSString*)vehicleImageUrl
{
    if([descp isEqualToString:@"BlockedList"])
    {
    
        
        backView.layer.borderColor = [UIColor clearColor].CGColor;
        backView.layer.borderWidth = 1.5;
        backView.layer.cornerRadius = 5.0;
        [backView setClipsToBounds:YES];
        
        vehicleImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        vehicleImage.layer.borderWidth = 1.5;
        
        [vehicleImage setClipsToBounds:YES];
        vehicleImageUrl = [vehicleImageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *imageURL = [NSURL URLWithString:vehicleImageUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                vehicleImage.image = [UIImage imageWithData:imageData];
            });
        });
        
        vehicleNameLbl.text = [NSString stringWithFormat:@"%@",vehicleName];
        serviceTypeLbl.text = [NSString stringWithFormat:@"%@",serviceType];
        descriptionLbl.hidden =YES;
        timeLbl.hidden =YES;
        watchImage.hidden = YES;

        assignmentsViewController *obj = [[assignmentsViewController alloc]init];
        obj.timing = @"BlockedList";
        
        
    }  else{
        
   
    backView.layer.borderColor = [UIColor clearColor].CGColor;
    backView.layer.borderWidth = 1.5;
    backView.layer.cornerRadius = 5.0;
    [backView setClipsToBounds:YES];
    
    vehicleImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    vehicleImage.layer.borderWidth = 1.5;
    
    [vehicleImage setClipsToBounds:YES];
    vehicleImageUrl = [vehicleImageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
    NSURL *imageURL = [NSURL URLWithString:vehicleImageUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            vehicleImage.image = [UIImage imageWithData:imageData];
        });
    });
    
        CGRect newFrame = serviceTypeLbl.frame;
        newFrame.size.width = 280;
        serviceTypeLbl.frame = newFrame;
        
        
    vehicleNameLbl.text = [NSString stringWithFormat:@"%@",vehicleName];
    serviceTypeLbl.text = [NSString stringWithFormat:@"%@",serviceType];
    descriptionLbl.text = [NSString stringWithFormat:@"%@",descp];
        if ([time isEqualToString:@"hide"]) {
            watchImage.hidden = YES;
            timeLbl.hidden = YES;
        }
    timeLbl.text = [NSString stringWithFormat:@"%@",time];
        
    }
}
@end
