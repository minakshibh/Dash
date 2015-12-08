//
//  BlockPersonViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 15/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "assignmentObj.h"

@interface BlockPersonViewController : UIViewController
{
    IBOutlet UILabel *lblbefore;
    IBOutlet UILabel *lblAfter;
    NSMutableData*webData;
    IBOutlet UIImageView *imageView;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblEmail;
    IBOutlet UILabel *lblphoneno;
    NSMutableArray *assignmentListArray;
    int webservice;
    BOOL isBlocked;
    NSString *BlockStr;

    IBOutlet UIButton *btnUnblock;
}
- (IBAction)btnUnblock:(id)sender;
- (IBAction)btnBack:(id)sender;
@property NSString *user_id,*usertype;
@end
