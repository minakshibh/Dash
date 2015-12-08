    //
//  loginViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/25/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "loginViewController.h"
#import "forgotPasswordViewController.h"
#import "homeViewViewController.h"
#import "customerProfileViewController.h"
#import "registerViewController.h"
#import "RegisterationRoleViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
//#import "detailerViewController.h"
#import "Base64.h"
#import "DetailerFirastViewController.h"
#import "vehicleListViewController.h"
#import "locationListViewController.h"
#import "requestServiceViewController.h"


@interface loginViewController ()

@end

@implementation loginViewController
@synthesize backBtnHidden,callerView,detailerArray,detailerId;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    loginBGLbl.layer.borderColor = [UIColor grayColor].CGColor;
    loginBGLbl.layer.borderWidth = 1.0;
    loginBGLbl.layer.cornerRadius = 4.0;
    [loginBGLbl setClipsToBounds:YES];
    NSLog(@"iphon5%d",IS_IPHONE_5);
    NSLog(@"i 6%d",IS_IPHONE_6);
    NSLog(@"i 4%d",IS_IPHONE_4_OR_LESS);
    NSLog(@"i 6p%d",IS_IPHONE_6P);
    
    loginBttn.layer.borderColor = [UIColor grayColor].CGColor;
    loginBttn.layer.borderWidth = 1.0;
    loginBttn.layer.cornerRadius = 4.0;
    [loginBttn setClipsToBounds:YES];
    
     if (backBtnHidden)
    {
        headerView.hidden=NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"view" ] isEqualToString:@"verifyView"])
    {
        headerView.hidden=NO;
    }
    

    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Register Here"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    
    [regHereBttn setAttributedTitle:commentString forState:UIControlStateNormal];
    
    [regHereBttn setTintColor:[UIColor colorWithRed:224.0f/255.0f green:15.0f/255.0f blue:70.0f/255.0f alpha:1.0f ]] ;

    
    
    NSMutableAttributedString *commentString1 = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password? click here"];
    [commentString1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString1 length])];
    
    
    [forgtPasswrdBttn setAttributedTitle:commentString1 forState:UIControlStateNormal];
    
    [forgtPasswrdBttn setTintColor:[UIColor blackColor]] ;

    
    
//    if (IS_IPHONE_5)
//    {
//        loginScroller.frame=CGRectMake(7, loginScroller.frame.origin.y-30,306, loginScroller.frame.size.height);
//      
//        alreadyHaveAccount.frame=CGRectMake(alreadyHaveAccount.frame.origin.x-20, alreadyHaveAccount.frame.origin.y, alreadyHaveAccount.frame.size.width, alreadyHaveAccount.frame.size.height);
//        
//         regHereBttn.frame=CGRectMake(regHereBttn.frame.origin.x-20, regHereBttn.frame.origin.y, regHereBttn.frame.size.width, regHereBttn.frame.size.height);
//        logoImg.center = CGPointMake(self.view.frame.size.width  / 2.5, self.view.frame.size.height/6);
//
//        loginBGLbl.frame=CGRectMake(0, loginBGLbl.frame.origin.y,304, loginBGLbl.frame.size.height);
//        loginBttn.frame=CGRectMake(2, loginBttn.frame.origin.y,310, loginBttn.frame.size.height);
//    
//    }
//    if (IS_IPHONE_6)
//    {
//        loginScroller.frame=CGRectMake(7, loginScroller.frame.origin.y,350, loginScroller.frame.size.height);
//        loginBGLbl.frame=CGRectMake(10, loginBGLbl.frame.origin.y,340, loginBGLbl.frame.size.height);
//        loginBttn.frame=CGRectMake(10, loginBttn.frame.origin.y,340, loginBttn.frame.size.height);
//    }
//    if (IS_IPHONE_6P)
//    {
//        
//    }
//    if (IS_IPHONE_4_OR_LESS)
//    {
//        alreadyHaveAccount.frame=CGRectMake(alreadyHaveAccount.frame.origin.x-35, alreadyHaveAccount.frame.origin.y-70, alreadyHaveAccount.frame.size.width, alreadyHaveAccount.frame.size.height);
//        regHereBttn.frame=CGRectMake(regHereBttn.frame.origin.x-35, regHereBttn.frame.origin.y-70, regHereBttn.frame.size.width, regHereBttn.frame.size.height);
//
//        loginScroller.frame=CGRectMake(7, loginScroller.frame.origin.y-80,304, loginScroller.frame.size.height);
//        logoImg.center = CGPointMake(self.view.frame.size.width  / 2.7, self.view.frame.size.height/5);
//        
//        forgtPasswrdBttn.frame=CGRectMake(forgtPasswrdBttn.frame.origin.x-65, forgtPasswrdBttn.frame.origin.y-82, forgtPasswrdBttn.frame.size.width, forgtPasswrdBttn.frame.size.height);
//        
//        loginBGLbl.frame=CGRectMake(2, loginBGLbl.frame.origin.y,300, loginBGLbl.frame.size.height);
//        loginBttn.frame=CGRectMake(3, loginBttn.frame.origin.y,310, loginBttn.frame.size.height);
//    }
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

