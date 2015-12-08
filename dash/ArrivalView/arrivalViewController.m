//
//  arrivalViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 04/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "arrivalViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "startServiceViewController.h"


@interface arrivalViewController ()

@end

@implementation arrivalViewController
NSString *ifaccepted;
int webservices;
@synthesize reqid2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    marker = [[GMSMarker alloc] init];
    waypointStrings_ = [[NSArray alloc]init];
    waypoints_ = [[NSArray alloc]init];
    
    [self displayData];
    //
}

-(void)displayData
{
    
    NSString*_postData = [NSString stringWithFormat:@"requested_id=%@",reqid2];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/get-request-detail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}
-(void) addMapView{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    lat=self.locationManager.location.coordinate.latitude;
    lon=self.locationManager.location.coordinate.longitude;
    
    NSLog(@"%f %f",lat,lon);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:15];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,168, 300, 217) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,198,300, 258) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(12,233, 350, 300) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(16,256, 385, 337) camera:camera];
    }
    
    // mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    mapView.layer.borderWidth = 1.5;
    
    mapView.layer.cornerRadius = 5.0;
    
    [mapView setClipsToBounds:YES];
    [self.view addSubview:mapView];
    
    //[self.view bringSubviewToFront:sideView];
    //[mapView bringSubviewToFront:sideView];
    
    
    
    marker.position = CLLocationCoordinate2DMake(lat ,lon );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.map = mapView;
}





- (void)addDirections:(NSDictionary *)json {
    
    
    NSArray*array=[json objectForKey:@"routes"];
    NSDictionary *routes;
    if (array.count>0)
    {
        routes= [json objectForKey:@"routes"][0];
    }
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor=[UIColor redColor];
    polyline.strokeWidth=5.0;
    polyline.map = mapView_;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [webData appendData:data1];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    ifaccepted =@"Responce get";
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        NSString *resultStr=[userDetailDict valueForKey:@"result"];
        if ([messageStr isEqualToString:@"Success"]) {
            NSArray *data1 = [[NSArray alloc]init];
            data1 = [userDetailDict valueForKey:@"request_data"];
            data = [data1 objectAtIndex:0];
           
            lblAddress.text = [data valueForKey:@"address"];
            lblUserName.text =[data valueForKey:@"customer_name"];
            
            
            NSString *image = [NSString stringWithFormat:@"%@",[data valueForKey:@"image"]];
            image = [image stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *pictureURL = [NSURL URLWithString:image];
           NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
            userImageView.image = [UIImage imageWithData:imageData];;
            
            lblTime.text = [data valueForKey:@"requested_time"];
            NSString *abc = [NSString stringWithFormat:@"%@ %@ %@", [data valueForKey:@"vehicleColor"],[data valueForKey:@"vehicleMake"], [data valueForKey:@"vehicleModal"],[data valueForKey:@"vehicleNo"]];
            lblCarInfo.text = abc;
            
            lat = [[data valueForKey:@"latitude"] floatValue];
            lon = [[data valueForKey:@"longitude"] floatValue];
            
            useraddress = [data valueForKey:@"address"];
        }
        
        
        
        
    }
    [kappDelegate HideIndicator];
    [self addMapView];
}
- (IBAction)btngetDirection:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* strDefSetting=[userDefaults stringForKey:@"current_lat"];
    NSString* strDefSetting1=[userDefaults stringForKey:@"current_lon"];
    
    
    
    fVal = [strDefSetting floatValue];
      fVal1 = [strDefSetting1 floatValue];
    
    NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",fVal, fVal1, lat, lon];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
 
}

- (IBAction)btnArrived:(id)sender {
    
    //[kappDelegate ShowIndicator];

    updateRequestObj = [[updateRequest alloc]  init];
    
    NSString *state = @"Arrived";
    NSString *serviceID = reqid2;
    
    [[NSUserDefaults standardUserDefaults]setValue:serviceID forKey:@"Service_Pref_id"];
    [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];
    
    [updateRequestObj updateRequestStatus:@"Arrived" delegate:self service_id:reqid2 startPic:@"" endPic:@""];
}
-(void)recivedResponce{
    
    //[kappDelegate HideIndicator];
    
    updateRequestObj = [[updateRequest alloc]  init];
    NSString* status = [updateRequestObj statusValue];
    NSLog(@"%@", status);
    if ([status isEqualToString:@"True"]) {

        startServiceViewController *startVC = [[startServiceViewController alloc] initWithNibName:@"startServiceViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        startVC.reqid = reqid2;
        
        [appDelegate.navigator pushViewController:startVC animated:NO];

        
        
        
        
    }
}
@end
