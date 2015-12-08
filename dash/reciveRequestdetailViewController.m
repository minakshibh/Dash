//
//  reciveRequestdetailViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 5/14/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "reciveRequestdetailViewController.h"
#import "reciveRequestViewController.h"
#import "DetailerFirastViewController.h"
#import "loginViewController.h"
#import "MyprofileViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "WorkSamplesViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "startServiceViewController.h"
#import "AppDelegate.h"
#import "arrivalViewController.h"
#import"reciveRequestViewController.h"
#import "assignmentsViewController.h"
@interface reciveRequestdetailViewController ()

@end

@implementation reciveRequestdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isBlocked = false;
    btnBlock.hidden = YES;
    btnbeingArrival.hidden = YES;
    lbltimer.hidden = YES;
    lblSpecialreq2.text = self.assignmentOC.special_Requirement;
    if([_detailerEnd_UserInfo isEqualToString:@"yes"])
    {
        btnMenu.hidden = YES;
        menuicon.hidden = YES;
        lblSpecialreq1.hidden = NO;
        lblSpecialreq2.hidden = NO;
        btnbeingArrival.hidden = NO;
        [btnbeingArrival setTitle:@"Tab To Accept" forState:UIControlStateNormal];
        userNameLbl.text =[NSString stringWithFormat:@"%@", self.assignmentOC.cust_name];
        
    }
    
    //-----timer
    TimerValue=[_timervalue intValue];
    TimerValue = TimerValue -1;
    lbltimer.text=[NSString stringWithFormat:@"%d",TimerValue];
    lblTimer1.text =[NSString stringWithFormat:@"%d",TimerValue];
    if(TimerValue >0)
    {
        lbltimer.hidden = NO;
        lblTimer1.hidden = NO;
    }
    [DownTimer invalidate];
    DownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:YES];
    
    
    detailerID = self.assignmentOC.detailer_ID;
    customerID = self.assignmentOC.customer_id;
    
    if ([_detailerEnd_UserInfo isEqualToString:@"yes"]) {
        userNameLbl.text = self.assignmentOC.cust_name;
        btnbeingArrival.hidden = YES;
        addToWorkSampleBttn.hidden = YES;
        
        if (IS_IPHONE_4_OR_LESS)
        {
            [tapToacceptViewIphone5 setFrame:CGRectMake(10, 400, tapToacceptViewIphone5.frame.size.width, tapToacceptViewIphone5.frame.size.height)];
            [self.view addSubview:tapToacceptViewIphone5];
        }
        if (IS_IPHONE_5)
        {
            [tapToacceptViewIphone5 setFrame:CGRectMake(15, 510, tapToacceptViewIphone5.frame.size.width, tapToacceptViewIphone5.frame.size.height)];
            [self.view addSubview:tapToacceptViewIphone5];
        }
        if (IS_IPHONE_6)
        {
            [tapToAcceptView setFrame:CGRectMake(50, 660, tapToAcceptView.frame.size.width, tapToAcceptView.frame.size.height)];
            [self.view addSubview:tapToAcceptView];
        }
        if (IS_IPHONE_6P)
        {
            [tapToAcceptView setFrame:CGRectMake(50, 655, tapToAcceptView.frame.size.width, tapToAcceptView.frame.size.height)];
            [self.view addSubview:tapToAcceptView];
        }

        
   }
    
    if([_timing isEqualToString:@"past"])
    {
        btnBlock.hidden = NO;
    }
    if ([_custView isEqualToString:@"Yes"]) {
        btnBlock.hidden=NO;
        btnbeingArrival.hidden = YES;
        btnMenu.hidden = YES;
        menuicon.hidden = YES;
        btnback.hidden=NO;
    }

    if ([_distassign isEqualToString:@"detailer"]) {
        btnback.hidden = NO;
        btnMenu.hidden = YES;
        menuicon.hidden = YES;
        btnbeingArrival.hidden = YES;
    }
    if([_BlockBtn isEqualToString:@"BlockBtn"])
    {
        btnBlock.hidden = NO;
    }
    if([_arrivalbtn isEqualToString:@"yes"])
    {
        btnbeingArrival.hidden = NO;
    }
    if ([_distassign isEqualToString:@"detailer"] && [_BlockBtn isEqualToString:@"BlockBtn"] ) {
        addToWorkSampleBttn.hidden=NO;
    }
    else{
        addToWorkSampleBttn.hidden=YES;
    }

    
    
     NSString *vehicleNameStr = [NSString stringWithFormat:@"%@ %@ %@ %@",self.assignmentOC.vehicleColor,self.assignmentOC.vehicleMake,self.assignmentOC.vehicleModal,self.assignmentOC.vehicleNo];
    vehicleNameLbl.text = [NSString stringWithFormat:@"%@",vehicleNameStr];
    
    NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
    if ([role isEqualToString:@"customer"])
    {
    userNameLbl.text = [NSString stringWithFormat:@"%@", self.assignmentOC.detailer_name];
    }else
    { if(![self.assignmentOC.cust_name isKindOfClass:[NSNull class]])
    {
        userNameLbl.text = [NSString stringWithFormat:@"%@", self.assignmentOC.cust_name];
    }
    }
   
    addressLbl.text = [NSString stringWithFormat:@"%@",self.assignmentOC.address];
    NSDate *todaysDate;
    todaysDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-mm-dd"];
    NSString *currentDate = [ dateFormat stringFromDate:todaysDate];
    todaysDate = [dateFormat dateFromString:currentDate];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"YYYY-mm-dd HH:mm:ss"];
    NSDate *serviceDate = [dateFormat1 dateFromString:self.assignmentOC.time];
    NSString *serviceDateStr = [dateFormat stringFromDate:serviceDate];
    serviceDate = [dateFormat dateFromString:serviceDateStr];
    NSLog(@"Current Date ..... %@, ServiceDate..... %@",todaysDate,serviceDate);
    NSString *serviceDateTime;
    if ([todaysDate compare:serviceDate] == NSOrderedSame) {
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"HH:mm:ss"];
        NSDate *serviceTime = [dateFormat1 dateFromString:self.assignmentOC.time];
        serviceDateTime = [dateFormat stringFromDate:serviceTime];
    }else{
        NSDate *serviceTime = [dateFormat1 dateFromString:self.assignmentOC.time];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"dd MMM"];
        serviceDateTime = [dateFormat1 stringFromDate:serviceTime];
        NSLog(@"Service time ..... %@",serviceDateTime);
    }
    if([self.timing isEqualToString:@"past"])
    {
        if([self.assignmentOC.later isEqualToString:@"now"])
        {
           dateTimeLbl.text = [NSString stringWithFormat:@"%@",self.assignmentOC.requested_time];
            
        }else{
            
            dateTimeLbl.text = [NSString stringWithFormat:@"%@",self.assignmentOC.time];
        }
        
    }else
    {
    dateTimeLbl.text = [NSString stringWithFormat:@"%@",self.assignmentOC.time];
    }
    
    
    NSURL *imageURL;
    NSString *imagestr;
    if([_timing isEqualToString:@"past"])
    {
         imagestr = [self.assignmentOC.after_img_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        imageURL = [NSURL URLWithString:imagestr];
    }else
    {
        if([_servicehistorypast isEqualToString:@"yes"])
        {
            imagestr = [self.assignmentOC.after_img_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            imageURL = [NSURL URLWithString:imagestr];
        }else{
            if([_arrivalbtn isEqualToString:@"yes"])
            {
                imagestr = [self.assignmentOC.image stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            }else{
            imagestr = [self.assignmentOC.after_img_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            }
        imageURL = [NSURL URLWithString:imagestr];
        }
    }
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            vehicleImage.image = [UIImage imageWithData:imageData];
        });
    });
    NSURL *imageURL1;
    NSString *imagestr1;
    if([_timing isEqualToString:@"past"])
    {
        imagestr1 = [self.assignmentOC.bfr_img_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        imageURL1 = [NSURL URLWithString:imagestr1];
    }else if([_arrivalbtn isEqualToString:@"yes"])
    {
        imagestr1 = [self.assignmentOC.cust_image stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        imageURL1 = [NSURL URLWithString:imagestr1];
    }else
    {if([_servicehistorypast isEqualToString:@"yes"])
    {
        imagestr1 = [self.assignmentOC.bfr_img_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        imageURL1 = [NSURL URLWithString:imagestr1];
    }else
    {
        imagestr1 = [self.assignmentOC.bfr_img_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        imageURL1 = [NSURL URLWithString:imagestr1];
    }
    }
    
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            customerImage.image = [UIImage imageWithData:imageData];
        });
    });

    NSString *onlineStatus = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Offline/Online Status"]];
    if ([onlineStatus isEqualToString:@"Online"]) {
        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
    }else{
        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
    }

    // Do any additional setup after loading the view from its nib.
    
    
    
     int x=0;
    NSString *abc;
    if ([role isEqualToString:@"customer"])
    {
        abc = self.assignmentOC.dist_rate;
    }else{
//        if([_servicehistorypast isEqualToString:@"yes"])
//        {
//            abc = self.assignmentOC.service_id_rating;
//        }else{
            abc = self.assignmentOC.cust_rate;
     //   }
    }
    int rate = [abc intValue];
    if (rate>0) {
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
        for (int i = 0; i < 5; i++) {
            
            UIButton *rateButton;
            
            if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
            {
                rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 298, 15, 15)];
            }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
            {
                rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 351, 15, 15)];
            }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
            {
                rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 298, 15, 15)];
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
-(void)viewWillAppear:(BOOL)animated{
    NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
    if ([role isEqualToString:@"customer"])
    {
        id_block = self.assignmentOC.customer_id;
    }else if([role isEqualToString:@"detailer"])
    {
        id_block = self.assignmentOC.detailer_ID;
    }
    [self get_block_user];
}
-(void)get_block_user
{
    webservices = 25;
    NSString*_postData = [NSString stringWithFormat:@"userId=%@&isBlocked=%@&blocked_id=%@&last_updated=%@",id_block,@"",@"-1",@""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/block-detailer.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
-(void)DownTimeCal
{
    TimerValue=TimerValue-1;
    lbltimer.text=[NSString stringWithFormat:@"%d",TimerValue];
    lblTimer1.text =[NSString stringWithFormat:@"%d",TimerValue];
    
    if (TimerValue==0)
    {
        lbltimer.hidden = YES;
        lblTimer1.hidden = YES;
        [DownTimer invalidate];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You missed a request!" message:@"You did not attempt to accept this request." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag=1;
        
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        [DownTimer invalidate];
        DetailerFirastViewController*myProfile = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
        [self.navigationController pushViewController:myProfile animated:NO];
    }
    if(alertView.tag == 2)
    {
        if (buttonIndex == alertView.cancelButtonIndex) {
            DetailerFirastViewController *obj = [[DetailerFirastViewController alloc]initWithNibName:@"DetailerFirastViewController" bundle:nil];
            [self.navigationController pushViewController:obj animated:YES];
            
        }else{
            
            assignmentsViewController* obj = [[assignmentsViewController alloc]initWithNibName:@"assignmentsViewController" bundle:nil];
            obj.triggerValue = @"detailer";
            obj.timing = @"upcoming";
            obj.from_reciveRequest = @"yes";
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
    if(alertView.tag ==3)
    {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (sideView.frame.origin.x==-240)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             //   sideView.hidden=YES;
             
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
    else{
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             sideView.hidden=NO;
             
             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = -240;
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

- (IBAction)beginArrivalBtnAction:(id)sender {
    
        
        
   
    if ([_from_assignment isEqualToString:@"Yes"]) {
        serviceID = self.assignmentOC.requestId;
    }else{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    serviceID=[userDefaults stringForKey:@"reg_id"];
    }
    
    NSString *state = @"Arriving";
    
    [[NSUserDefaults standardUserDefaults]setValue:serviceID forKey:@"Service_Pref_id"];
    [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];
    
    updateRequestObj = [[updateRequest alloc]  init];
    [updateRequestObj updateRequestStatus:@"Arriving" delegate:self service_id:serviceID startPic:@"" endPic:@""];
    
}

-(void)acceptService
{
    webservices = 23;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     reqid23=[userDefaults stringForKey:@"reg_id"];
    NSLog(reqid23,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
    NSString *userloginid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString*_postData = [NSString stringWithFormat:@"service_id=%@&detailerId=%@&status=%@",reqid23,userloginid,@"Accepted"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/accept-service.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
-(void)recivedResponce{
    updateRequestObj = [[updateRequest alloc]  init];
    NSString* status = [updateRequestObj statusValue];
    NSLog(@"%@", status);
    if ([status isEqualToString:@"True"]) {
        arrivalViewController *arrivalView = [[arrivalViewController alloc]initWithNibName:@"arrivalViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
     //   if ([_from_assignment isEqualToString:@"Yes"]) {
            serviceID = _idrequest;
    //    }else{
      //      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      //      serviceID=[userDefaults stringForKey:@"reg_id"];
     //   }
        
        
        arrivalView.reqid2 = serviceID;
        [appDelegate.navigator pushViewController:arrivalView animated:NO];
    }
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
        
        if(webservices == 23)
        {
            if (webservices == 23 && [_now_later isEqualToString:@"now"])
            {
                // alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                // [alert show];
                
                arrivalViewController *arrivalVC = [[arrivalViewController alloc] initWithNibName:@"arrivalViewController" bundle:nil];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString* strDefSetting=[userDefaults stringForKey:@"reg_id"];
                arrivalVC.reqid2 = strDefSetting;
                
                NSString *state= @"Accept";
                NSString *serviceID = strDefSetting;
                [[NSUserDefaults standardUserDefaults]setValue:reqid23 forKey:@"Service_Pref_id"];
                [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];

                [appDelegate.navigator pushViewController:arrivalVC animated:NO];

                // webservices = nil;
                
            }else if([_now_later isEqualToString:@"later"]){
                
                NSString *name = [NSString stringWithFormat:@"Hi,%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
                
                UIAlertView *alert6 = [[UIAlertView alloc]initWithTitle:name message:@"This assignment is saved, want to go to assignment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert6.tag = 2;
                [alert6 show];
            }
        }
        else if(webservices==27)
        {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your service is added to work samples successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 3;
            [alert show];
            addToWorkSampleBttn.hidden=YES;
        }else if (webservices == 25)
        {
            NSMutableArray *arr = [userDetailDict valueForKey:@"block_list"];
            
            NSMutableArray *ids =[[NSMutableArray alloc]init];
            
            for (int i=0; i<arr.count; i++) {
                NSString *idstr = [[arr valueForKey:@"blocked_id"] objectAtIndex:i];
                [ids addObject:idstr];
            }
            
            NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
            NSString *id_to_block;
            if ([role isEqualToString:@"customer"])
            {
                id_to_block = self.assignmentOC.detailer_ID;
            }else if([role isEqualToString:@"detailer"])
            {
                id_to_block = self.assignmentOC.customer_id;
            }
            
            for(int j=0; j<ids.count;j++)
            {
                if ([id_to_block isEqualToString:[ids objectAtIndex:j]]) {
                    [btnBlock setTitle:@"Unblock" forState:UIControlStateNormal];
                    isBlocked = true;
                }
            }
            
        }

        
}
    
    
    
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
}

-(void)ReceivedResponse:(NSString *)status{
    NSLog(@"%@",status);
}
- (IBAction)btnback:(id)sender {
    if (TimerValue >0) {
        reciveRequestViewController *obj = [[reciveRequestViewController alloc]initWithNibName:@"reciveRequestViewController" bundle:nil];
        obj.timer = [NSString stringWithFormat:@"%d",TimerValue];
        [DownTimer invalidate];
        [self.navigationController pushViewController:obj animated:YES];
    }else{
    [self.navigationController popViewControllerAnimated:NO];

    }
}
- (IBAction)tabToAcceptBtnAction:(id)sender {
    [kappDelegate ShowIndicator];
    [DownTimer invalidate];
    [self acceptService];

}

- (IBAction)btnBlock:(id)sender {
    if (isBlocked)
    {
        [btnBlock setTitle:@"Block" forState:UIControlStateNormal];
        isBlocked=false;
    }
    else{
        
        [btnBlock setTitle:@"Unblock" forState:UIControlStateNormal];
        isBlocked=true;
    }
    
    if(isBlocked)
    {
        BlockStr = @"true";
    }else{
        BlockStr = @"false";
    }
    
    webservices = 5;
    NSString* blocker;
    
    NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
    if ([role isEqualToString:@"customer"])
    {
        blocker = detailerID;
    }else{
        blocker = customerID;
    }
    
    NSString*_postData = [NSString stringWithFormat:@"userId=%@&isBlocked=%@&blocked_id=%@&last_updated=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],BlockStr,blocker,@""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/block-detailer.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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


- (IBAction)addToWorkSamplesBtn:(id)sender
{
    [kappDelegate ShowIndicator];
    webservices = 27;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* reqid=[userDefaults stringForKey:@"reg_id"];
    NSLog(reqid,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
    NSString *userloginid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    NSString*_postData = [NSString stringWithFormat:@"service_id=%@&detailer_id=%@",_assignmentOC.requestId,userloginid];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/service-work-sample.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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



@end