- (IBAction)loginBtnAction:(id)sender {
    [loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];

    [self.view endEditing:YES];
    if (![self validateEmailWithString:emailAddressTxt.text]==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Valid Email id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if ([passwordTxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else
    {
        
        webservice=1;
        [kappDelegate ShowIndicator];
        NSMutableURLRequest *request ;
       
        NSString*_postData = [NSString stringWithFormat:@"email=%@&password=%@",emailAddressTxt.text,passwordTxt.text];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/login.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
}
        

- (IBAction)forgotPasswordAction:(id)sender {
    forgotPasswordViewController *forgotVC = [[forgotPasswordViewController alloc] initWithNibName:@"forgotPasswordViewController" bundle:nil];
    
    [self.navigationController pushViewController:forgotVC animated:YES];
}

- (IBAction)backBtnAction:(id)sender {
    homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)registerBtnAction:(id)sender {
    
    RegisterationRoleViewController*registerVC = [[RegisterationRoleViewController alloc] initWithNibName:@"RegisterationRoleViewController" bundle:nil];
    if (backBtnHidden) {
        registerVC.backBtnHidden=YES;

    }
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = loginScroller.contentOffset;
    
    if (textField == emailAddressTxt|| textField == passwordTxt) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:loginScroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y =0;
        [loginScroller setContentOffset:pt animated:YES];
    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
    
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
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
                NSString*userId=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"user_id"]];
                
                [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userid"];
                
                [self FetchBasicProfile];

            }
            else if (webservice==2)
            {

                NSString*userName=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"name"]];
                [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
                NSString*role=[userDetailDict valueForKey:@"role"];
                [self saveDataTodtaaBase:userDetailDict];
                [[NSUserDefaults standardUserDefaults] setValue:role forKey:@"role"];

                [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"view"];
                
                if ([role isEqualToString:@"customer"])
                {
                    [self saveVehicleData:userDetailDict];
                    [self saveLocationData:userDetailDict];
                    [self FetchFavDetailersWebCall];
                }
                else{
                    [kappDelegate HideIndicator];
                    DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
                    [self saveWorkSampleData:userDetailDict];
                    [[NSUserDefaults standardUserDefaults]setValue:@"offline" forKey:@"Offline/Online Status"];

                    [self.navigationController pushViewController:homeVC animated:NO];
                }
            }
        
            else if (webservice==3)
            {
                [kappDelegate HideIndicator];
                NSString*lastUpdated=[userDetailDict valueForKey:@"last_updated_max"];
                  if (![lastUpdated isKindOfClass:[NSNull class]])
                  {
                      [[NSUserDefaults standardUserDefaults] setValue:lastUpdated forKey:@"fav_last_updated"];

                  }
                NSArray*favDetailrArray=[userDetailDict valueForKey:@"detailer_list"];
                if (favDetailrArray.count>0) {
                    [self saveFavListToDatabase:favDetailrArray];
                }
                
          
                NSString*role=[[NSUserDefaults standardUserDefaults] valueForKey:@"role"];

                if ([role isEqualToString:@"customer"])
                {
                    
                    [self registerDevice];
                    
                }
                else{
                    DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
                    [self saveWorkSampleData:userDetailDict];
                    [[NSUserDefaults standardUserDefaults]setValue:@"offline" forKey:@"Offline/Online Status"];

                    [self.navigationController pushViewController:homeVC animated:NO];
                }
            }
            else if (webservice==4)
            {
                [kappDelegate HideIndicator];
                NSString*role=[[NSUserDefaults standardUserDefaults] valueForKey:@"role"];

                if ([role isEqualToString:@"customer"])
                {
                    
                    if ([callerView isEqualToString:@"vehicle"])
                    {
                        vehicleListViewController *vehiclelistVC = [[vehicleListViewController alloc] initWithNibName:@"vehicleListViewController" bundle:nil];
                        
                        [self.navigationController popViewControllerAnimated: YES];
                        
                        [self.navigationController pushViewController:vehiclelistVC animated:NO];
                        
                    }
                    else if ([callerView isEqualToString:@"location"]) {
                        locationListViewController *locListVC = [[locationListViewController alloc] initWithNibName:@"locationListViewController" bundle:nil];
                        [self.navigationController popViewControllerAnimated: YES];
                        
                        [self.navigationController pushViewController:locListVC animated:NO];
                        
                    }
                    else  if ([callerView isEqualToString:@"randomRequest"]) {
                        requestServiceViewController *requestVC = [[requestServiceViewController alloc] initWithNibName:@"requestServiceViewController" bundle:nil];
                        requestVC.detailrId=detailerId;
                        requestVC.detailrsArray=[detailerArray mutableCopy];
                        [self.navigationController popViewControllerAnimated: YES];
                        
                        [self.navigationController pushViewController:requestVC animated:NO];
                        
                    }
                    else  if ([callerView isEqualToString:@"recomndedRequest"])
                    {
                        requestServiceViewController *requestVC = [[requestServiceViewController alloc] initWithNibName:@"requestServiceViewController" bundle:nil];
                        requestVC.detailrId=detailerId;
                        requestVC.detailrsArray=[detailerArray mutableCopy];
                        [self.navigationController popViewControllerAnimated: YES];
                        
                        [self.navigationController pushViewController:requestVC animated:NO];
                    }
                    else{
                        homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];
                        [self.navigationController pushViewController:homeVC animated:NO];
                    }
                }
                else{
                    DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
                    [self saveWorkSampleData:userDetailDict];
                    [[NSUserDefaults standardUserDefaults]setValue:@"offline" forKey:@"Offline/Online Status"];
                    [self.navigationController pushViewController:homeVC animated:NO];
                }
            }
        }
    }
}



