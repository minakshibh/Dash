//
//  homeViewViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "mapDetailsObj.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>

@interface homeViewViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISlider *lblSlider;
    NSMutableData*webData;
    int webservice;
    
    IBOutlet UIButton *ratingSort;
    IBOutlet UIButton *distancSort;
    IBOutlet UIButton *feesSort;
    IBOutlet UITableView *detailrDetailTableView;
    NSString*cur_lat ,*cur_long,*city ,*selected_Vehcl_Id;
    IBOutlet UIButton *viewAsListBtn;
    IBOutlet UIButton *viewAsMapBtn;
    
    GMSMapView *mapView_;
    NSMutableArray*detailerListArray;
    NSMutableArray *latitudeArray, *longitudeArray, *titleArray, *markersImageArray, *rattingArray;
    IBOutlet UIView *detailrDetailBackView;
    mapDetailsObj *mapDetailsOC;
    UITapGestureRecognizer *letterTapRecognizer;
    NSTimer *sendBackTimer;
    IBOutlet UIImageView *menuIconImg;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *profileName;
    
    IBOutlet UIButton *viewProfileBttn;
    IBOutlet UIView *sideView;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    BOOL isguestUser;
    IBOutlet UIButton *nameSort;
    NSString*callerView;
    IBOutlet UILabel *logOutLineLbl;
    
    IBOutlet UIButton *logOutBtn;
    
    IBOutlet UIButton *myLocBttn;
    
    
    IBOutlet UIButton *myVehiclBtn;
    IBOutlet UILabel *myLocLineLbl;
    
    IBOutlet UILabel *myVehLineLbl;
    IBOutlet UIButton *signUp;
    
    IBOutlet UIButton *logIn;
    IBOutlet UIButton *serviceHistoryBtn;
    IBOutlet UIButton *workSampleBtn;
    IBOutlet UIButton *ScheduleServiceBtn;
    IBOutlet UILabel *servicehistoryLineLbl;
    IBOutlet UILabel *workSampleLineLbl;
    IBOutlet UILabel *scheduleServiceLineLbl;
    float lat, lon;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    NSString *nameStr;
    IBOutlet UILabel *lblTime;
    NSMutableArray *distance;
    IBOutlet UIButton *BlockedList;
    NSTimer *Downtimer;
    
    IBOutlet UILabel *lbllogout;
    float distInMeter;
    IBOutlet UILabel *lblLOGOUT;
    IBOutlet UIButton *recommended_detailers;
    IBOutlet UISlider *slideroutlet;
    IBOutlet UIView *testView;
    
    IBOutlet UILabel *lblComfort;
}
- (IBAction)slideraction:(id)sender;
- (IBAction)recommended_detailers:(id)sender;
- (IBAction)BlockedList:(id)sender;
@property(strong,nonatomic)    NSString*fromView,*presentUserID;
- (IBAction)workSamples:(id)sender;
- (IBAction)viewAsMapBttn:(id)sender;
- (IBAction)viewAsListBtn:(id)sender;
- (IBAction)logIn:(id)sender;

- (IBAction)menuBtnAction:(id)sender;
- (IBAction)MyVehicles:(id)sender;
- (IBAction)MyLocationsBtn:(id)sender;
- (IBAction)requestService:(id)sender;
- (IBAction)profileBttn:(id)sender;
- (IBAction)homeBtnAction:(id)sender;
- (IBAction)checkBTN:(id)sender;
- (IBAction)serviceHistoryBttn:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)feesSortBttn:(id)sender;
- (IBAction)ratingSortBttn:(id)sender;
- (IBAction)distanceSortBttn:(id)sender;
- (IBAction)nameSortBttn:(id)sender;
- (IBAction)scheduledServicesBtnAction:(id)sender;
- (IBAction)serviceHistoryBtnAction:(id)sender;

- (IBAction)signUp:(id)sender;
- (IBAction)button:(id)sender;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *testView;
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;



@end
