//
//  addVehicleViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "addVehicleViewController.h"
#import "homeViewViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "Base64.h"
@interface addVehicleViewController ()

@end

@implementation addVehicleViewController
@synthesize headerLblStr,triggerValue,vehicleListOC;


- (void)viewDidLoad {
    [self fetchDataFromDb];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    headerLbl.text=headerLblStr;
    
    vehicleImage.hidden = YES;
    
    backBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
    backBgLbl.layer.borderWidth = 1.0;
    backBgLbl.layer.cornerRadius = 4.0;
    [backBgLbl setClipsToBounds:YES];

    addBtn.layer.borderColor = [UIColor grayColor].CGColor;
    addBtn.layer.borderWidth = 1.0;
    addBtn.layer.cornerRadius = 4.0;
    [addBtn setClipsToBounds:YES];
    
    uploadBtn.layer.borderColor = [UIColor clearColor].CGColor;
    uploadBtn.layer.borderWidth = 1.5;
    uploadBtn.layer.cornerRadius = 5.0;

    if ([self.addVehicleDataType isEqualToString:@"Edit"])
    {
       
        addVehicleScroller.frame = CGRectMake(addVehicleScroller.frame.origin.x, 120, addVehicleScroller.frame.size.width, addVehicleScroller.frame.size.height);

        backBttn.hidden=NO;
        skipThisStepBtn.hidden=YES;
        stepsImage.hidden=YES;
        if(![triggerValue isEqualToString:@"Add"])
        {
            colorTxt.text = [NSString stringWithFormat:@"%@",self.vehicleListOC.color];
            vehicleNumberTxt.text = [NSString stringWithFormat:@"%@",self.vehicleListOC.vehicle_no];
            vehicleMakeTxt.text = [NSString stringWithFormat:@"%@",self.vehicleListOC.vehicle_make];
            vehicleModalTxt.text = [NSString stringWithFormat:@"%@",self.vehicleListOC.vehicle_modal];
            RclImageBase64 = [NSString stringWithFormat:@"%@",self.vehicleListOC.vehicle_imageUrl];
            vehicleImageTxt.text = @"public.image";
            
            CGRect newFrame = backBgLbl.frame;
            newFrame.size.height = 368;
            backBgLbl.frame = newFrame;
            
            vehicleImage.hidden = NO;
            
            NSURL *imageURL = [NSURL URLWithString:vehicleListOC.vehicle_imageUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            vehicleImage.image = [UIImage imageWithData:imageData];
            
            CGRect newFrame1 = addBtn.frame;
            newFrame1.origin.y = 450;
            addBtn.frame = newFrame1;
            
            lblImage.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)uploadVehicleImageBtnAction:(id)sender {
    [vehicleModalTxt resignFirstResponder];
    [addVehicleScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)addBtnAction:(id)sender {
    if (colorTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Vehicle Color." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (vehicleNumberTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter VIN." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (vehicleMakeTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Vehicle Make." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (vehicleModalTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Vehicle Modal." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (vehicleImageTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select vehicle image." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        
        for (int k=0; k<vehicleListArray.count; k++)
        {
            vehiclesLIstObj*vehListObj=(vehiclesLIstObj*)[vehicleListArray objectAtIndex:k];
            NSString*vehicleNum=vehicleNumberTxt.text;
            
            if ([vehListObj.vehicle_no isEqualToString:vehicleNum])
            {
                vehicleListOC=vehListObj;
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"You have already added this vehicle. would you like to change this vehicle information?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                alert.tag=4;
                
                [alert show];
                return;
            }
        }
        
        
        [self addVehicle];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4 && buttonIndex ==1)
    {
        triggerValue=@"edit";
        [self addVehicle];
    }
}

-(void)fetchDataFromDb
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM vehiclesList "];
    FMResultSet *queryResults = [database executeQuery:queryString];
    vehicleListArray = [[NSMutableArray alloc]init];
    while([queryResults next]) {
       vehiclesLIstObj* vehiclesListOC = [[vehiclesLIstObj alloc]init];
        vehiclesListOC.vehicle_make = [queryResults stringForColumn:@"vehicleMake"];
        vehiclesListOC.vehicle_modal = [queryResults stringForColumn:@"vehicleModal"];
        vehiclesListOC.vehicle_no = [queryResults stringForColumn:@"vehicleNumber"];
        vehiclesListOC.vehicleId = [queryResults stringForColumn:@"vehicleId"];
        vehiclesListOC.vehicle_imageUrl = [queryResults stringForColumn:@"vehicleImageUrl"];
        vehiclesListOC.color = [queryResults stringForColumn:@"vehicleColor"];
        [vehicleListArray addObject:vehiclesListOC];
    }
    [database close];
}



- (IBAction)skipStepBtnAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Profile Build"];
    homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];

    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Sheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
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
    
    UIImage *  chosenImage = info[UIImagePickerControllerOriginalImage];
   
    
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
    imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    vehicleImage.image = [UIImage imageWithData:imageData];
    vehicleImageTxt.text = [NSString stringWithFormat:@"%@",info[UIImagePickerControllerMediaType]];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [addVehicleScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
   svos = addVehicleScroller.contentOffset;
    
    if (textField == vehicleMakeTxt|| textField == vehicleModalTxt || textField == vehicleNumberTxt) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:addVehicleScroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y -=70;
        [addVehicleScroller setContentOffset:pt animated:YES];
    }
}

-(void)addVehicle{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    vehicleID = @"0";
    color = [NSString stringWithFormat:@"%@",colorTxt.text];
    vehicleNO  = [NSString stringWithFormat:@"%@",vehicleNumberTxt.text];
    make = [NSString stringWithFormat:@"%@",vehicleMakeTxt.text];
    modal = [NSString stringWithFormat:@"%@",vehicleModalTxt.text];
    
    imageUrl = [NSString stringWithFormat:@"%@",RclImageBase64];
   
    
    NSDictionary *_params;
    if ([self.addVehicleDataType isEqualToString:@"Edit"])
    {
        if ([triggerValue isEqualToString:@"Add"]) {
            webservice=1;
            trigger = [NSString stringWithFormat:@"add"];
            _params = @{@"vehicle_id" : vehicleID,
                        @"user_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                        @"color" : color,
                        @"vehicleNo" :vehicleNO,
                        @"make" :make,
                        @"modal":modal,
                        @"imageUrl": @"",
                        @"trigger" :trigger
                        };
  
        }
        else{
            webservice=2;
            
            trigger = [NSString stringWithFormat:@"edit"];
            _params = @{@"vehicle_id" : self.vehicleListOC.vehicleId,
                        @"user_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                        @"color" : color,
                        @"vehicleNo" :vehicleNO,
                        @"make" :make,
                        @"modal":modal,
                        @"imageUrl": @"",
                        @"trigger" :trigger};
        }
       
    }
    else{
       
        webservice=1;
        trigger = [NSString stringWithFormat:@"add"];
        _params = @{@"vehicle_id" : vehicleID,
                                  @"user_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                                  @"color": color,
                                  @"vehicleNo":vehicleNO,
                                  @"make" :make,
                                  @"modal":modal,
                                  @"imageUrl":@"",
                                  @"trigger":trigger};
    }

    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    // BASIC AUTH (if you need):
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // BASIC AUTH END
    
    NSString *URLString = [NSString stringWithFormat:@"%@/location-vehicle.php",Kwebservices];
    
    /// !!! only jpg, have to cover png as well
    // image size ca. 50 KB
    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"img" fileName:fileName mimeType:@"image"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success %@", responseObject);
        NSMutableArray *vehicleInfoArray = [responseObject valueForKey:@"vehicle_info"];
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
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO vehiclesList (vehicleId, vehicleColor, vehicleNumber, vehicleMake,vehicleModal,vehicleImageUrl) VALUES (\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\")",vehicleIDs,vehicleColor,vehicleNumber,vehicleMake,vehicleModal,vehicleImage];
            [database executeUpdate:insert];
        }
        [database close];
        [kappDelegate HideIndicator];
        if ([self.addVehicleDataType isEqualToString:@"Edit"])
        {
           [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] animated:NO];
            
        }
        else{
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Profile Build"];
            homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];
            [self.navigationController pushViewController:homeVC animated:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
}


//#pragma mark - Delegate
//
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"Received Response");
//    [webData setLength: 0];
//}
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    [kappDelegate HideIndicator];
//    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
//    NSLog(@"ERROR with the Connection ");
//    webData =nil;
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
//{
//    [webData appendData:data1];
//}
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [kappDelegate HideIndicator];
//    
//    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
//    
//    if ([webData length]==0)
//        return;
//    
//    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
//    NSLog(@"responseString:%@",responseString);
//    NSError *error;
//    
//    
//    SBJsonParser *json = [[SBJsonParser alloc] init];
//    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
//    NSMutableArray *vehicleInfoArray = [userDetailDict valueForKey:@"vehicle_info"];
//    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    documentsDir = [docPaths objectAtIndex:0];
//    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
//    database = [FMDatabase databaseWithPath:dbPath];
//    [database open];
//    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM vehiclesList"];
//    [database executeUpdate:queryString1];
//    for (int i = 0; i < [vehicleInfoArray count]; i++) {
//        
//        NSString *vehicleIDs = [[vehicleInfoArray valueForKey:@"ID"] objectAtIndex:i];
//        NSString *vehicleColor = [[vehicleInfoArray valueForKey:@"color"] objectAtIndex:i];
//        NSString *vehicleNumber = [[vehicleInfoArray valueForKey:@"vehicle_no"] objectAtIndex:i];
//        NSString *vehicleMake = [[vehicleInfoArray valueForKey:@"vehicle_make"] objectAtIndex:i];
//        NSString *vehicleModal = [[vehicleInfoArray valueForKey:@"vehicle_modal"] objectAtIndex:i];
//        NSString *vehicleImage = [[vehicleInfoArray valueForKey:@"vehicle_imageUrl"] objectAtIndex:i];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", vehicleImage]];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [UIImage imageWithData:data];
//        
//        NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
//        NSString *strEncoded = [Base64 encode:imgdata];
//        
//        
//        NSString *insert = [NSString stringWithFormat:@"INSERT INTO vehiclesList (vehicleId, vehicleColor, vehicleNumber, vehicleMake,vehicleModal,vehicleImageUrl) VALUES (\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\")",vehicleIDs,vehicleColor,vehicleNumber,vehicleMake,vehicleModal,vehicleImage];
//        [database executeUpdate:insert];
//        
//        
//    }
//    [database close];
//    
//    if ([self.addVehicleDataType isEqualToString:@"Edit"])
//    {
//       
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] animated:NO];
//
//        
//    }
//    else{
//        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Profile Build"];
//        homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];
//        [self.navigationController pushViewController:homeVC animated:NO];
//    }
//  
//
//}

@end
