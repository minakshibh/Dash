//
//  requestServiceViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/27/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "locationListObj.h"
#import "FMDatabase.h"
#import "AFHTTPRequestOperationManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "PayPalMobile.h"

@interface requestServiceViewController : UIViewController<NIDropDownDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,GMSMapViewDelegate, UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,PayPalPaymentDelegate>
{
    
    
    IBOutlet UILabel *serviceTypeRateLbl;
    
    IBOutlet UILabel *serviceTypeTimeLbl;
    IBOutlet UIScrollView *backScrollView;
    CGPoint svos;
    NSString*scheduleAtStr;
    
    IBOutlet UILabel *makeBackLbl;
    IBOutlet UILabel *colorBackLbl;
    IBOutlet UILabel *vinBackLbl;
    IBOutlet UILabel *modelBackLbl;

    IBOutlet UILabel *anyOtheRReqBackLbl;
    NIDropDown *dropDown;
    IBOutlet UITextField *specialRequirmentTxt;
    IBOutlet UITextField *modeltxt;
    IBOutlet UITextField *maketxt;
    IBOutlet UITextField *vehicleNumberTxt;
    IBOutlet UITextField *colorTxt;
    IBOutlet UIImageView *uploadImage;
    IBOutlet UITextField *locationTxt;
    NSMutableArray *locationArray, *serviceTpeArray, *serviceTimeArray ,*resultLocArray;
    IBOutlet UIView *serviceTypeView;
    IBOutlet UIView *selectServiceLocationView;
    BOOL isOtherLocationSelected;
    IBOutlet UITableView *serviceLocationTableView;
    IBOutlet UIButton *selectLocationBtn;
    IBOutlet UIButton *selectServiceTimeBtn;
    IBOutlet UIButton *selectDateBtn;
    IBOutlet UIButton *selectTimeBtn;
    IBOutlet UIView *serviceTimeView;
    IBOutlet UITableView *selectTypeTableView;
    IBOutlet UITableView *selectTimeTableView;
    IBOutlet UIButton *selectServiceTypeBtn;
    IBOutlet UIButton *getMapLocationBtn;
    IBOutlet UIButton *submitBtn;
    IBOutlet UIImageView *clockImg;
    IBOutlet UIImageView *calenderImg;
    IBOutlet UILabel *selectServiceTimeLbl;
    IBOutlet UILabel *selectServiceTypeLbl;
    IBOutlet UILabel *selectServiceLocationLbl;
    IBOutlet UIView *pickerBackView;
    IBOutlet UIDatePicker *dateTimePickr;
    NSString*addressStr,*lattStr,*longStr,*serviceTypeIdstr,*timeStr;
    NSMutableArray *locListNameArray,*carModalArray;
    NSData* imagedata;

    IBOutlet UITableView *ResultsTableView;

    NSString *timeSelectionType, *dateSelected,*timeSelected;
    
    NSMutableData*webData;
    int webservice;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath,*trigger;
    FMDatabase *database;
    locationListObj *locationListOC;
    NSMutableArray *serviceTypeListarr;
    float current_longitude;
    float current_latitude;
    IBOutlet UILabel *dateLbl;
    
    IBOutlet UILabel *timeLbl;
    IBOutlet UIView *paymentBackView;
    
    IBOutlet UIButton *locationbtnforlocation;
    IBOutlet UIButton *selectLocationBtnAction;
    IBOutlet UITableView *carModaltableView;
    IBOutlet UILabel *lblvehicleInfo;
    IBOutlet UILabel *lblpleaseselect;
    IBOutlet UIButton *carModelDropdown;
    IBOutlet UILabel *pleaseSelectVehicleLblTitle;
    UIView *hudView;
    IBOutlet UIButton *paymentbackbtn;
}
- (IBAction)carModelDropdown:(id)sender;
@property (strong,nonatomic)NSString*detailrId,*dateStr,*userType;
@property (strong,nonatomic)NSArray*detailrsArray;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

- (IBAction)uploadImageBtnAction:(id)sender;
- (IBAction)getMapLocationBtnAction:(id)sender;
- (IBAction)selectLocationBtnAction:(id)sender;
- (IBAction)selectServiceTimeBtnAction:(id)sender;
- (IBAction)selectDateBtnAction:(id)sender;
- (IBAction)selectTimeBtnAction:(id)sender;
- (IBAction)selectserviceTypeBtnAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;
- (IBAction)doneDateSelectionBttn:(id)sender;
- (IBAction)cancelDateSelectionBttn:(id)sender;
- (IBAction)backBttn:(id)sender;
- (IBAction)payInAdvanceBttn:(id)sender;
- (IBAction)payAfterServiceBttnn:(id)sender;
- (IBAction)payMntBackBttn:(id)sender;
- (IBAction)locationbtnforlocation:(id)sender;
@end
