//
//  arrivalViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 04/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "updateRequest.h"


@interface arrivalViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblCarInfo;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblTime;
    IBOutlet UIImageView *userImageView;
    NSMutableData*webData;
    NSDictionary *data,*LocationsDict;
    GMSMapView *mapView,*mapView_;
    CLLocationManager*locManager,*locationManager;
    NSArray *waypoints_,*waypointStrings_;
    GMSMarker*marker;
    float lat,current_latitude,current_longitude;
    float lon,fVal,fVal1;
    updateRequest *updateRequestObj;
    NSString *useraddress;
    
}

- (IBAction)btngetDirection:(id)sender;

- (IBAction)btnArrived:(id)sender;

@property GMSMarker*marker;
@property NSString *reqid2;
@property NSArray *waypoints_,*waypointStrings_;
@property GMSMapView *mapView;
@property(nonatomic, strong) CLLocationManager *locationManager;
-(void)recivedResponce;
@end
