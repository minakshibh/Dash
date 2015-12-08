//
//  RegisterVerificationViewController.m
//  dash
//
//  Created by Br@R on 29/04/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "RegisterVerificationViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "homeViewViewController.h"
#import "RegisterationRoleViewController.h"
#import "customerProfileViewController.h"
#import "DetailerFirastViewController.h"

@interface RegisterVerificationViewController ()

@end

@implementation RegisterVerificationViewController

- (void)viewDidLoad {
    [[NSUserDefaults standardUserDefaults ]setValue:@"verifyView" forKey:@"view"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    verifyBttn.layer.borderColor = [UIColor grayColor].CGColor;
    verifyBttn.layer.borderWidth = 1.0;
    verifyBttn.layer.cornerRadius = 4.0;
    [verifyBttn setClipsToBounds:YES];
    
    registrAgainBttn.layer.borderColor = [UIColor grayColor].CGColor;
    registrAgainBttn.layer.borderWidth = 1.0;
    registrAgainBttn.layer.cornerRadius = 4.0;
    [registrAgainBttn setClipsToBounds:YES];
    
//logoImg.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);


//registrAgainBttn.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

    
//resendBttn.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Resend verification code"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    [resendBttn setAttributedTitle:commentString forState:UIControlStateNormal];
    
    [resendBttn setTintColor:[UIColor blackColor ]] ;

 
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)verificationBttn:(id)sender
{
    [self.view endEditing:YES];
    
    NSString* codeStr = [verifyCodetxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (codeStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter verification code." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@&code=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],codeStr];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/verify-account.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    webservice=1;
    
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

- (IBAction)registerBttn:(id)sender {
    RegisterationRoleViewController*registerVC = [[RegisterationRoleViewController alloc] initWithNibName:@"RegisterationRoleViewController" bundle:nil];
   // [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"view"];
   // [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)resendBttn:(id)sender
{
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]];
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/resend-code.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    webservice=2;
    
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
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            [kappDelegate HideIndicator];
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(result==0)
        {
            if (webservice==1)
            {
                verifyCodetxt.text=@"";
                [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"view"];
                [self FetchBasicProfile];
            }
            else if (webservice==2)
            {
                [kappDelegate HideIndicator];
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your verification code has been sent to your contact number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (webservice==3)
            {
                [kappDelegate HideIndicator];
                [self saveDataTodtaaBase:userDetailDict];
                
                NSString*role=[userDetailDict valueForKey:@"role"];
                
                NSString*userName=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"name"]];
                [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setValue:role forKey:@"role"];

                
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your account has been verified successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag=1;
                [alert show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        NSString*role=  [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
        if ([role isEqualToString:@"customer"])
        {
            customerProfileViewController *profileVc = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
            profileVc.registrationType = @"customer";
            profileVc.backBtnHiden=@"YES";
            [self.navigationController pushViewController:profileVc animated:NO];
        }
        else{
            
            customerProfileViewController *profileVc = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
            profileVc.registrationType = @"detailer";
            profileVc.backBtnHiden=@"YES";
               [[NSUserDefaults standardUserDefaults]setValue:@"offline" forKey:@"Offline/Online Status"];
            [self.navigationController pushViewController:profileVc animated:NO];
        }
    }
}


-(void) FetchBasicProfile
{
    webservice=3;
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]];
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from userProfile "];
    [database executeUpdate:deleteQuery];
    
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO userProfile (userId, name, password, role, email , contact , image ,creditCardNumber) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",userId,[userDetailDict valueForKey:@"name"],[userDetailDict valueForKey:@"password"],[userDetailDict valueForKey:@"role"],[userDetailDict valueForKey:@"email"],[userDetailDict valueForKey:@"contact_info"],[userDetailDict valueForKey:@"imageUrl"],[userDetailDict valueForKey:@"CreditCardNumber"]];
    
    [database executeUpdate:insert];
    
    [database close];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:singleTap];
}
-(void)tapDetected{
    [verifyCodetxt resignFirstResponder];
    
}

@end
