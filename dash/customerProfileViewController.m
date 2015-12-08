//
//  customerProfileViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "customerProfileViewController.h"
#import "creditcardViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "addLocationViewController.h"
#import "uploadWorkSamplesViewController.h"


@interface customerProfileViewController ()

@end

@implementation customerProfileViewController
@synthesize backBtnHiden;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    steps2.hidden = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [uploadImageView setUserInteractionEnabled:YES];
    [uploadImageView addGestureRecognizer:singleTap];
    
   
    
    [super viewDidLoad];
    imageUploadBG.layer.borderColor = [UIColor grayColor].CGColor;
    imageUploadBG.layer.borderWidth = 1.0;
    imageUploadBG.layer.cornerRadius = 4.0;
    [imageUploadBG setClipsToBounds:YES];
    
 
    uploadBtn.layer.borderColor = [UIColor clearColor].CGColor;
    uploadBtn.layer.borderWidth = 1.0;
    uploadBtn.layer.cornerRadius = 4.0;
    [uploadBtn setClipsToBounds:YES];
    
       [self fetchProfileInfoFromDatabase];
    
    if ([backBtnHiden isEqualToString:@"YES"])
    {
        backBttn.hidden=YES;
        stepsmageView.hidden=YES;
        skipStepBtn.hidden=NO;
        steps2.hidden = NO;

        headerLbl.text=@"Build Your Profile";
        if ([self.registrationType isEqualToString:@"customer"]) {
            stepsmageView.image = [UIImage imageNamed:@"3steps-1.png"];
            steps2.hidden = YES;
            stepsmageView.hidden=NO;

        }else{
            
            // stepsmageView.image = [UIImage imageNamed:@"2steps-1.png"];
            stepsmageView.hidden = YES;
            steps2.hidden = NO;
            
            
        }

    }
    else{
        backView.frame=CGRectMake(backView.frame.origin.x,backView.frame.origin.y-70,backView.frame.size.width, backView.frame.size.height);
       
        stepsmageView.hidden=YES;
        backBttn.hidden=NO;
        headerLbl.text=@"DASH";
        skipStepBtn.hidden=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)uploadBtnAction:(id)sender {
if (imagedata==nil)
    
{
    return;
}
    
    [self uploadImage];
 }


-(void )uploadImage
{
    [kappDelegate ShowIndicator];
      
    webservice=2;
    NSDictionary *_params = @{@"name" : nameStr,
                              @"user_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                              @"email" : emailStr,
                              @"password" :passwrdStr,
                              @"phone" :contactStr};
    
    NSString *fileName = [NSString stringWithFormat:@"profilePic%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    // BASIC AUTH (if you need):
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // BASIC AUTH END
    
    NSString *URLString = [NSString stringWithFormat:@"%@/edit-profile.php",Kwebservices];
    
    /// !!! only jpg, have to cover png as well
    // image size ca. 50 KB
    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"img" fileName:fileName mimeType:@"image"];
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
                [self   FetchBasicProfile];
                
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
}



- (IBAction)skipStepBtnAction:(id)sender {
   // creditcardViewController *creditCardVC = [[creditcardViewController alloc] initWithNibName:@"creditcardViewController" bundle:nil];
   // creditCardVC.registrationType = self.registrationType;
   // creditCardVC.headerLblStr=headerLbl.text;
   // [self.navigationController pushViewController:creditCardVC animated:NO];
    if ([self.registrationType isEqualToString:@"customer"]) {
        addLocationViewController *addLocationVC = [[addLocationViewController alloc] initWithNibName:@"addLocationViewController" bundle:nil];
        addLocationVC.headerLblStr=headerLbl.text;
        
        [self.navigationController pushViewController:addLocationVC animated:NO];
    }else{
        uploadWorkSamplesViewController *uploadWorkSamplesVC = [[uploadWorkSamplesViewController alloc] initWithNibName:@"uploadWorkSamplesViewController" bundle:nil];
        uploadWorkSamplesVC.headerLblStr=headerLbl.text;
        uploadWorkSamplesVC.trigger=@"add";
        [self.navigationController pushViewController:uploadWorkSamplesVC animated:NO];
    }
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}



-(void)tapDetected{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}



