//
//  assignmentTableViewCell.h
//  dash
//
//  Created by Krishna_Mac_1 on 6/4/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface assignmentTableViewCell : UITableViewCell
{
    IBOutlet UILabel *vehicleNameLbl;
    IBOutlet UILabel *serviceTypeLbl;
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *backView;
    IBOutlet UIImageView *vehicleImage;
    
    IBOutlet UIImageView *watchImage;
}
-(void)setLabelText:(NSString*)vehicleName :(NSString*)serviceType : (NSString*) descp : (NSString*) time : (NSString*)vehicleImageUrl;
@end
