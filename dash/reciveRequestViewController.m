//
//  reciveRequestViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 5/13/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "reciveRequestViewController.h"
#import "DetailerFirastViewController.h"
#import "loginViewController.h"
#import "MyprofileViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "WorkSamplesViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "reciveRequestdetailViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "arrivalViewController.h"
#import "assignmentsViewController.h"
#import "arrivalViewController.h"
#import "reciveRequestdetailViewController.h"
#import "assignmentObj.h"

@interface reciveRequestViewController ()

@end

@implementation reciveRequestViewController
NSString *ifaccepted,*request;
assignmentObj *assignmentOC;

@synthesize reqid1;
- (void)viewDidLoad {
    webservices = 0;
    ifaccepted = nil;
    assignmentOC = [[assignmentObj alloc]init];
    [super viewDidLoad];
     [self getCustomerInfo];
    
      [self.navigationController setNavigationBarHidden:YES];
    
    btnmenu.hidden = YES;
    menuicon.hidden = YES;
    [self addMapView];
    sideView.hidden=YES;
    NSString *onlineStatus = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Offline/Online Status"]];
    if ([onlineStatus isEqualToString:@"Online"]) {
        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
    }else{
        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
    }

    nameLbl.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    if (IS_IPHONE_4_OR_LESS)
    {
       [tapToacceptViewIphone5 setFrame:CGRectMake(10, 100, tapToacceptViewIphone5.frame.size.width, tapToacceptViewIphone5.frame.size.height)];
        [self.view addSubview:tapToacceptViewIphone5];
    }
    if (IS_IPHONE_5)
    {
        [tapToacceptViewIphone5 setFrame:CGRectMake(15, 100, tapToacceptViewIphone5.frame.size.width, tapToacceptViewIphone5.frame.size.height)];
        [self.view addSubview:tapToacceptViewIphone5];
    }
    if (IS_IPHONE_6)
    {
       [tapToAcceptView setFrame:CGRectMake(50, 100, tapToAcceptView.frame.size.width, tapToAcceptView.frame.size.height)];
        [self.view addSubview:tapToAcceptView];
    }
    if (IS_IPHONE_6P)
    {
        [tapToAcceptView setFrame:CGRectMake(50, 100, tapToAcceptView.frame.size.width, tapToAcceptView.frame.size.height)];
        [self.view addSubview:tapToAcceptView];
    }

    
    
    double value = self.view.frame.size.height - userRequestView.frame.size.height;
    NSLog(@"Height,..... %f",value);
    if (IS_IPHONE_4_OR_LESS)
    {
        [userRequestViewIphone5 setFrame:CGRectMake(0, self.view.frame.size.height - userRequestViewIphone5.frame.size.height , userRequestViewIphone5.frame.size.width, userRequestViewIphone5.frame.size.height)];
        [self.view addSubview:userRequestViewIphone5];
    }
    if (IS_IPHONE_5)
    {
        [userRequestViewIphone5 setFrame:CGRectMake(0, self.view.frame.size.height - userRequestViewIphone5.frame.size.height , userRequestViewIphone5.frame.size.width, userRequestViewIphone5.frame.size.height)];
        [self.view addSubview:userRequestViewIphone5];
    }
    if (IS_IPHONE_6)
    {
        [userRequestView setFrame:CGRectMake(0, self.view.frame.size.height - userRequestView.frame.size.height , userRequestView.frame.size.width, userRequestView.frame.size.height)];
        [self.view addSubview:userRequestView];
    }
    if (IS_IPHONE_6P)
    {
        [userRequestView setFrame:CGRectMake(0, self.view.frame.size.height - userRequestView.frame.size.height , userRequestView.frame.size.width, userRequestView.frame.size.height)];
        [self.view addSubview:userRequestView];
    }

    [userRequestView setFrame:CGRectMake(0, self.view.frame.size.height - userRequestView.frame.size.height , userRequestView.frame.size.width, userRequestView.frame.size.height)];
    [self.view addSubview:userRequestView];
    
//   UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
//   singleTap.numberOfTapsRequired = 1;
//    [self.view setUserInteractionEnabled:YES];
//   [userRequestView addGestureRecognizer:singleTap];


    tapToacceptViewIphone5.layer.borderColor = [UIColor clearColor].CGColor;
    tapToacceptViewIphone5.layer.borderWidth = 1.5;
    tapToacceptViewIphone5.layer.cornerRadius = 6.0;
    [tapToacceptViewIphone5 setClipsToBounds:YES];
    
    tapToAcceptView.layer.borderColor = [UIColor clearColor].CGColor;
    tapToAcceptView.layer.borderWidth = 1.5;
    tapToAcceptView.layer.cornerRadius = 6.0;
    [tapToAcceptView setClipsToBounds:YES];
    
    profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    profileImg.layer.borderWidth = 1.5;
    profileImg.layer.cornerRadius = 10.0;
    [profileImg setClipsToBounds:YES];
    
    [DownTimer invalidate];
    if (_timer > 0) {
        TimerValue = [_timer intValue];
        timerLbl.hidden = NO;
        timerLbl1.hidden = NO;
        timerLbl.text = _timer;
        timerLbl1.text = _timer ;
    }else
    {
    TimerValue=20;
    }
    
    DownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:YES];
    
    
    [super didReceiveMemoryWarning];
    // Do any additional setup after loading the view from its nib.
}

