//
//  startServiceViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 5/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "startServiceViewController.h"
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
#import "endServiceViewController.h"
@interface startServiceViewController ()

@end

@implementation startServiceViewController

- (void)viewDidLoad {
    imagedata =nil;
    btnmenu.hidden = YES;
    menuIcon.hidden = YES;
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

- (IBAction)uploadImagebtnAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Camera"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)startServiceBtnAction:(id)sender {
    if(imagedata == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Kindly select an image to proceed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }else{
    updateRequestObj = [[updateRequest alloc]  init];
        
        
      
        
    NSString *state= @"StartService";
        NSString *serviceID = _reqid;
    [[NSUserDefaults standardUserDefaults]setValue:serviceID forKey:@"Service_Pref_id"];
    [[NSUserDefaults standardUserDefaults]setValue:state forKey:@"Service_Pref_state"];
        
    [updateRequestObj updateRequestWithImage:@"StartService" delegate:self service_id:_reqid startPic:imagedata endPic:nil];
      //   [updateRequestObj updateRequestWithImage:@"StartService" delegate:self service_id:@"273" startPic:imagedata endPic:nil];
    }
    
    
}
-(void)recivedResponce{
    updateRequestObj = [[updateRequest alloc]  init];
    NSString* status = [updateRequestObj statusValue];
    NSLog(@"%@", status);
    if ([status isEqualToString:@"True"]) {
        endServiceViewController *endVC = [[endServiceViewController alloc] initWithNibName:@"endServiceViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        endVC.reqid = _reqid;
        endVC.startServiceImage = _startPic1;
       
        [kappDelegate HideIndicator];
        [appDelegate.navigator pushViewController:endVC animated:NO];
        
    }
}


#pragma mark - Action Sheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 1)
    {
        [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    }else{
       
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
       // picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker
                           animated:YES completion:nil];
    }
}
#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    uploadImage.image = chosenImage;
    float actualHeight = chosenImage.size.height;
    float actualWidth = chosenImage.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [chosenImage drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    imagedata = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
}
@end
