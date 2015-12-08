//
//  DetailerFirastViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 07/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "DetailerFirastViewController.h"
#import "loginViewController.h"
#import "MyprofileViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "WorkSamplesViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "reciveRequestViewController.h"
#import "homeViewViewController.h"
#import "assignmentsViewController.h"
#import "reciveRequestdetailViewController.h"
#import "startServiceViewController.h"
#import "arrivalViewController.h"
#import "startServiceViewController.h"
#import "endServiceViewController.h"
#import "waitingViewController.h"
#import "ratingViewController.h"
#import "reciveRequestViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface DetailerFirastViewController ()

@end

@implementation DetailerFirastViewController

- (void)viewDidLoad {
    
    
     [self.view addSubview:_testView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.testView addGestureRecognizer:singleTapGestureRecognizer];
    
    [super viewDidLoad];
    [self registerDevice];
     [self addMapView];
    sideView.hidden=YES;

    NSString *onlineStatus = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Offline/Online Status"]];
    
    
    if ([onlineStatus isEqualToString:@"Online"]) {
        
        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
    }else{
        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
    
    }
    profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    profileImg.layer.borderWidth = 1.5;
    profileImg.layer.cornerRadius = 10.0;
    [profileImg setClipsToBounds:YES];
    
   
   
    [timer invalidate];
    timer= [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshCurrent_Location) userInfo:nil repeats:YES];
    
    
    
    [super didReceiveMemoryWarning];
    [self FadeView];
    
    
    if (![onlineStatus isEqualToString:@"Online"])
    {   NSString *msg = @"You Seems to be Offline";
        NSString *name = [NSString stringWithFormat:@"Hi,%@!",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:name message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Go Online", nil];
        alert.tag=1;
        [alert show];
    }

//    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
//                                      initWithTarget:self action:@selector(didTapMap)];
//    [mapView addGestureRecognizer:tapRec];
  
}

//-(void)didTapMap
//{
//    NSLog(@"______--------_______");
//}
-(NSDate *) get24HourFormat:(NSDate *) date{
    return date;
}
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (sideView.frame.origin.x==0)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             //   sideView.hidden=YES;
             
             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = -239;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
    }
     Downtimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:NO];
    
   
    
}
-(void)DownTimeCal
{
    [self.view bringSubviewToFront:mapView];
    [mapView bringSubviewToFront:mapView];
    
}
-(void)refreshCurrent_Location
{   lat = 0.0;
    lon =  0.0;
    [mapView clear];
    lat=self.locationManager.location.coordinate.latitude;
    lon=self.locationManager.location.coordinate.longitude;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat ,lon );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.map = mapView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        if (buttonIndex!=alertView.cancelButtonIndex) {
            [self  onlineStatus:@"Online"];
            }

        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    nameLbl.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *state = [userdefault valueForKey:@"Service_Pref_state"];
    NSString *Request_ID = [userdefault valueForKey:@"Service_Pref_id"];
    if([state isEqualToString:@"Accept"])
    {
        arrivalViewController *obj = [[arrivalViewController alloc]initWithNibName:@"arrivalViewController" bundle:nil];
        obj.reqid2 = Request_ID;
        [timer invalidate];

        [self.navigationController pushViewController:obj animated:NO];
    }
    if([state isEqualToString:@"Arriving"])
    {
        arrivalViewController *obj = [[arrivalViewController alloc]initWithNibName:@"arrivalViewController" bundle:nil];
        obj.reqid2 = Request_ID;
        [timer invalidate];

        [self.navigationController pushViewController:obj animated:NO];
        
    }
    if([state isEqualToString:@"Arrived"])
    {
        startServiceViewController *obj = [[startServiceViewController alloc]initWithNibName:@"startServiceViewController" bundle:nil];
        obj.reqid = Request_ID;
        [timer invalidate];

        [self.navigationController pushViewController:obj animated:NO];
        
    }
    if([state isEqualToString:@"StartService"])
    {
        endServiceViewController *obj = [[endServiceViewController alloc]initWithNibName:@"endServiceViewController" bundle:nil];
        obj.reqid = Request_ID;
        obj.pref = @"yes";
        [timer invalidate];

        [self.navigationController pushViewController:obj animated:NO];
    }
    if([state isEqualToString:@"EndService"])
    {
        waitingViewController *obj = [[waitingViewController alloc]initWithNibName:@"waitingViewController" bundle:nil];
        [timer invalidate];

        [self.navigationController pushViewController:obj animated:NO];
    }
    if([state isEqualToString:@"confirm_notification"])
    {
        ratingViewController *obj = [[ratingViewController alloc]initWithNibName:@"ratingViewController" bundle:nil];
        obj.status = @"pref";
        obj.req = Request_ID;
        [timer invalidate];

        [self.navigationController pushViewController:obj animated:NO];
    }
    
    
    
    [self fetchProfileInfoFromDatabase];

}
- (void)didReceiveMemoryWarning {
    
  
    // Dispose of any resources that can be recreated.
}
-(void) fetchProfileInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM userProfile where userId=\"%@\" ",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
      //  nameLbl.text =[results stringForColumn:@"name"];
        NSString*imgUrl=[results stringForColumn:@"image"];
        
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                profileImg.image = [UIImage imageWithData:imageData];
            });
        });
    }
    [database close];
}
-(void)deletDataFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM locationsList"];
    [database executeUpdate:queryString1];
    
    
    NSString *queryString2 = [NSString stringWithFormat:@"Delete FROM userProfile"];
    [database executeUpdate:queryString2];
    
    NSString *queryString3 = [NSString stringWithFormat:@"Delete FROM vehiclesList"];
    [database executeUpdate:queryString3];
    
    NSString *queryString4 = [NSString stringWithFormat:@"Delete FROM workSamples"];
    [database executeUpdate:queryString4];
    
    [database close];
    
    
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
    
   NSNumber *aNumber = [NSNumber numberWithFloat:lat];
    NSNumber *bNumber = [NSNumber numberWithFloat:lon];

    [[NSUserDefaults standardUserDefaults]setValue:aNumber forKey:@"current_lat"];
    [[NSUserDefaults standardUserDefaults]setValue:bNumber forKey:@"current_lon"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:15];
    
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,75, self.view.frame.size.width, self.view.frame.size.height-70) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,65,self.view.frame.size.width, self.view.frame.size.height-65) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,75, self.view.frame.size.width, self.view.frame.size.height-75) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,75, self.view.frame.size.width, self.view.frame.size.height-75) camera:camera];
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
    
    [self.view bringSubviewToFront:sideView];
    [mapView bringSubviewToFront:sideView];

    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat ,lon );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.map = mapView;
    
    
}


