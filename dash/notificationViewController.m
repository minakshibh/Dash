   //
//  notificationViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "notificationViewController.h"
#import "custEndDetailerDetailViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "confirmServiceViewController.h"
@interface notificationViewController ()

@end

@implementation notificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    NSString* distName;
    NSString* distmsg;
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([_pref isEqualToString:@"yes"])
    {
        distmsg = [userDefaults valueForKey:@"Service_Pref_state"];
        NSArray* foo1 = [distmsg componentsSeparatedByString: @" "];
        distName = [foo1 objectAtIndex:0];
    }else{
    distName=[userDefaults stringForKey:@"cust_dis_nam"];
    distmsg=[userDefaults stringForKey:@"cust_dis_msg"];
    }
    NSArray* foo = [distmsg componentsSeparatedByString: @" "];
    
    
    for (int i=0; i<foo.count; i++)
    {
        if ([[foo objectAtIndex:i]isEqualToString:@"completed"]) {
            value = [foo objectAtIndex:i];
            break;
        }
    }
    
    
    
    lblname.text = distName;
    lblmsg.text = distmsg;
    [self addMapView];
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated
{
    //do not allow notification
    NSString *name = @"no";
    
    NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
    [removeUD removeObjectForKey:@"notification_allow"];
    
    [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"notification_allow"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* custreqid;
    if([_pref isEqualToString:@"yes"])
    {
        custreqid = [userDefaults valueForKey:@"Service_Pref_id"];
    }else
    {
    custreqid =[userDefaults stringForKey:@"cust_reg_id"];
    }
    
    NSString*_postData = [NSString stringWithFormat:@"requested_id=%@",custreqid];
    
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
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,77, 320, self.view.frame.size.height-172) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,72,320, 402) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,84, 378, self.view.frame.size.height-270) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,92, 430, self.view.frame.size.height-220) camera:camera];
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
- (IBAction)showDetailerDetail:(id)sender {
    if ([value isEqualToString:@"completed"]) {
        
        confirmServiceViewController *custserviceVC = [[confirmServiceViewController alloc] initWithNibName:@"confirmServiceViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        custserviceVC.pref = @"yes";
        [appDelegate.navigator pushViewController:custserviceVC animated:NO];
    }else{
        custEndDetailerDetailViewController *custendVC = [[custEndDetailerDetailViewController alloc] initWithNibName:@"custEndDetailerDetailViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        custendVC.pref = @"yes";
        [appDelegate.navigator pushViewController:custendVC animated:NO];

    }
}

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
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        //NSString *resultStr=[userDetailDict valueForKey:@"result"];
        if ([messageStr isEqualToString:@"Success"]) {
            NSArray *data1 = [[NSArray alloc]init];
            data1 = [userDetailDict valueForKey:@"request_data"];
            data = [data1 objectAtIndex:0];
           
            
            //get iamge
            NSString*imgUrl=[data objectForKey:@"detailer_image"];
            NSURL *imageURL = [NSURL URLWithString:imgUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            detimage.image   = [UIImage imageWithData:imageData];
            }
        }
}
@end
