//
//  custEndDetailerDetailViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "custEndDetailerDetailViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@interface custEndDetailerDetailViewController ()

@end

@implementation custEndDetailerDetailViewController
NSString *ifaccepted;


- (void)viewDidLoad {
    [super viewDidLoad];
    beforeImage.hidden = YES;
    [self displayData];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    //to allow notification
    NSString *name = @"yes";
    
    NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
    [removeUD removeObjectForKey:@"notification_allow"];
    [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"notification_allow"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)displayData
{
    //get request id through notifications
    [kappDelegate ShowIndicator];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* getrequestID;
    if ([_pref isEqualToString:@"yes"]) {
        getrequestID = [userDefaults valueForKey:@"Service_Pref_id"];
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
        //NSString *resultStr=[userDetailDict valueForKey:@"result"];
        if ([messageStr isEqualToString:@"Success"]) {
            NSArray *data1 = [[NSArray alloc]init];
            data1 = [userDetailDict valueForKey:@"request_data"];
            data = [data1 objectAtIndex:0];
            
            NSString*detailer_nameStr=[data objectForKey:@"detailer_name"];
            NSString*detailer_addressStr=[data objectForKey:@"detailer_address"];
            if ([detailer_nameStr isKindOfClass:[NSNull class]]) {
                detailer_nameStr=@"";
            }
            if ([detailer_addressStr isKindOfClass:[NSNull class]]) {
                detailer_addressStr=@"";
            }

            lblnam.text = detailer_nameStr;
            lbladd.text  = detailer_addressStr;
            
             
            NSString *now_later = [data objectForKey:@"later"];
            if([now_later isEqualToString:@"now"])
            {
                lbltime.text = [data objectForKey:@"requested_time"];
                
            }else if ([now_later isEqualToString:@"later"])
            {
                lbltime.text = [data objectForKey:@"time"];
            }
            
            
            
            //show image
            NSString*imgUrl=[data objectForKey:@"detailer_image"];
            imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *imageURL = [NSURL URLWithString:imgUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                  distImage.image   = [UIImage imageWithData:imageData];
            
            specialRequirements.text =[data objectForKey:@"special_requirement"];
            
            NSString *bfr = [data objectForKey:@"bfr_img_url"];
            if (bfr.length != 0) {
                beforeImage.hidden = NO;
                
                CGRect newFrame = distImage.frame;
                newFrame.origin.x = 58;
                distImage.frame = newFrame;
                
                NSURL *imageURL1 = [[NSURL alloc]init];
                bfr = [bfr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                imageURL1 = [NSURL URLWithString:bfr];
                NSData *imageData1 = [NSData dataWithContentsOfURL:imageURL1];
                beforeImage.image   = [UIImage imageWithData:imageData1];
            }
            
            
            
            //show star
             int x=0;
             NSString *abc = [data objectForKey:@"detailer_rating"];
            
            
            int rate = [abc intValue];
           
            if (rate>0)
            
            {
             star1image.hidden = YES;
             star2iamge.hidden = YES;
             star3image.hidden =YES;
             star4image.hidden = YES;
             star5image.hidden = YES;
             
             if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
                {
                    x = 213;
                }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
                    {
                        x = 193;
                    }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
                        {
                            x = 170;
                        }
                 for (int i = 0; i < 5; i++)
                 {
             
                     UIButton *rateButton;
             
                     if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
                     {
                         rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 393, 15, 15)];
                     }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
                     {
                         rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 354, 15, 15)];
                     }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
                     {
                         rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 300, 15, 15)];
                     }
             
                     if (i < rate) {
                         [rateButton setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
                     }else{
                         [rateButton setBackgroundImage:[UIImage imageNamed:@"yellow-star.png"] forState:UIControlStateNormal];
                     }
             
                     [self.view addSubview:rateButton];
             
                     x= x+18;
             
                 }
             
             
             }
  
        }
    }
    [kappDelegate HideIndicator];
    
    
}


- (IBAction)btnback:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
