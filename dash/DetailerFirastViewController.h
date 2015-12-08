//
//  DetailerFirastViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 07/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"


@interface DetailerFirastViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    int webservice;

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
    IBOutlet UIButton *goOnlineBtn;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    NSString *nameStr;
     NSTimer *timer;
    IBOutlet UILabel *lblblockedlist1;
    IBOutlet UILabel *lblblockedlist2;
    NSTimer *Downtimer;
}
- (IBAction)button:(id)sender;
- (IBAction)blockedList:(id)sender;
- (IBAction)myWorkSamples:(id)sender;

- (IBAction)serviceHistoryBtnAction:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)assignmentListBtnAction:(id)sender;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *testView;
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
@property GMSMapView *mapView;
@end
