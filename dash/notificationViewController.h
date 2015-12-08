//
//  notificationViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationViewController : UIViewController
{
    float lat,lon;
    GMSMapView *mapView;
    GMSMarker*marker;
    IBOutlet UILabel *lblmsg;
    IBOutlet UILabel *lblname;
    IBOutlet UIButton *distimage;
    NSMutableData*webData;
    NSDictionary* data;
    IBOutlet UIImageView *detimage;
    NSString *value;
}
- (IBAction)showDetailerDetail:(id)sender;
@property NSString *pref;
@property(nonatomic, strong) CLLocationManager *locationManager;
@end
