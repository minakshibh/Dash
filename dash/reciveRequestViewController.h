//
//  reciveRequestViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/13/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <MapKit/MapKit.h>
#import "DetailerFirastViewController.h"
@interface reciveRequestViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{   int webservices;
    IBOutlet UIButton *btnmenu;
    IBOutlet UIImageView *menuicon;
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    GMSMapView *mapView;
    IBOutlet UILabel *nameLbl;
    CLLocationManager*locManager;
    GMSMarker*marker;
    float lat;
    float lon;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIView *tapToAcceptView;
    IBOutlet UIView *userRequestView;
    IBOutlet UIButton *goOnlineBtn;
    DetailerFirastViewController *detailerFirstVC;
    IBOutlet UILabel *timerLbl;
    IBOutlet UILabel *timerLbl1;
    int TimerValue;
    NSTimer *DownTimer;
    IBOutlet UIView *tapToacceptViewIphone5;
    IBOutlet UIView *userRequestViewIphone5;
    NSString *userRequestNow,*request;
    IBOutlet UIImageView *customerImage1;
    IBOutlet UIImageView *customerImage;
    IBOutlet UILabel *lblcarInfo;
    IBOutlet UILabel *lblcarInfo1;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *Username;
    IBOutlet UILabel *usernam1;
    IBOutlet UILabel *lblTime1;
    IBOutlet UILabel *lblTime;
}
- (IBAction)myWorkSamples:(id)sender;
- (IBAction)backbtn:(id)sender;
- (IBAction)userInfo:(id)sender;
- (IBAction)userInfo1:(id)sender;

- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
- (IBAction)tapToAcceptBtnAction:(id)sender;
@property NSArray *reqid1;
@property NSString *timer;
@property(nonatomic, strong) CLLocationManager *locationManager;
@end
