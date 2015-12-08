//
//  TagSampleViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 04/08/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//
//#import "TLTagsControl.h"
#import "TagSampleViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "UIView+Toast.h"

@interface TagSampleViewController ()
@property (nonatomic, strong) IBOutlet TLTagsControl *defaultEditingTagControl;
@end

@implementation TagSampleViewController
TLTagsControl *demoTagsControl;

NSMutableArray *tags;
- (void)viewDidLoad {
    [super viewDidLoad];
    _defaultEditingTagControl.hidden = YES;
    txtfield.hidden = YES;
    tags = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnGo:(id)sender {
    NSString *txtstr = [NSString stringWithFormat:@"%@",txtfield.text];
    [tags addObject:txtstr];
    
  
 _defaultEditingTagControl.tags = [tags mutableCopy];
    
   // _defaultEditingTagControl.mode = TLTagsControlModeList ;
    
    
    [_defaultEditingTagControl reloadTagSubviews];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)btnSubmit:(id)sender {
    [self checkEmailPayPal];
    [txtemail resignFirstResponder];
}
-(void)checkEmailPayPal
{   [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    


    _postData = [NSString stringWithFormat:@"emailAddress=%@&matchCriteria=%@",txtemail.text,@"NONE"];

        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://svcs.sandbox.paypal.com/AdaptiveAccounts/GetVerifiedStatus"]] cachePolicy:
                   NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    NSLog(@"data post >>> %@",_postData);

    [request setHTTPMethod:@"POST"];
    [request addValue:@"jb-us-seller_api1.paypal.com" forHTTPHeaderField:@"X-PAYPAL-SECURITY-USERID"];
    [request addValue:@"WX4WTU3S8MY44S7F" forHTTPHeaderField:@"X-PAYPAL-SECURITY-PASSWORD"];
    [request addValue:@"AFcWxV21C7fd0v3bYYYRCpSSRl31A7yDhhsPUU2XhtMoZXsWHFxu-RWy" forHTTPHeaderField:@"X-PAYPAL-SECURITY-SIGNATURE"];
    [request addValue:@"APP-80W284485P519543T" forHTTPHeaderField:@"X-PAYPAL-APPLICATION-ID"];
    [request addValue:@"NV" forHTTPHeaderField:@"X-PAYPAL-REQUEST-DATA-FORMAT"];
    [request addValue:@"JSON" forHTTPHeaderField:@"X-PAYPAL-RESPONSE-DATA-FORMAT"];
    [request addValue:@"127.0.0.1" forHTTPHeaderField:@"X-PAYPAL-DEVICE-IPADDRESS"];
 [request addValue:@"merchant-php-sdk-2.0.96" forHTTPHeaderField:@"X-PAYPAL-REQUEST-SOURCE"];
    [request addValue:@"Platform.sdk.seller@gmail.com" forHTTPHeaderField:@"X-PAYPAL-SANDBOX-EMAIL-ADDRESS"];
    
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

//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
    [self.view makeToast:@"Error while establishing connection Trying again"];
    NSLog(@"ERROR with the Connection %@",error);
    webData =nil;
    [kappDelegate HideIndicator];
    [self checkEmailPayPal];
    [self.view bringSubviewToFront:btnBack];
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
    NSString *status = [NSString stringWithFormat:@"user account status is %@",[userDetailDict valueForKey:@"accountStatus"]];
    
        [self.view makeToast:status];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
