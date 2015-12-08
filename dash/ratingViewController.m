//
//  ratingViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 5/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "ratingViewController.h"
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
#import "DetailerFirastViewController.h"
@interface ratingViewController ()

@end

@implementation ratingViewController
NSString *gettext;

- (void)viewDidLoad {
    
    ratingValue = @"0";
    [self getData];
    scrollview.scrollEnabled = YES;
    scrollview.delegate = self;
   // scrollview.contentSize = CGSizeMake(320, 520);
    scrollview.backgroundColor=[UIColor clearColor];
    
    
    //txtreview.delegate=self;

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{   [super viewDidLoad];
    
    
    NSString *state= @"confirm_notification";
    NSString *serviceID = getrequestID;
    [[NSUserDefaults standardUserDefaults]setValue:serviceID forKey:@"Service_Pref_id"];
    [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];
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

- (IBAction)submitRatingBtnAction:(id)sender {
    if ([ratingValue isEqualToString:@"0"] && [reviewsTxtView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Kindly Select Rating and give review before submitting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }else{
    gettext = reviewsTxtView.text;
    [self submitRating];
    }
}

-(void)submitRating
{
    [kappDelegate ShowIndicator];
    
    webservice=5;
    //get request id through notifications
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    getrequestID=[userDefaults stringForKey:@"reg_id"];
    
    NSString*_postData = [NSString stringWithFormat:@"senderId=%@&receiverId=%@&serviceId=%@&ratings=%@&reviews=%@",sender1,reciever1,getrequestID,ratingValue,gettext];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/rating.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
-(void)getData
{
    //get request id through notifications
   // [kappDelegate ShowIndicator];
    webservice =6;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([_status isEqualToString:@"pref"])
    {
        getrequestID = _req;
    }else{
    getrequestID=[userDefaults stringForKey:@"reg_id"];
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

- (IBAction)myWorkSamples:(id)sender {
    
    WorkSamplesViewController *workSamples=[[WorkSamplesViewController alloc]initWithNibName:@"WorkSamplesViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:workSamples animated:YES];
    
}


- (IBAction)logOutBttn:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"role"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    
    [self deletDataFromDatabase];
    
    loginViewController*loginVC=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (IBAction)viewProfileBttn:(id)sender {
    MyprofileViewController*myProfile = [[MyprofileViewController alloc] initWithNibName:@"MyprofileViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
}

- (IBAction)workSamples:(id)sender {
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
    DetailerFirastViewController*myProfile = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
    
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
- (IBAction)star1:(id)sender {
    ratingValue =@"1";
    [star1 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star2 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    [star3 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    [star4 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    [star5 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    
}

- (IBAction)star2:(id)sender {
    ratingValue =@"2";
    [star1 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star2 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star3 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    [star4 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    [star5 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    
}

- (IBAction)star3:(id)sender {
    ratingValue=@"3";
    [star1 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star2 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star3 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star4 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    [star5 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    
}

- (IBAction)star4:(id)sender {
    ratingValue = @"4";
    [star1 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star2 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star3 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star4 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star5 setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
    
}

- (IBAction)star5:(id)sender {
    ratingValue = @"5";
    [star1 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star2 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star3 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star4 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    [star5 setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
    
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
    [kappDelegate HideIndicator];
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        //NSString *resultStr=[userDetailDict valueForKey:@"result"];
        if ([messageStr isEqualToString:@"Success"]) {
            data= [[userDetailDict valueForKey:@"request_data"]objectAtIndex:0];
            
            //NSArray *arr =[userDetailDict valueForKey:@"request_data"];
            //NSDictionary *dist = [arr objectAtIndex:0];
            
            if (webservice == 5) {
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                
                [pref removeObjectForKey:@"Service_Pref_id"];
                [pref removeObjectForKey:@"Service_Pref_state"];
                
                NSString *abc = @"Rating";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:abc  message:@"Successfully Rated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                alert.tag =1;
                [alert show];
                
                
                
            }
            if (webservice == 6) {
                sender1 = [data valueForKey:@"detailer_ID"];
                reciever1 = [data valueForKey:@"customer_id"];
                
                NSString *customer_namestr = [data valueForKey:@"customer_name"];
                
                if ([customer_namestr isKindOfClass:[NSNull class]])
                {
                    customer_namestr = @" ";
                }
                
                NSArray *seperate = [customer_namestr componentsSeparatedByString:@" "];
                
                lblRatingName.text = [NSString stringWithFormat:@"Give rating to, %@!",[seperate objectAtIndex:0]];
                
                NSURL *imageURL = [NSURL URLWithString:[data valueForKey:@"customer_image"]];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                userImageView.image = [UIImage imageWithData:imageData];
   
            }
            
            
        }
        [kappDelegate HideIndicator];
    }
    
    
    
    
    
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if([[user valueForKey:@"noti_rating"] isEqualToString:@"yes"])
        {
            DetailerFirastViewController *obj = [[DetailerFirastViewController alloc]initWithNibName:@"DetailerFirastViewController" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES ];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
   
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    reviewPlaceholderlbl.hidden = YES;
    if (self.view.frame.origin.y==0)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             //   sideView.hidden=YES;
             
             CGRect frame = self.view.frame;
             frame.origin.x = self.view.frame.origin.x;
             frame.origin.y = -239;
             self.view.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
    }
    

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        if ([textView.text isEqualToString:@""]) {
            reviewPlaceholderlbl.hidden = NO;
        }
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             sideView.hidden=NO;
             
             CGRect frame = self.view.frame;
             frame.origin.x = self.view.frame.origin.x;
             frame.origin.y = 0;
             self.view.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        [textView resignFirstResponder];
        
    }
    return YES;
}
@end
