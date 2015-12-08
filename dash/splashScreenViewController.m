//
//  splashScreenViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "splashScreenViewController.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "RegisterVerificationViewController.h"
#import "homeViewViewController.h"
#import "DetailerFirastViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@interface splashScreenViewController ()

@end

@implementation splashScreenViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
    [self displayData];
}
-(void)displayData
{
    
    NSString*_postData = [NSString stringWithFormat:@""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/get-skills.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (void)presentnextView
{
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"view" ]isEqualToString:@"verifyView"])
    {
        RegisterVerificationViewController *registrVC = [[RegisterVerificationViewController alloc]initWithNibName:@"RegisterVerificationViewController" bundle:nil];
        [self.navigationController pushViewController:registrVC animated:YES];
    }
    else{
        NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
        if ([userId isKindOfClass:[NSNull class]])

        {
            userId=@"";
        }
        if( userId.length==0)
        {
            
            homeViewViewController *homeVc = [[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:nil];
            [self.navigationController pushViewController:homeVc animated:YES];
            
//            loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
//            [self.navigationController pushViewController:loginVC animated:YES];
        }
        else{
          
            
            NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
            
            
            if ([role isEqualToString:@"customer"])
            {
                homeViewViewController *homeVc = [[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:nil];
                [self.navigationController pushViewController:homeVc animated:YES];          }
            else{
                DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
                [self.navigationController pushViewController:homeVC animated:NO];
            }
        }
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
        NSString *messagestr = [userDetailDict valueForKey:@"message"];
        if ([messagestr isEqualToString: @"Success"]) {
            
            NSArray *dataarray = [userDetailDict valueForKey:@"vehicle_type"];
            
            NSArray *data_id = [dataarray valueForKey:@"ID"];
            NSArray *vehicleDesc = [dataarray valueForKey:@"vehicleDesc"];
            
            [[NSUserDefaults standardUserDefaults]setObject:data_id forKey:@"get_available_skills_id"];
            [[NSUserDefaults standardUserDefaults]setObject:vehicleDesc forKey:@"get_available_skills_vehicleDesc"];
        }
    }
}
@end
