//
//  vehicleListViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/5/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "vehiclesLIstObj.h"
@interface vehicleListViewController : UIViewController
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath,*trigger;
    FMDatabase *database;
    vehiclesLIstObj *vehiclesListOC;
    IBOutlet UITableView *vehicleListTableView;
    NSMutableArray *vehicleListArray;
    int webservice;
    NSString*vehcleIdStr;
    
}

- (IBAction)addVehicleBtn:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@end
