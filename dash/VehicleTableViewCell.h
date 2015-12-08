//
//  VehicleTableViewCell.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 07/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *vehicleImg;
    IBOutlet UILabel *vehicleNameLbl;
    IBOutlet UILabel *backView;
    IBOutlet UILabel *vehicleColorLbl;
    IBOutlet UILabel *vehicleNumberLbl;
    IBOutlet UILabel *vehicleModalLbl;
    
}
-(void)setLabelText:(NSString*)vehicleImg :(NSString*)vehicleColor : (NSString*) vehicleNumber : (NSString*) vehicleMake : (NSString*)vehicleModal;
@end