-(void)getCustomerInfo
{
    webservices = 11;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *reqID = [user valueForKey:@"reg_id"];
     [kappDelegate ShowIndicator];
    NSString*_postData = [NSString stringWithFormat:@"requested_id=%@",reqID];
    
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



-(void)viewWillAppear:(BOOL)animated{
      [self fetchProfileInfoFromDatabase];
    if(_timer > 0 )
    {
        timerLbl.hidden = NO;
        timerLbl1.hidden = NO;
    }
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

-(void)DownTimeCal
{
    TimerValue=TimerValue-1;
    timerLbl.text=[NSString stringWithFormat:@"%d",TimerValue];
    timerLbl1.text = [NSString stringWithFormat:@"%d",TimerValue];
    if (TimerValue==0)
    {
        tapToAcceptView.hidden = YES;
        [DownTimer invalidate];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You missed a request!" message:@"You did not attempt to accept this request." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag=1;
        
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        [DownTimer invalidate];
        DetailerFirastViewController*myProfile = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
        [self.navigationController pushViewController:myProfile animated:NO];
    }
    if(alertView.tag == 2)
    {
        if (buttonIndex == alertView.cancelButtonIndex) {
            DetailerFirastViewController *obj = [[DetailerFirastViewController alloc]initWithNibName:@"DetailerFirastViewController" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
 
        }else{
            
            assignmentsViewController* obj = [[assignmentsViewController alloc]initWithNibName:@"assignmentsViewController" bundle:nil];
            obj.triggerValue = @"detailer";
            obj.timing = @"upcoming";
            obj.from_reciveRequest = @"yes";
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
}

-(void)tapDetected{
    
    [kappDelegate ShowIndicator];
    [DownTimer invalidate];
    webservices = 1;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* reqid=[userDefaults stringForKey:@"reg_id"];
    NSLog(reqid,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
    NSString *userloginid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString*_postData = [NSString stringWithFormat:@"service_id=%@&detailerId=%@&status=%@",reqid,userloginid,@"Accepted"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/accept-service.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //mapView.settings.myLocationButton = YES;
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
- (IBAction)myWorkSamples:(id)sender {
    [DownTimer invalidate];
    WorkSamplesViewController *workSamples=[[WorkSamplesViewController alloc]initWithNibName:@"WorkSamplesViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:workSamples animated:YES];
    
}


- (IBAction)logOutBttn:(id)sender {
    [DownTimer invalidate];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"role"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    
    [self deletDataFromDatabase];
    
    loginViewController*loginVC=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:[NSBundle mainBundle]];
    [DownTimer invalidate];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (IBAction)viewProfileBttn:(id)sender {
    [DownTimer invalidate];
    MyprofileViewController*myProfile = [[MyprofileViewController alloc] initWithNibName:@"MyprofileViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
}

- (IBAction)workSamples:(id)sender {
    [DownTimer invalidate];
    uploadWorkSamplesViewController *workSamples=[[uploadWorkSamplesViewController alloc]initWithNibName:@"uploadWorkSamplesViewController" bundle:[NSBundle mainBundle]];
    workSamples.trigger=@"add";
    workSamples.backBtnHiden=@"NO";
    [self.navigationController pushViewController:workSamples animated:YES];
}

- (IBAction)menuBttn:(id)sender
{
    
    if (sideView.frame.origin.x==0)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             //   sideView.hidden=YES;
             [self.view bringSubviewToFront:sideView];
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
    }
}


- (IBAction)homeBttn:(id)sender {
    [DownTimer invalidate];
    DetailerFirastViewController*myProfile = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
    
}

- (IBAction)tapToAcceptBtnAction:(id)sender {
    
   [self tapDetected];
   
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
- (IBAction)userInfo:(id)sender {
    [DownTimer invalidate];
    reciveRequestdetailViewController *obj= [[reciveRequestdetailViewController alloc] initWithNibName:@"reciveRequestdetailViewController" bundle:nil];
    obj.assignmentOC = assignmentOC;
    obj.detailerEnd_UserInfo = @"yes";
    obj.timervalue =[NSString stringWithFormat:@"%d",TimerValue];
    obj.now_later = request;
    TimerValue = -1;
    //obj.now_later = @"now";
    
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)userInfo1:(id)sender {
    [DownTimer invalidate];
    reciveRequestdetailViewController *obj= [[reciveRequestdetailViewController alloc] initWithNibName:@"reciveRequestdetailViewController" bundle:nil];
    obj.assignmentOC = assignmentOC;
    obj.detailerEnd_UserInfo = @"yes";
    obj.timervalue =[NSString stringWithFormat:@"%d",TimerValue];
    obj.now_later = request;
        TimerValue = -1;
    //obj.now_later = @"now";
    
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)goOnlineBtnAction:(id)sender {
    if ([goOnlineBtn.titleLabel.text isEqualToString:@"Go Online"]) {
        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
        [self  onlineStatus:@"Online"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Online" forKey:@"Offline/Online Status"];
    }else{
        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
        [self  onlineStatus:@"Offline"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Offline" forKey:@"Offline/Online Status"];
    }
    
}
-(void) onlineStatus:(NSString*) statusStr
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    
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
-(void)checkForNow
{
    
        webservices = 2;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* strDefSetting=[userDefaults stringForKey:@"reg_id"];
        
        NSString*_postData = [NSString stringWithFormat:@"requested_id=%@",strDefSetting];
        
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
     [kappDelegate HideIndicator];
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        
        if(webservices == 1){
            if (webservices == 1 && [messageStr isEqualToString:@"Success"] && [request isEqualToString:@"now"])
            {
                // alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                // [alert show];
                
                arrivalViewController *arrivalVC = [[arrivalViewController alloc] initWithNibName:@"arrivalViewController" bundle:nil];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString* strDefSetting=[userDefaults stringForKey:@"reg_id"];
                arrivalVC.reqid2 = strDefSetting;
                
                NSString *state= @"Accept";
                NSString *serviceID = strDefSetting;
                [[NSUserDefaults standardUserDefaults]setValue:serviceID forKey:@"Service_Pref_id"];
                [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];

                
                
                [DownTimer invalidate];
                [appDelegate.navigator pushViewController:arrivalVC animated:NO];
                
                
                
                
                // webservices = nil;
                
            }
            if([request isEqualToString:@"later"]){
                NSString *name = [NSString stringWithFormat:@"Hi,%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
                
                UIAlertView *alert6 = [[UIAlertView alloc]initWithTitle:name message:@"This assignment is saved, want to go to assignment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert6.tag = 2;
                [alert6 show];
            }
        }

        if(webservices == 2)
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            NSString *resultStr=[userDetailDict valueForKey:@"result"];
            	if([messageStr isEqualToString:@"Success"])
                {
                    NSArray *data1 = [[NSArray alloc]init];
                    data1 = [userDetailDict valueForKey:@"request_data"];
                   NSDictionary *data = [data1 objectAtIndex:0];
                   userRequestNow = [data valueForKey:@"later"];
                    request= [data valueForKey:@"later"];
                    
                    NSLog(@"User want to do it now");
                   // webservices = nil;
                   

                }
        }
    if(webservices == 11 && [messageStr isEqualToString:@"Success"])
        {   NSArray *data1 = [[NSArray alloc]init];
            data1 = [userDetailDict valueForKey:@"request_data"];
            NSDictionary *data = [data1 objectAtIndex:0];
            
            lblAddress.text = [data valueForKey:@"address"];
            lblAddress1.text = [data valueForKey:@"address"];
            
            
            
            NSString *carinfo = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@",[data valueForKey:@"vehicleColor"],[data valueForKey:@"vehicleNo"],[data valueForKey:@"vehicleMake"],[data valueForKey:@"vehicleModal"]];
            lblcarInfo.text = carinfo;
            lblcarInfo1.text =carinfo;
            

                //---check for time-----notification is older
                
                NSString* dateStr = [data valueForKey:@"time"];
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSDate *date1 = [dateFormatter dateFromString:dateStr];
                date1 = [date1 dateByAddingTimeInterval:55];
                
                NSString *date2str = [dateFormatter stringFromDate:[NSDate date]];
                NSDate *date2 = [dateFormatter dateFromString:date2str];
                
                
                NSComparisonResult result = [date2 compare:date1];
                if(result == NSOrderedDescending)
                {
                    
                    [DownTimer invalidate];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Time Out" message:@"You missed a request!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    [DownTimer invalidate];
                    DetailerFirastViewController*myProfile = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
                    [self.navigationController pushViewController:myProfile animated:NO];
                    return;
                    
                }
                //---check for time-----
                

            
            
            NSString *time = [data valueForKey:@"time"];
            NSArray *arr = [time componentsSeparatedByString:@" "];
            if([[data valueForKey:@"later"] isEqualToString:@"now"])
            {
                lblTime.text = @"now";
                lblTime1.text = @"now";
            }else {
            lblTime.text = [arr objectAtIndex:1];
            lblTime1.text = [arr objectAtIndex:1];
            }
            
            Username.text = [data valueForKey:@"customer_name"];
            usernam1.text = [data valueForKey:@"customer_name"];
            
            NSURL *imageURL = [NSURL URLWithString:[data valueForKey:@"customer_image"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            customerImage.image = [UIImage imageWithData:imageData];
            customerImage1.image = [UIImage imageWithData:imageData];
            
            request = [NSString stringWithFormat:@"%@",[data valueForKey:@"later"]];
            
            assignmentOC.requestId =[data valueForKey:@"customer_name"];
           
             assignmentOC.requestId = [data valueForKey:@"ID"];
             assignmentOC.address = [data valueForKey:@"address"];
             assignmentOC.after_img_url = [data valueForKey:@"after_img_url"];
             assignmentOC.bfr_img_url = [data valueForKey:@"bfr_img_url"];
             assignmentOC.cancelled_detailer = [data valueForKey:@"cancelled_detailer"];
             assignmentOC.customer_id = [data valueForKey:@"customer_id"];
             assignmentOC.detailer_ID = [data valueForKey:@"detailer_ID"];
             assignmentOC.image = [data valueForKey:@"image"];
             assignmentOC.later = [data valueForKey:@"later"];
             assignmentOC.latitude = [data valueForKey:@"latitude"];
             assignmentOC.longitude = [data valueForKey:@"longitude"];
             assignmentOC.payment_mode = [data valueForKey:@"payment_mode"];
             assignmentOC.requested_detailer = [data valueForKey:@"customer_name"];
             assignmentOC.requested_time = [data valueForKey:@"requested_time"];
             assignmentOC.service_status = [data valueForKey:@"service_status"];
             assignmentOC.service_type_id = [data valueForKey:@"service_type_id"];
             assignmentOC.time = [data valueForKey:@"time"];
             assignmentOC.vehicleColor = [data valueForKey:@"vehicleColor"];
             assignmentOC.vehicleMake = [data valueForKey:@"vehicleMake"];
             assignmentOC.vehicleModal = [data valueForKey:@"vehicleModal"];
             assignmentOC.vehicleNo = [data valueForKey:@"vehicleNo"];     assignmentOC.detailer_name = [data valueForKey:@"detailer_name"];
             assignmentOC.detailer_image = [data valueForKey:@"detailer_image"];
             assignmentOC.cust_name = [data valueForKey:@"customer_name"];             assignmentOC.cust_rate = [data valueForKey:@"cust_rate"];
             assignmentOC.dist_rate = [data valueForKey:@"customer_image"];
            assignmentOC.special_Requirement = [data valueForKey:@"special_requirement"];
            
            [self checkForNow];
  }
    }
    [kappDelegate HideIndicator];
}

@end
