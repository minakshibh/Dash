//
//  ServiceLocationViewController.h
//  dash
//
//  Created by Br@R on 01/06/15.
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
@interface ServiceLocationViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
{
   IBOutlet UITextField *searchLocTXt;
    GMSMapView *mapView_;
    float cur_lat;
    float cur_long;
    IBOutlet UITableView *resultsTableView;
    NSMutableArray*resultLocArray,*locDetailArray;
 
}
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSString *latitudeStr;
@property(nonatomic, strong) NSString *longitudeStr;
@property(nonatomic, strong) NSString *locAddrssStr;

- (IBAction)backBttn:(id)sender;
- (IBAction)searchLocationBttn:(id)sender;
- (IBAction)PlaceSelectedDoneBttn:(id)sender;

@end
