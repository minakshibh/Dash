//
//  confirmServiceViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "confirmServiceViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "customerRatingViewController.h"

@interface confirmServiceViewController ()

@end

@implementation confirmServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayData
{
    //get request id through notifications
    webservice = 1;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* getrequestID;
    if ([_pref isEqualToString:@"yes"]) {
        getrequestID=[userDefaults valueForKey:@"Service_Pref_id"];
    }else
    {
    getrequestID =[userDefaults stringForKey:@"cust_reg_id"];
    }
    
    NSString*_postData = [NSString stringWithFormat:@"requested_id=%@",getrequestID];
   
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
- (IBAction)btnConfirmServices:(id)sender {
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* serviceID=[userDefaults stringForKey:@"cust_reg_id"];
    
    updateRequestObj = [[updateRequest alloc]  init];
    
    
    NSString *state= @"ConfirmService";
    NSString *serviceID1 = serviceID;
    [[NSUserDefaults standardUserDefaults]setValue:serviceID1 forKey:@"Service_Pref_id"];
    [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];

    
    [updateRequestObj updateRequestStatus:@"ConfirmService" delegate:self service_id:serviceID startPic:@"" endPic:@""];
}
-(void)recivedResponce{
    updateRequestObj = [[updateRequest alloc]  init];
    NSString* status = [updateRequestObj statusValue];
    NSLog(@"%@", status);
    if ([status isEqualToString:@"True"])
    {
        
        customerRatingViewController *ratingVC = [[customerRatingViewController alloc] initWithNibName:@"customerRatingViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.navigator pushViewController:ratingVC animated:NO];
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
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"No responce from server. Try Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
        //NSString *resultStr=[userDetailDict valueForKey:@"result"];
        if ([messageStr isEqualToString:@"Success"]) {
            NSArray *data1 = [[NSArray alloc]init];
            data1 = [userDetailDict valueForKey:@"request_data"];
            data = [data1 objectAtIndex:0];
           
            if(webservice == 1)
            {
            NSString*beforImg=[NSString stringWithFormat:@"%@",[data objectForKey:@"bfr_img_url"]];
           NSString*strUrl1=[NSString stringWithFormat:@"%@",[data objectForKey:@"after_img_url"]];
                
//                NSString *foralert = [NSString stringWithFormat:@"After Image : %@ ; ENDED",[data objectForKey:@"after_img_url"]];
//                
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"AfterImage" message:foralert delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
//                [alert show];
            
            
//            //show image 1
//            NSURL *imageURL1 = [[NSURL alloc]init];
//            imageURL1 = [NSURL URLWithString:strUrl1];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL1];
//            afterImage.image   = [UIImage imageWithData:imageData];
//            
//            
//            //show image 2
//            NSURL *imageurl = [[NSURL alloc]init];
//            imageurl = [NSURL URLWithString:strUrl2];
//            NSData *imageData2 = [NSData dataWithContentsOfURL:imageurl];
//            beforeImage.image  = [UIImage imageWithData:imageData2];
                
                strUrl1 = [strUrl1 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

                NSURL *imageURL = [NSURL URLWithString:strUrl1];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        afterImage.image = [UIImage imageWithData:imageData];
                    });
                });
                
                
                beforImg = [beforImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

                NSURL *beforImgURL = [NSURL URLWithString:beforImg];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *beforImgData = [NSData dataWithContentsOfURL:beforImgURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        beforeImage.image = [UIImage imageWithData:beforImgData];
                    });
                });

                
                
           
           // [self before_img:beforeImage AndUrl:strUrl2];
            
          //  [self getAfterImage];
            }
            if (webservice ==2 ) {
                
                NSString*strUrl1=[NSString stringWithFormat:@"%@",[data objectForKey:@"after_img_url"]];
                
                NSURL *imageURL1 = [[NSURL alloc]init];
                imageURL1 = [NSURL URLWithString:strUrl1];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL1];
                afterImage.image   = [UIImage imageWithData:imageData];
            }
        }
    }
    [kappDelegate HideIndicator];
    
    
    
}
@end
