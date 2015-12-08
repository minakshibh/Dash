//
//  addLocationViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "locationListObj.h"


@interface addLocationViewController : UIViewController<GMSMapViewDelegate, UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData*webData;
    int webservice;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UILabel *headerLbl;
    IBOutlet UIButton *backBtn;
    NSMutableArray      *locationArray;
    double current_latitude;
    double current_longitude;
    GMSMapView *mapView_;
    IBOutlet UIView *mapBackView;
    IBOutlet UIView *searchView;
    IBOutlet UILabel *bgLbl;
    IBOutlet UITextField *searchLocationTxt;
    IBOutlet UITableView *ResultsTableView;
    NSMutableArray *TempDictForSource;
    IBOutlet UIButton *addNameBtn;
    IBOutlet UIView *backView;
    IBOutlet UIView *addNameView;
    IBOutlet UITextField *addLocationNameTxt;
    IBOutlet UIImageView *stepsImg;
    NSMutableArray*locationListArray;
    
    NSString *locationId,*userId,*locationName,*locationAddress, *locationLatitude, *locationLongitude, *trigger;
    IBOutlet UIButton *skipStepsBttn;
    IBOutlet UIButton *saveLocationBtn;
    
    IBOutlet UIImageView *disableImg;
    
    IBOutlet UIScrollView *scrollview;
    IBOutlet UILabel *lblAddlocation;
}
@property (strong , nonatomic) NSString*headerLblStr ;


@property(nonatomic, strong) CLLocationManager *locationManager;
@property NSString *Add_loc;
@property (strong, nonatomic) NSString *addLocationDataType ,*triggervalue;
- (IBAction)backBttn:(id)sender;
@property (strong, nonatomic) locationListObj *locationOC;
- (IBAction)skipStepAction:(id)sender;
- (IBAction)searchLocationBtnAction:(id)sender;
- (IBAction)addNameBtnAction:(id)sender;
- (IBAction)saveLocationBtnAction:(id)sender;
@end