- (IBAction)blockedList:(id)sender {
    assignmentsViewController *vehiclelistVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
    
    vehiclelistVC.timing = @"BlockedList";
    vehiclelistVC.detail = @"fromDetailer";
    [timer invalidate];

    [self.navigationController pushViewController:vehiclelistVC animated:YES];

    
}

- (IBAction)myWorkSamples:(id)sender {

    WorkSamplesViewController *workSamples=[[WorkSamplesViewController alloc]initWithNibName:@"WorkSamplesViewController" bundle:[NSBundle mainBundle]];
    [timer invalidate];

    [self.navigationController pushViewController:workSamples animated:YES];

}


- (IBAction)logOutBttn:(id)sender {
    [self  onlineStatus:@"Offline"];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"role"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Offline/Online Status"];
    [self deletDataFromDatabase];
    
    homeViewViewController*homeVC=[[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:[NSBundle mainBundle]];
    [timer invalidate];

    [self.navigationController pushViewController:homeVC animated:YES];

}

- (IBAction)viewProfileBttn:(id)sender {
    MyprofileViewController*myProfile = [[MyprofileViewController alloc] initWithNibName:@"MyprofileViewController" bundle:nil];
    [timer invalidate];

    [self.navigationController pushViewController:myProfile animated:NO];
}

- (IBAction)workSamples:(id)sender {
    uploadWorkSamplesViewController *workSamples=[[uploadWorkSamplesViewController alloc]initWithNibName:@"uploadWorkSamplesViewController" bundle:[NSBundle mainBundle]];
    workSamples.trigger=@"add";
    workSamples.backBtnHiden=@"NO";
    workSamples.headerLblStr=@"DASH";
    [timer invalidate];

    [self.navigationController pushViewController:workSamples animated:YES];
}

- (IBAction)menuBttn:(id)sender
{
    [mapView bringSubviewToFront:sideView];
    if (sideView.frame.origin.x==0)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
          //   sideView.hidden=YES;

             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = -239;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        Downtimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:NO];
    }
    else{
        
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             sideView.hidden=NO;

             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = 0;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
       
        [self.view bringSubviewToFront:_testView];
        [mapView bringSubviewToFront:_testView];
        
        [self.view bringSubviewToFront:sideView];
        [mapView bringSubviewToFront:sideView];
    }
    
    
}

