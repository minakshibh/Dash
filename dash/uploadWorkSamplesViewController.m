//
//  uploadWorkSamplesViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/25/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "uploadWorkSamplesViewController.h"
#import "workSampleTableViewCell.h"
#import "AsyncImageView.h"
#import "DetailerFirastViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"


@interface uploadWorkSamplesViewController ()

@end

@implementation uploadWorkSamplesViewController
@synthesize headerLblStr,trigger,workSampleOC,backBtnHiden;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    headerLbl.text=headerLblStr;
    [super viewDidLoad];
   // [self fetchWorksampleInfoFromDatabase];

    uploadFirstImg.layer.borderColor = [UIColor clearColor].CGColor;
    uploadFirstImg.layer.borderWidth = 1.5;
    uploadFirstImg.layer.cornerRadius = 5.0;
    
    uploadAfterImh.layer.borderColor = [UIColor clearColor].CGColor;
    uploadAfterImh.layer.borderWidth = 1.5;
    uploadAfterImh.layer.cornerRadius = 5.0;

    addVehicleBtn.layer.borderColor = [UIColor grayColor].CGColor;
    addVehicleBtn.layer.borderWidth = 1.0;
    addVehicleBtn.layer.cornerRadius = 4.0;
    [addVehicleBtn setClipsToBounds:YES];
    
    addMoreBtn.layer.borderColor = [UIColor grayColor].CGColor;
    addMoreBtn.layer.borderWidth = 1.0;
    addMoreBtn.layer.cornerRadius = 4.0;
    [addMoreBtn setClipsToBounds:YES];
    
    getStartedBtn.layer.borderColor = [UIColor grayColor].CGColor;
    getStartedBtn.layer.borderWidth = 1.0;
    getStartedBtn.layer.cornerRadius = 4.0;
    [getStartedBtn setClipsToBounds:YES];
    
    backView.layer.borderColor = [UIColor grayColor].CGColor;
    backView.layer.borderWidth = 1.0;
    backView.layer.cornerRadius = 4.0;
    [backView setClipsToBounds:YES];
    
    if ([backBtnHiden isEqualToString:@"NO"])
    {
        backbtn.hidden=NO;
        stepsImg.hidden=YES;
        skipStepBttn.hidden=YES;
        backScrollView.frame=CGRectMake(backScrollView.frame.origin.x, backScrollView.frame.origin.y-40, backScrollView.frame.size.width, backScrollView.frame.size.height);

    }
    if ([trigger isEqual:@"edit"])
    {
        backbtn.hidden=NO;
        stepsImg.hidden=YES;
        skipStepBttn.hidden=YES;
        backScrollView.frame=CGRectMake(backScrollView.frame.origin.x, backScrollView.frame.origin.y-40, backScrollView.frame.size.width, backScrollView.frame.size.height);
        
        enterVehicleDetailTxt.text=[NSString stringWithFormat:@"%@",workSampleOC.vehicleDetail ];
        beforeImageStr=workSampleOC.beforeServiceUrl;
        afterImageStr=workSampleOC.afterServiceUrl;
        
        NSURL *afterImageURL = [NSURL URLWithString:afterImageStr];
        afterImageData = [NSData dataWithContentsOfURL:afterImageURL];
        
        NSURL *beforImageURL = [NSURL URLWithString:beforeImageStr];
        beforeImageData = [NSData dataWithContentsOfURL:beforImageURL];

        [uploadFirstImg setTitle:@"EDIT" forState:UIControlStateNormal];
        [uploadAfterImh setTitle:@"EDIT" forState:UIControlStateNormal];

        beforeCarImageTxt.text=@"public.image";
        afterCarImageTxt.text=@"public.image";
        [addVehicleBtn setTitle:@"Update" forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{

}


-(void) fetchWorksampleInfoFromDatabase
{
    worksampleDetails=[[NSMutableArray alloc]init];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM workSamples"];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        workSampleObj*workObj=[[workSampleObj alloc]init];
        
        workObj.workSampleId  =[results stringForColumn:@"workSampleId"];
        workObj.vehicleDetail =[results stringForColumn:@"vehiclDetail"];
        workObj .beforeServiceUrl=[results stringForColumn:@"beforeImage"];
        workObj.afterServiceUrl=[results stringForColumn:@"afterImage"];
        
        [worksampleDetails addObject:workObj];
    }
    [workSampleTableView reloadData];
    
    if (worksampleDetails.count==0)
    {
        beforBtn.hidden=YES;
        afterBtn.hidden=YES;
    }
    [database close];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)uploadBeforeImageBtnAction:(id)sender {
    isBeforeImage = YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)uploadAfterImageBtnAction:(id)sender {
    isBeforeImage = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)addBtnAction:(id)sender
{
    
    if (enterVehicleDetailTxt.text.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please enter Car details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    else if (beforeCarImageTxt.text.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please upload before Car image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    else if (afterCarImageTxt.text.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please upload after Car image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [kappDelegate ShowIndicator];
   
    
    NSDictionary *_params;
    if ([trigger isEqualToString:@"edit"])
    {
        webservice=2;
        _params = @{@"worksample_id" :workSampleOC.workSampleId,
                    @"carDetails" : enterVehicleDetailTxt.text,
                    @"user_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                    @"trigger" :trigger};
        
    }
    else
    {
        webservice=1;
        _params = @{@"worksample_id" :@"0",
                    @"carDetails" : enterVehicleDetailTxt.text,
                    @"user_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                    @"trigger" :trigger};
        
    }
    
    NSString *afterFileName = [NSString stringWithFormat:@"after%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    NSString *beforeFileName = [NSString stringWithFormat:@"before%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    // BASIC AUTH (if you need):
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // BASIC AUTH END
    
    NSString *URLString = [NSString stringWithFormat:@"%@/work-sample.php",Kwebservices];
    
    /// !!! only jpg, have to cover png as well
    // image size ca. 50 KB
    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:afterImageData name:@"afterImage" fileName:afterFileName mimeType:@"image"];
        [formData appendPartWithFileData:beforeImageData name:@"beforeImage" fileName:beforeFileName mimeType:@"image"];
        
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
                [self saveWorkSampleData:responseObject];
                if (webservice==1)
                {
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your work sample added Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag=1;
                    [alert show];
                }
                else if (webservice==2)
                {
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your work sample updated Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag=2;
                    [alert show];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
    }];
}

- (IBAction)backBtnAction:(id)sender {
    DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)skipStepBtnAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Profile Build"];
    DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getStartedBttn:(id)sender {
    DetailerFirastViewController*firstVc=[[DetailerFirastViewController alloc]initWithNibName:@"DetailerFirastViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:firstVc animated:YES];
}

- (IBAction)addMoreSampleBttn:(id)sender {
    [uploadedSampleView removeFromSuperview];
    enterVehicleDetailTxt.text=@"";
    beforeCarImageTxt.text=@"";
    afterCarImageTxt.text=@"";
    beforeImageStr=@"";
    afterImageStr=@"";
    [uploadAfterImh setTitle:@"UPLOAD" forState:UIControlStateNormal];
    [uploadFirstImg setTitle:@"UPLOAD" forState:UIControlStateNormal];

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
    
    
    if (isBeforeImage) {
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [chosenImage drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        beforeImageData = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        beforeCarImageTxt.text = [NSString stringWithFormat:@"%@",info[UIImagePickerControllerMediaType]];
        [uploadFirstImg setTitle:@"EDIT" forState:UIControlStateNormal];
        
    }else{
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [chosenImage drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        afterImageData = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        afterCarImageTxt.text = [NSString stringWithFormat:@"%@",info[UIImagePickerControllerMediaType]];
        [uploadAfterImh setTitle:@"EDIT" forState:UIControlStateNormal];
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [worksampleDetails count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    
    
    workSampleOC = [worksampleDetails objectAtIndex:indexPath.row];
    AsyncImageView *beforetemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",workSampleOC.beforeServiceUrl];
    beforetemImage.imageURL = [NSURL URLWithString:imageUrls];
    beforetemImage.showActivityIndicator = YES;
    if (IS_IPHONE_6P || IS_IPHONE_6 ) {
        beforetemImage.frame = CGRectMake(8 , 30, 160 , 100);
    }else{
        beforetemImage.frame = CGRectMake(5 , 30, 150 , 100);
    }
    
    [cell.contentView addSubview:beforetemImage];
    
    AsyncImageView *afterItemImage = [[AsyncImageView alloc] init];
    NSString *afterimageUrls = [NSString stringWithFormat:@"%@",workSampleOC.afterServiceUrl];
    afterItemImage.imageURL = [NSURL URLWithString:afterimageUrls];
    afterItemImage.showActivityIndicator = YES;
    
    
    if (IS_IPHONE_6P || IS_IPHONE_6 ) {
        afterItemImage.frame = CGRectMake(180 , 30, 160 , 100);
    }
    else{
        afterItemImage.frame = CGRectMake(160 , 30, 150 , 100);
    }
    
    [cell.contentView addSubview:afterItemImage];
    return cell;
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
            [self saveWorkSampleData:userDetailDict];
            if (webservice==1)
            {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your work sample added Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=1;
                [alert show];
            }
            else if (webservice==2)
            {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your work sample updated Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=2;
                [alert show];
            }
        }
    }
}


-(void) saveWorkSampleData :(NSDictionary*)userDetailDict
{
    NSMutableArray *workSamplArray = [userDetailDict valueForKey:@"sample_info"];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM workSamples"];
    [database executeUpdate:queryString1];
    
    for (int i = 0; i < [workSamplArray count]; i++) {
        
        NSString *workSampleId = [[workSamplArray valueForKey:@"ID"] objectAtIndex:i];
        NSString *vehicledetail = [[workSamplArray valueForKey:@"car_details"] objectAtIndex:i];
        NSString *beforeImage = [[workSamplArray valueForKey:@"bfr_img_url"] objectAtIndex:i];
        NSString *afterImage = [[workSamplArray valueForKey:@"after_img_url"] objectAtIndex:i];
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO workSamples (workSampleId,vehiclDetail,beforeImage,afterImage) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",workSampleId,vehicledetail,beforeImage,afterImage];
        [database executeUpdate:insert];
    }
    
    [database close];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    if (alertView.tag == 1 )
    {
        if (IS_IPHONE_6 || IS_IPHONE_6P ) {
            [uploadedSampleView setFrame:CGRectMake(0, 100, uploadedSampleView.frame.size.width, uploadedSampleView.frame.size.height+100)];
        }else{
            [uploadedSampleView setFrame:CGRectMake(0, 100, 320, uploadedSampleView.frame.size.height-50)];
        }
        
        [self.view addSubview:uploadedSampleView];
        
        
        if (backbtn.hidden==NO)
        {
            [getStartedBtn setTitle:@"Done" forState:UIControlStateNormal];
        }
        
        
        [self fetchWorksampleInfoFromDatabase];
    }
    else if (alertView.tag == 2 )
    {
      [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] animated:NO];
    }
}



@end
