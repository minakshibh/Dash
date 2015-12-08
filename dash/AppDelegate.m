//
//  AppDelegate.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "AppDelegate.h"
#import "splashScreenViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "reciveRequestViewController.h"
#import "notificationViewController.h"
#import "ratingViewController.h"
#import "PayPalMobile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize serviceTypeList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    display=0;
    [self createCopyOfDatabaseIfNeeded];
    count = 0;
    [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"app_open"];
   //[[NSUserDefaults standardUserDefaults ]setValue:@"verifyView" forKey:@"view"];
   // [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"view"];

    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"parvbhaskar@krishnais.com"}];
    
    
    
    serviceTypeList = [[NSMutableArray alloc]init];
    application.applicationIconBadgeNumber = 0;
    
    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUDID=myDevice1.UUIDString;
    NSLog(@"Device udid is %@",deviceUDID);
    
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"UDID"];
    [[NSUserDefaults standardUserDefaults]setValue:deviceUDID forKey:@"UDID"];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
        
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
#endif

    
    
    
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
     //   NSLog(@"Family:'%@'",fontfamilyname);
    }
    [GMSServices provideAPIKey:@"AIzaSyDBw7Hk5wFavLf2RfaTNA7BnT2DirvXeO4"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    
    NSLog(@"%f %f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    splashScreenViewController *splashVC = [[splashScreenViewController alloc]initWithNibName:@"splashScreenViewController" bundle:nil];
    self.navigator = [[UINavigationController alloc] initWithRootViewController:splashVC];
    self.window.rootViewController = self.navigator;
    [self.window makeKeyAndVisible];
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
       // user = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
       // NSLog(@"app recieved notification from remote%@",notification);
        [self application:application didReceiveRemoteNotification:(NSDictionary*)notification];
    }
    count = 1;
    return YES;

}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [kappDelegate HideIndicator];
    // UIApplicationState state = [application applicationState];
    //NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];

    NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
   [self.navigator setNavigationBarHidden:YES animated:YES];
    
    if (self.navigator.navigationBar.hidden == NO)
    {
        // hide the Navigation Bar
        [self.navigator setNavigationBarHidden:YES animated:YES];
    }
    
    if ([role isEqualToString:@"customer"])
    {
     //   UIApplicationState state = [application applicationState];
    //    if (state == UIApplicationStateActive)
   //     {
        if(count >0)
        {
             [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"app_open"];
        }
       
            
            NSDictionary *message  = [userInfo valueForKey:@"aps"];
            NSString *regid =[message valueForKey:@"request_id"];
            [[NSUserDefaults standardUserDefaults]setValue:regid forKey:@"cust_reg_id"];
            
                msgStatus = [message valueForKey:@"alert"];
            
            
                NSArray* foo = [msgStatus componentsSeparatedByString:@" "];
                NSString* name = [foo objectAtIndex: 0];
                [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"cust_dis_nam"];
                [[NSUserDefaults standardUserDefaults]setValue:msgStatus forKey:@"cust_dis_msg"];
            
            NSString *state= msgStatus;
            NSString *serviceID = regid;
        
        if([msgStatus rangeOfString:@"available right now" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"has requested you to" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"has confirmed your service" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"requested you to service" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            
           
        }else{
            [[NSUserDefaults standardUserDefaults]setValue:serviceID forKey:@"Service_Pref_id"];
            [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];
        }
         NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSUserDefaults *noti = [NSUserDefaults standardUserDefaults];
            NSString *noti_allow = [noti valueForKey:@"notification_allow"];
            if([noti_allow isEqualToString:@"yes"])
            {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name  message:msgStatus delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            }
             if ([msgStatus rangeOfString:@"The detailer would come to you" options:NSCaseInsensitiveSearch].location != NSNotFound)
             {
                 NSString *name = [NSString stringWithFormat:@"Hi,%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
                 UIAlertView *alert8 = [[UIAlertView alloc]initWithTitle:name message:msgStatus delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert8 show];
                 
             }else if([msgStatus rangeOfString:@"has confirmed your service" options:NSCaseInsensitiveSearch].location != NSNotFound)
             {
                 
             }else if([msgStatus rangeOfString:@"contact another detailer" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"available right now" options:NSCaseInsensitiveSearch].location != NSNotFound)
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Dash" message:msgStatus delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
                 return;
                 
             }else if([msgStatus rangeOfString:@"arriving at" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"arrived at" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"has started the service" options:NSCaseInsensitiveSearch].location != NSNotFound || [msgStatus rangeOfString:@"has completed the" options:NSCaseInsensitiveSearch].location != NSNotFound)
             {
                 
           
            notificationViewController *obj3 = [[notificationViewController alloc]initWithNibName:@"notificationViewController" bundle:nil];
            
            [self.navigator pushViewController:obj3 animated:nil];
             }

    }
    else  if ([role isEqualToString:@"detailer"])
    {
        // [self DisableView];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
      
  //      UIApplicationState state = [application applicationState];
 //       if (state == UIApplicationStateActive) {
           NSDictionary *message  = [userInfo valueForKey:@"aps"];
           NSString *regid =[message valueForKey:@"request_id"];
           
            msgStatus = [message valueForKey:@"alert"];
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""  message:msgStatus delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
           // [alert show];
            
           [[NSUserDefaults standardUserDefaults]setValue:regid forKey:@"reg_id"];
//           // NSLog(regid);
//            NSArray* foo = [msgStatus componentsSeparatedByString:@" "];
//            
//            
//            for (int i=0; i<foo.count; i++) {
//                if ([[foo objectAtIndex:i]isEqualToString:@"confirmed"]) {
//                    msgSuccess = [foo objectAtIndex:i];
//                }
//            }
         // if ([msgSuccess isEqualToString:@"confirmed"])
  
        if([msgStatus rangeOfString:@"has confirmed your service" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            msgStatus = @"";
            ratingViewController *myProfile = [[ratingViewController alloc] initWithNibName:@"ratingViewController" bundle:[NSBundle mainBundle]];
            [self.navigator pushViewController:myProfile animated:YES];
        }
        if ([msgStatus rangeOfString:@"requested you to service" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            reciveRequestViewController*myProfile = [[reciveRequestViewController alloc] initWithNibName:@"reciveRequestViewController" bundle:[NSBundle mainBundle]];
            
            [navigationController pushViewController:myProfile animated:YES];
        }
        else{
        }
 //       }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)_deviceToken
{
    
    // Get a hex string from the device token with no spaces or < >
    NSString*deviceToken = [[[[_deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Device Token: %@", deviceToken);
    
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]setValue:deviceToken forKey:@"deviceToken"];
    
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self FadeView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"noti_rating"];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Defined Functions

// Function to Create a writable copy of the bundled default database in the application Documents directory.
- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"Dash.sqlite"];
    NSLog(@"db path %@", dbPath);
    NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:dbPath]);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Dash.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        //NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:defaultDBPath]);
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        } else {
            NSLog(@"DB copied.");
        }
    }else {
        NSLog(@"DB exists, no need to copy.");
    }
}

