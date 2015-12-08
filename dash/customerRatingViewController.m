//
//  customerRatingViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "customerRatingViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "homeViewViewController.h"
#import "loginViewController.h"

@interface customerRatingViewController ()

@end

@implementation customerRatingViewController

- (void)viewDidLoad {
    placeholder.hidden = NO;
    ratingValue = @"0" ;
    [super viewDidLoad];
    
    
    [self displayData];
    
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(320, 520);
    scrollView.backgroundColor=[UIColor clearColor];
    
    
    //txtreview.delegate=self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    
    singleTap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:singleTap];
    

    
    // Do any additional setup after loading the view from its nib.
}
-(void)tapDetected{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self.view endEditing:YES];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtreview resignFirstResponder];
    placeholder.hidden = YES;
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    svos = scrollView.contentOffset;
    placeholder.hidden = YES;
    if (IS_IPHONE_4_OR_LESS)
    {
        if ( textView == txtreview) {
            
            CGPoint pt;
            CGRect rc = [textView bounds];
            rc = [textView convertRect:rc toView:scrollView];
            pt = rc.origin;
            pt.x = 0;
            pt.y -=98;
            [scrollView setContentOffset:pt animated:YES];
        }
        
    }
    else
        if (textView == txtreview) {
            
            CGPoint pt;
            CGRect rc = [textView bounds];
            rc = [textView convertRect:rc toView:scrollView];
            pt = rc.origin;
            pt.x = 0;
            pt.y -=100;
            [scrollView setContentOffset:pt animated:YES];
        }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        if ([textView.text isEqualToString:@""]) {
            placeholder.hidden = NO;
        }
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             
             
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)displayData
{
    //get request id through notifications
    webservice =1;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* getrequestID;
    
    if([_pref isEqualToString:@"yes"])
    {
        getrequestID = [userDefaults valueForKey:@"Service_Pref_id"];
    }else{
        getrequestID=[userDefaults stringForKey:@"cust_reg_id"];
    }
    
    
    
    NSString*_postData = [NSString stringWithFormat:@"requested_id=%@",@"273"];
    
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


- (IBAction)btnRating:(id)sender {
    if ([ratingValue isEqualToString:@"0"] && [txtreview.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Kindly Select Rating and give review before submitting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }else
    {
    review = txtreview.text;
        [self submitRating];
    }
    
}
-(void)submitRating
{
    
    webservice=2;
    //get request id through notifications
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* getrequestID;
    if([_pref isEqualToString:@"yes"])
    {
        getrequestID = [userDefaults valueForKey:@"Service_Pref_id"];
    }else{
    getrequestID=[userDefaults stringForKey:@"cust_reg_id"];
    }
    
    NSString*_postData = [NSString stringWithFormat:@"senderId=%@&receiverId=%@&serviceId=%@&ratings=%@&reviews=%@",cust_id,dist_id,getrequestID,ratingValue,review];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/rating.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded"  forHTTPHeaderField:@"Content-Type"];
    
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
            
            if (webservice==1) {
            //show image 1
            NSString*imgUrl=[data objectForKey:@"detailer_image"];
            NSURL *imageURL = [NSURL URLWithString:imgUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            distimage.image = [UIImage imageWithData:imageData];

            NSString *customer_namestr = [data valueForKey:@"detailer_name"];
                
                if ([customer_namestr isKindOfClass:[NSNull class]])
                {
                    customer_namestr = @" ";
                }

                NSArray *seperate = [customer_namestr componentsSeparatedByString:@" "];
                lblRatingName.text = [NSString stringWithFormat:@"Give rating to, %@!",[seperate objectAtIndex:0]];
                
            cust_id = [data objectForKey:@"customer_id"];
            dist_id = [data objectForKey:@"detailer_ID"];
            }
            if (webservice==2) {
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                [pref removeObjectForKey:@"Service_Pref_id"];
                [pref removeObjectForKey:@"Service_Pref_state"];

                NSString *abc = @"Rating";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:abc  message:@"Successfully Rated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                alert.tag= 1;
                [alert show];
                
               // [self presentViewController:obj animated:YES completion:nil];
                
                
            }
        }
    }
    
    [kappDelegate HideIndicator];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        homeViewViewController *obj = [[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
@end