#pragma mark - Action Sheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker
                           animated:YES completion:nil];
    }
    if (buttonIndex==0)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    uploadImageView.image = chosenImage;
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) fetchProfileInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM userProfile where userId=\"%@\" ",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        nameStr =[results stringForColumn:@"name"];
        emailStr =[NSString stringWithFormat:@"%@",[results stringForColumn:@"email"]];
        contactStr=[NSString stringWithFormat:@"%@",[results stringForColumn:@"contact"]];
        NSString*imgUrl=[results stringForColumn:@"image"];
        passwrdStr =[results stringForColumn:@"password"];

        creditCardStr=[NSString stringWithFormat:@"%@",[results stringForColumn:@"creditCardNumber"]];
        
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        
        if (imageURL==nil)
        {
            uploadImageView.image =[UIImage imageNamed:@"upload-img-watermark-2.png"];
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    imagedata=imageData;
                    uploadImageView.image = [UIImage imageWithData:imageData];
                });
            });

        }
    }
    [database close];
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
   
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(result==0)
        {
            if (webservice==2)
            {
                if ([backBtnHiden isEqualToString:@"YES"])
                {
                  //  creditcardViewController *creditCardVC = [[creditcardViewController alloc] initWithNibName:@"creditcardViewController" bundle:nil];
                  //  creditCardVC.registrationType = self.registrationType;
                  //  creditCardVC.headerLblStr=headerLbl.text;
                    
                  //  [self.navigationController pushViewController:creditCardVC animated:NO];
                    
                    if ([self.registrationType isEqualToString:@"customer"]) {
                        addLocationViewController *addLocationVC = [[addLocationViewController alloc] initWithNibName:@"addLocationViewController" bundle:nil];
                        addLocationVC.headerLblStr=headerLbl.text;
                        
                        [self.navigationController pushViewController:addLocationVC animated:NO];
                    }else{
                        uploadWorkSamplesViewController *uploadWorkSamplesVC = [[uploadWorkSamplesViewController alloc] initWithNibName:@"uploadWorkSamplesViewController" bundle:nil];
                        uploadWorkSamplesVC.headerLblStr=headerLbl.text;
                        uploadWorkSamplesVC.trigger=@"add";
                        [self.navigationController pushViewController:uploadWorkSamplesVC animated:NO];
                    }


                }
                else{
                    [self   FetchBasicProfile];
                    
                }
                
            }
            else if (webservice==3)
            {
                [kappDelegate HideIndicator];
                [self saveDataTodtaaBase:userDetailDict];
                
                if ([backBtnHiden isEqualToString:@"YES"])
                {
                   // creditcardViewController *creditCardVC = [[creditcardViewController alloc] initWithNibName:@"creditcardViewController" bundle:nil];
                  //  creditCardVC.registrationType = self.registrationType;
                  //  creditCardVC.headerLblStr=headerLbl.text;
                    
                  //  [self.navigationController pushViewController:creditCardVC animated:NO];
                    
                    if ([self.registrationType isEqualToString:@"customer"]) {
                        addLocationViewController *addLocationVC = [[addLocationViewController alloc] initWithNibName:@"addLocationViewController" bundle:nil];
                        addLocationVC.headerLblStr=headerLbl.text;
                        
                        [self.navigationController pushViewController:addLocationVC animated:NO];
                    }else{
                        uploadWorkSamplesViewController *uploadWorkSamplesVC = [[uploadWorkSamplesViewController alloc] initWithNibName:@"uploadWorkSamplesViewController" bundle:nil];
                        uploadWorkSamplesVC.headerLblStr=headerLbl.text;
                        uploadWorkSamplesVC.trigger=@"add";
                        [self.navigationController pushViewController:uploadWorkSamplesVC animated:NO];
                    }

                }
                else{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        }
    }
}


-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    
    NSString* updateSQL = [NSString stringWithFormat:@"UPDATE userProfile SET  name = \"%@\", email = \"%@\", password =\"%@\", role = \"%@\" ,contact = \"%@\" ,image =\"%@\", creditCardNumber = \"%@\"  where userId = %@" ,[userDetailDict valueForKey:@"name"],[userDetailDict valueForKey:@"email"],[userDetailDict valueForKey:@"password"],[userDetailDict valueForKey:@"role"],[userDetailDict valueForKey:@"contact_info"],[userDetailDict valueForKey:@"imageUrl"],[userDetailDict valueForKey:@"CreditCardNumber"],userId ];
    
    [database executeUpdate:updateSQL];
    
    [database close];
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

@end
