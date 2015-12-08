//
//  updateRequest.m
//  dash
//
//  Created by Krishna_Mac_1 on 6/8/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "updateRequest.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "reciveRequestdetailViewController.h"
#import "startServiceViewController.h"
#import "arrivalViewController.h"
#import "startServiceViewController.h"
#import "endServiceViewController.h"
#import "confirmServiceViewController.h"

@implementation updateRequest
NSString *serviceid2;

-(NSString*)updateRequestStatus: (NSString *)status delegate: (id)theDelegate service_id: (NSString*)service_id startPic: (NSString *)startPic endPic: (NSString *) endpic{
    
    
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    serviceid2 = service_id;
    //NSString *serviceId = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"reg_id"]];
    
    statusRecived = [NSString stringWithFormat:@"%@",status];
    _postData = [NSString stringWithFormat:@"user_id=%@&status=%@&service_id=%@&start_pic=%@&end_pic=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],status,service_id,startPic,endpic];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/update-request-status.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    return nil;
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
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"responseString:%@",userDetailDict);
    NSString *message = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
    
    
    [kappDelegate HideIndicator];
    
    if ([message isEqualToString:@"success"]) {
        if ([statusRecived isEqualToString:@"Arriving"]) {
            reciveRequestdetailViewController *startServiceVC = [[reciveRequestdetailViewController alloc]initWithNibName:@"reciveRequestdetailViewController" bundle:nil];
            startServiceVC.idrequest = serviceid2 ;
            [startServiceVC  recivedResponce];
        }
        if ([statusRecived isEqualToString:@"Arrived"]) {
            arrivalViewController *arrived = [[arrivalViewController alloc]init];
            arrived.reqid2 =serviceid2;
            [arrived  recivedResponce];

        }
        if ([statusRecived isEqualToString:@"StartService"]) {
            startServiceViewController *startServices = [[startServiceViewController alloc]init];
            startServices.reqid =   serviceid2;
            [startServices  recivedResponce];
        }
        if ([statusRecived isEqualToString:@"EndService"]) {
            endServiceViewController *endServices = [[endServiceViewController alloc]init];
            [endServices  recivedResponce];
        }
        if ([statusRecived isEqualToString:@"ConfirmService"]) {
            confirmServiceViewController *confirmServices = [[confirmServiceViewController alloc]init];
            [confirmServices  recivedResponce];
        }
    }
}

-(NSString*)statusValue{
    return @"True";
}

-(void )updateRequestWithImage : (NSString *)status delegate: (id)theDelegate service_id: (NSString*)service_id startPic: (NSData *)startPic endPic: (NSData *) endpic{
    
    
    //NSString*detailarList;
    [kappDelegate ShowIndicator];
    statusRecived = [NSString stringWithFormat:@"%@",status];
    webservice=1;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    serviceid2 = service_id;
    NSDictionary *_params = @{@"user_id" : userId,
                              @"status" : status,
                              @"service_id" : service_id,
                              };
    NSString *fileName;
    if([status isEqualToString:@"StartService"]){
        fileName = [NSString stringWithFormat:@"startPic%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
    }else{
        fileName = [NSString stringWithFormat:@"endPic%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
    }
    

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    // BASIC AUTH (if you need):
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // BASIC AUTH END
    
    NSString *URLString = [NSString stringWithFormat:@"%@/update-request-status.php",Kwebservices];
    
    /// !!! only jpg, have to cover png as well
    // image size ca. 50 KB
    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if([status isEqualToString:@"StartService"]){
           [formData appendPartWithFileData:startPic name:@"start_pic" fileName:fileName mimeType:@"image"];
        }else{
            [formData appendPartWithFileData:endpic name:@"end_pic" fileName:fileName mimeType:@"image"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success %@", responseObject);
        [kappDelegate HideIndicator];
        if (![responseObject isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[responseObject valueForKey:@"message"];
            int result=[[responseObject valueForKey:@"result" ]intValue];
            UIAlertView *alert;
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if(result==0)
            {
                if ([statusRecived isEqualToString:@"StartService"]) {
                    startServiceViewController *startServices = [[startServiceViewController alloc]initWithNibName:@"startServiceViewController" bundle:nil];
                    startServices.reqid =   serviceid2;
                    startServices.startPic1 = startPic;
                    [startServices  recivedResponce];
                }
                if ([statusRecived isEqualToString:@"EndService"]) {
                    endServiceViewController *endServices = [[endServiceViewController alloc]initWithNibName:@"endServiceViewController" bundle:nil];
                    [endServices  recivedResponce];
                }
                if ([statusRecived isEqualToString:@"ConfirmService"]) {
                    confirmServiceViewController *confirmServices = [[confirmServiceViewController alloc]initWithNibName:@"confirmServiceViewController" bundle:nil];
                    [confirmServices  recivedResponce];
                }
                
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
}

@end