-(void)registerDevice
{
    webservice=4;
    
    NSString*deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    NSString*UDID=[[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];
    NSString*role=@"";
    
    NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    if ([userId isKindOfClass:[NSNull class]])
        
    {
        userId=@"";
        
    }
    
    if (userId.length!=0)
    {
        NSString* _postData = [NSString stringWithFormat:@"trigger=ios&role=%@&reg_id=%@&user_id=%@&ud_id=%@",role,deviceToken,userId,UDID ];
        
        NSLog(@"data post >>> %@",_postData);
        [kappDelegate ShowIndicator];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/insert-device.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
}






-(void)saveFavListToDatabase :(NSArray*)favDetailrList
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM favDetailers"];
    [database executeUpdate:queryString1];
    
    for (int k=0;k<favDetailrList.count;k++)
    {
        NSDictionary*detailrDict=[favDetailrList objectAtIndex:k];
        NSString*favDetailrId=[detailrDict valueForKey:@"detalier_id"];
        NSString*isFav=[detailrDict valueForKey:@"isFavourite"];
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO favDetailers (detailerId, IsFavorite, userId) VALUES (\"%@\", \"%@\",\"%@\")",favDetailrId,isFav,userId];
            [database executeUpdate:insert];
    }
    
    [database close];
    
}


-(void) saveWorkSampleData :(NSDictionary*)userDetailDict
{
    NSMutableArray *workSamplArray = [userDetailDict valueForKey:@"work_sample"];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM workSamples"];
    [database executeUpdate:queryString1];
    
    for (int i = 0; i < [workSamplArray count]; i++) {
        
        NSString *workSampleId = [[workSamplArray valueForKey:@"ID"] objectAtIndex:i];
        NSString *vehicledetail = [[workSamplArray valueForKey:@"makeAndModelDetails"] objectAtIndex:i];
        NSString *beforeImage = [[workSamplArray valueForKey:@"beforeImageUrl"] objectAtIndex:i];
        NSString *afterImage = [[workSamplArray valueForKey:@"afterImageUrl"] objectAtIndex:i];
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO workSamples (workSampleId,vehiclDetail,beforeImage,afterImage) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",workSampleId,vehicledetail,beforeImage,afterImage];
        [database executeUpdate:insert];
    }
    
    [database close];
}



-(void) saveLocationData :(NSDictionary*)userDetailDict
{
    NSMutableArray *vehicleInfoArray = [userDetailDict valueForKey:@"location_info"];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM locationsList"];
    [database executeUpdate:queryString1];
    
    for (int i = 0; i < [vehicleInfoArray count]; i++) {
        
        NSString *locationIDs = [[vehicleInfoArray valueForKey:@"ID"] objectAtIndex:i];
        NSString *locationsName = [[vehicleInfoArray valueForKey:@"name"] objectAtIndex:i];
        NSString *locationsAddress = [[vehicleInfoArray valueForKey:@"address"] objectAtIndex:i];
        NSString *locationsLatitude = [[vehicleInfoArray valueForKey:@"latitude"] objectAtIndex:i];
        NSString *locationsLongitude = [[vehicleInfoArray valueForKey:@"longitude"] objectAtIndex:i];
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO locationsList (locationId, loactionName, locationAddress, locationLatitude,locationLongitude) VALUES (\"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",locationIDs,locationsName,locationsAddress,locationsLatitude,locationsLongitude];
        [database executeUpdate:insert];
    }
    
    [database close];
}


-(void) saveVehicleData :(NSDictionary*)userDetailDict
{
    NSMutableArray *vehicleInfoArray = [userDetailDict valueForKey:@"vehicle_info"];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM vehiclesList"];
    [database executeUpdate:queryString1];
    for (int i = 0; i < [vehicleInfoArray count]; i++) {
        
        NSString *vehicleIDs = [[vehicleInfoArray valueForKey:@"ID"] objectAtIndex:i];
        NSString *vehicleColor = [[vehicleInfoArray valueForKey:@"color"] objectAtIndex:i];
        NSString *vehicleNumber = [[vehicleInfoArray valueForKey:@"vehicle_no"] objectAtIndex:i];
        NSString *vehicleMake = [[vehicleInfoArray valueForKey:@"vehicle_make"] objectAtIndex:i];
        NSString *vehicleModal = [[vehicleInfoArray valueForKey:@"vehicle_modal"] objectAtIndex:i];
        NSString *vehicleImage = [[vehicleInfoArray valueForKey:@"vehicle_imageUrl"] objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", vehicleImage]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        
        NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
        NSString *strEncoded = [Base64 encode:imgdata];
        
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO vehiclesList (vehicleId, vehicleColor, vehicleNumber, vehicleMake,vehicleModal,vehicleImageUrl) VALUES (\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\")",vehicleIDs,vehicleColor,vehicleNumber,vehicleMake,vehicleModal,vehicleImage];
        [database executeUpdate:insert];
    }
    [database close];
}



-(void) FetchBasicProfile
{
    webservice=2;
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

-(void) FetchFavDetailersWebCall
{
    webservice=3;
    
    NSString*lastupdated= @"";
    NSString*FavStr=@"";
    
    NSString*_postData = [NSString stringWithFormat:@"userId=%@&detailerId=-1&isFavorite=%@&last_updated=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],FavStr,lastupdated];
    
    
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mark-detailer.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
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





-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE from userProfile "];
    [database executeUpdate:deleteQuery];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [userDetailDict valueForKey:@"imageUrl"]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
    NSString *strEncoded = [Base64 encode:imgdata];
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setValue:strEncoded forKey:@"userImage"];
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO userProfile (userId, name, password, role, email , contact , image ,creditCardNumber) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\")",userId,[userDetailDict valueForKey:@"name"],[userDetailDict valueForKey:@"password"],[userDetailDict valueForKey:@"role"],[userDetailDict valueForKey:@"email"],[userDetailDict valueForKey:@"contact_info"],url,[userDetailDict valueForKey:@"CreditCardNumber"]];

    [database executeUpdate:insert];
    
    [database close];
}



@end
