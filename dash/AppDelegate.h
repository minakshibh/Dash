//
//  AppDelegate.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>

{
UIActivityIndicatorView *activityIndicatorObject;
UIView  *DisableView;
    NSMutableData*webData;
    float lat;
    float lon;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    int display,webservices;
    NSString *nameStr,*msgStatus,*msgSuccess;
    NSDictionary *data,*user;
    int count;
}
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigator;

@property (strong,nonatomic) NSMutableArray *serviceTypeList;
-(void)ShowIndicator;
-(void)HideIndicator;
-(void)FadeView;
@end