- (IBAction)homeBttn:(id)sender {
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^
     {
         //   sideView.hidden=YES;
         
         CGRect frame = sideView.frame;
         frame.origin.y = sideView.frame.origin.y;
         frame.origin.x = -239;
         sideView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
}

- (IBAction)serviceHistoryBtnAction:(id)sender
{
    assignmentsViewController *assignmentVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
    assignmentVC.triggerValue = @"detailer";
    assignmentVC.timing = @"past";
    assignmentVC.serviceHistoryUserBlock = @"BlockBtn";
    [timer invalidate];

    [self.navigationController pushViewController:assignmentVC animated:NO];
}


- (IBAction)goOnlineBtnAction:(id)sender
{
    if ([goOnlineBtn.titleLabel.text isEqualToString:@"Go Online"]) {
//        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
        [self  onlineStatus:@"Online"];
//        [[NSUserDefaults standardUserDefaults] setValue:@"Online" forKey:@"Offline/Online Status"];
    }else{
//        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
        [self  onlineStatus:@"Offline"];
//        [[NSUserDefaults standardUserDefaults] setValue:@"Offline" forKey:@"Offline/Online Status"];
    }
    if (sideView.frame.origin.x==0)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             //   sideView.hidden=YES;
             
             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = -239;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
    }
}

- (IBAction)assignmentListBtnAction:(id)sender {
    assignmentsViewController *assignmentVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
    assignmentVC.triggerValue = @"detailer";
    assignmentVC.timing = @"upcoming";
    [timer invalidate];

    [self.navigationController pushViewController:assignmentVC animated:NO];
}
-(void) onlineStatus:(NSString*) statusStr
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    webservice=1;
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@&status=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],statusStr];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/go-offline.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
-(void)FadeView{
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self fetchLocation];
}
-(void) fetchLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    lat=self.locationManager.location.coordinate.latitude;
    lon=self.locationManager.location.coordinate.longitude;
  
    
    
    NSLog(@"%f %f",lat,lon);
    CLLocation *CameraLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    [geocoder1 reverseGeocodeLocation:CameraLocation
                    completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         if (placemarks.count>0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSLog(@"placemark.ISOcountryCode %@",placemark.addressDictionary);
             NSLog(@"placemark.ISOcountryCode %@ %@ %@",[placemark.addressDictionary valueForKey:@"SubLocality"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"Country"]);
             nameStr = [NSString stringWithFormat:@"%@",[placemark.addressDictionary valueForKey:@"City"]];
            
         }
                  [self updatelocation];
     }];
    
}
-(void) updatelocation
{
    
    
    //  [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    webservice= 10;
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@&latitude=%@&longitude=%@&current_city=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],[NSString stringWithFormat:@"%f",lat],[NSString stringWithFormat:@"%f",lon],nameStr];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/update-location.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
            NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",responseString);
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

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    
   // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
   // [alert show];
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
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(result==0)
        { if(webservice==10)
            {
                NSLog(@"Location updated sucessfully");
            }
            
            
            
            if (webservice==1)
            {
                if ([goOnlineBtn.titleLabel.text isEqualToString:@"Go Online"]) {
                    [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
                    [[NSUserDefaults standardUserDefaults] setValue:@"Online" forKey:@"Offline/Online Status"];
                    NSLog(@"Detailer is Online");
                }
                else
                {
                    [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
                    [[NSUserDefaults standardUserDefaults] setValue:@"Offline" forKey:@"Offline/Online Status"];
                }
            }
            else if (webservice==4)
            {
                NSLog(@"token udid userid updated sucessfully");
            }
        }
    }
}

-(void)registerDevice
{
    webservice=4;
    
    NSString*deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    NSLog(deviceToken);
   

    NSString*UDID=[[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];
     NSLog(UDID);
   

    
    NSString*role=@"";
    
    NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
     NSLog(userId);
    if ([userId isKindOfClass:[NSNull class]])
        
    {
        userId=@"";
        
    }
    
    
    if (userId.length!=0)
    {
        NSString* _postData = [NSString stringWithFormat:@"trigger=ios&role=%@&reg_id=%@&user_id=%@&ud_id=%@",role,deviceToken,userId,UDID ];
        
        NSLog(@"data post >>> %@",_postData);
        [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/insert-device.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
}
- (IBAction)button:(id)sender
{
    ratingViewController *myProfile = [[ratingViewController alloc] initWithNibName:@"ratingViewController" bundle:[NSBundle mainBundle]];
    [timer invalidate];
    [self.navigationController pushViewController:myProfile animated:YES];

}


@end