#pragma mark - Show Indicator

-(void)ShowIndicator
{
  
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (IS_IPHONE_5 )
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 700)];

    }
    else if (IS_IPHONE_4_OR_LESS )
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
        
    }
    else if (IS_IPHONE_6)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 700)];

    }
    else if(IS_IPHONE_6P)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 800)];

    }
    
      
    DisableView.backgroundColor=[UIColor blackColor];
    DisableView.alpha=0.5;
    [self.window addSubview:DisableView];
    activityIndicatorObject.color=[UIColor grayColor];
    [DisableView addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];
}

#pragma mark - Hide Indicator

-(void)HideIndicator
{
    [activityIndicatorObject stopAnimating];
    [DisableView removeFromSuperview];
    
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
             //             cityStr=[placemark.addressDictionary valueForKey:@"City"];
             //             countryStr=[placemark.addressDictionary valueForKey:@"Country"];
             //             currentAddressStr=[placemark.addressDictionary valueForKey:@"SubLocality"];
             //             NSArray* addressArray=[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
             //             NSLog(@"array count .. %lu",(unsigned long)addressArray.count);
             //             currntFulAdress= [NSString stringWithFormat:@"%@",addressArray];
             //             if (addressArray.count>0) {
             //                 for (int j=0;j<addressArray.count; j++)
             //                 {
             //                     if (j==0)
             //                     {
             //                         currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
             //                     }
             //                     else
             //                     {
             //                         if (currntFulAdress.length==0) {
             //                             currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
             //
             //                         }
             //                         else
             //                         {
             //                             currntFulAdress=[NSString stringWithFormat:@"%@,%@",currntFulAdress,[addressArray objectAtIndex:j]];
             //                         }
             //                     }
             //                 }
         }
         //             if (currentAddressStr.length==0) {
         //                 //currntFulAdress=[NSString stringWithFormat:@"%@",currntFulAdress];
         //
         //             }
         //             else{
         //                 //currntFulAdress=[NSString stringWithFormat:@"%@ ,%@",currentAddressStr,currntFulAdress];
         //
         //             }
         //
         //             NSLog(@"full address %@",currntFulAdress);
         
         [self updatelocation];
     }];
    
}
-(void) updatelocation
{
    
    
  //  [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    
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
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    [self updatelocation];
}
@end
