//
//  locationListViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 06/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "locationListObj.h"
@interface locationListViewController : UIViewController
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath,*trigger;
    FMDatabase *database;
    locationListObj *locationListOC;
    IBOutlet UITableView *locationListTableView;
    NSMutableArray *locationListArray;
}
- (IBAction)addLocationBttn:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@end
