//
//  locationListTableViewCell.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 06/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface locationListTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *locationNameLbl;
    IBOutlet UILabel *locationAddressLbl;
    
    IBOutlet UILabel *backView;
}
-(void)setLabelText:(NSString*)locationName :(NSString*)locationAddress;
@end
