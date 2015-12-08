//
//  requestServiceViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/27/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "requestServiceViewController.h"
#import "endServiceViewController.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "mapDetailsObj.h"
#import "locationListObj.h"
#import "ServiceLocationViewController.h"
#import "addLocationViewController.h"
#import "homeViewViewController.h"
#import "DetailerFirastViewController.h"
#import "PaypalViewController.h"

@interface requestServiceViewController ()

@end

@implementation requestServiceViewController
@synthesize detailrId,detailrsArray;


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = NO;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}
- (void)viewDidLoad {
    //------loader----
   
    
    ///------webservice
    NSOperationQueue *que = [[NSOperationQueue alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/get-service-type.php",Kwebservices]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:que completionHandler:^(NSURLResponse *response ,NSData *data,NSError *err){
        dispatch_async(dispatch_get_main_queue(), ^{
            //   NSLog(@"Respons: %@",response);
            //   NSLog(@"data: %@",data);
            // NSLog(@"err: %@",err);
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",responseString);
            NSError *error;
            
            
            SBJsonParser *json = [[SBJsonParser alloc] init];
            NSMutableDictionary *userDetailDict = [[NSMutableDictionary alloc]init];
            userDetailDict=[json objectWithString:responseString error:&error];
            //     NSArray*servicesArray=[[userDetailDict valueForKey:@"service_data"]mutableCopy];
            
            AppDelegate *appdelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
           serviceTypeListarr = [[userDetailDict valueForKey:@"service_data"]mutableCopy];
            serviceTpeArray= [[NSMutableArray alloc] init];
            
            
            serviceTpeArray = serviceTypeListarr;
            [selectTypeTableView reloadData];
            appdelegate.serviceTypeList =[[userDetailDict valueForKey:@"service_data"]mutableCopy];
            //data = [NSData dataWithContentsOfURL:queryUrl];
            
        });
    }];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocAddress"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLatitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLongitude"];
    scheduleAtStr=@"now";
    
    [self getCarModal];
    
    lblpleaseselect.layer.borderColor = [UIColor grayColor].CGColor;
    lblpleaseselect.layer.borderWidth = 1.0;
    lblpleaseselect.layer.cornerRadius = 4.0;
    [lblpleaseselect setClipsToBounds:YES];
    
    
    
    
    carModaltableView.hidden = YES;
    backScrollView.scrollEnabled = YES;
    backScrollView.delegate = self;
    if (IS_IPHONE_6 || IS_IPHONE_6P)
    {
        backScrollView.contentSize = CGSizeMake(320,960);
        
    }else{
        backScrollView.contentSize = CGSizeMake(320, 860);
        
    }
    backScrollView.backgroundColor=[UIColor clearColor];
    
    NSLog(@"%@, %@",detailrId, detailrsArray);
    
    ResultsTableView.hidden=YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [dateTimePickr addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self fetchDataFromDb];
//  AppDelegate * appdelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //serviceTpeArray=[appdelegate.serviceTypeList  mutableCopy];
    
    serviceTimeArray= [[NSMutableArray alloc] initWithObjects:@"Now",@"Later", nil];
    anyOtheRReqBackLbl.layer.borderColor = [UIColor grayColor].CGColor;
    anyOtheRReqBackLbl.layer.borderWidth = 1.0;
    anyOtheRReqBackLbl.layer.cornerRadius = 4.0;
    [anyOtheRReqBackLbl setClipsToBounds:YES];
    
    modelBackLbl.layer.borderColor = [UIColor grayColor].CGColor;
    modelBackLbl.layer.borderWidth = 1.0;
    modelBackLbl.layer.cornerRadius = 4.0;
    [modelBackLbl setClipsToBounds:YES];
    
    makeBackLbl.layer.borderColor = [UIColor grayColor].CGColor;
    makeBackLbl.layer.borderWidth = 1.0;
    makeBackLbl.layer.cornerRadius = 4.0;
    [makeBackLbl setClipsToBounds:YES];
    
    vinBackLbl.layer.borderColor = [UIColor grayColor].CGColor;
    vinBackLbl.layer.borderWidth = 1.0;
    vinBackLbl.layer.cornerRadius = 4.0;
    [vinBackLbl setClipsToBounds:YES];
    
    colorBackLbl.layer.borderColor = [UIColor grayColor].CGColor;
    colorBackLbl.layer.borderWidth = 1.0;
    colorBackLbl.layer.cornerRadius = 4.0;
    [colorBackLbl setClipsToBounds:YES];
    
    selectLocationBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectLocationBtn.layer.borderWidth = 1.0;
    selectLocationBtn.layer.cornerRadius = 4.0;
    [selectLocationBtn setClipsToBounds:YES];
    
    selectServiceTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectServiceTimeBtn.layer.borderWidth = 1.0;
    selectServiceTimeBtn.layer.cornerRadius = 4.0;
    [selectServiceTimeBtn setClipsToBounds:YES];
    
    selectServiceTypeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectServiceTypeBtn.layer.borderWidth = 1.0;
    selectServiceTypeBtn.layer.cornerRadius = 4.0;
    [selectServiceTypeBtn setClipsToBounds:YES];
    
    selectDateBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectDateBtn.layer.borderWidth = 1.0;
    selectDateBtn.layer.cornerRadius = 4.0;
    [selectDateBtn setClipsToBounds:YES];
    
    selectTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectTimeBtn.layer.borderWidth = 1.0;
    selectTimeBtn.layer.cornerRadius = 4.0;
    [selectTimeBtn setClipsToBounds:YES];
    
    locationTxt.layer.borderColor = [UIColor grayColor].CGColor;
    locationTxt.layer.borderWidth = 1.0;
    locationTxt.layer.cornerRadius = 4.0;
    [locationTxt setClipsToBounds:YES];
    
    if (self.dateStr != nil) {
        if ([self.userType isEqualToString:@"detailer"]) {
            selectServiceTimeLbl.text = @"Later";
            selectServiceTimeBtn.hidden = YES;
            selectServiceTimeLbl.hidden = YES;
            [selectDateBtn setFrame:CGRectMake(selectDateBtn.frame.origin.x, 23, selectDateBtn.frame.size.width, selectDateBtn.frame.size.height)];
            [selectTimeBtn setFrame:CGRectMake(selectTimeBtn.frame.origin.x, 23, selectTimeBtn.frame.size.width, selectTimeBtn.frame.size.height)];
            [dateLbl setFrame:CGRectMake(dateLbl.frame.origin.x, 30, dateLbl.frame.size.width, dateLbl.frame.size.height)];
            [timeLbl setFrame:CGRectMake(timeLbl.frame.origin.x, 30, timeLbl.frame.size.width, timeLbl.frame.size.height)];
            [calenderImg setFrame:CGRectMake(calenderImg.frame.origin.x, 35, calenderImg.frame.size.width, calenderImg.frame.size.height)];
            [clockImg setFrame:CGRectMake(clockImg.frame.origin.x, 35, clockImg.frame.size.width, clockImg.frame.size.height)];
            
            
            [ResultsTableView setFrame:CGRectMake(ResultsTableView.frame.origin.x,ResultsTableView.frame.origin.y-23,ResultsTableView.frame.size.width, ResultsTableView.frame.size.height)];
            
            selectLocationBtn.hidden = YES;
            selectServiceLocationLbl.hidden= YES;
            locationTxt.hidden = NO;
            getMapLocationBtn.hidden = NO;
            [locationTxt setFrame:CGRectMake(locationTxt.frame.origin.x, 23, locationTxt.frame.size.width, locationTxt.frame.size.height)];
            [getMapLocationBtn setFrame:CGRectMake(getMapLocationBtn.frame.origin.x, 23, getMapLocationBtn.frame.size.width, getMapLocationBtn.frame.size.height)];
            
            lblpleaseselect.hidden = YES;
            carModelDropdown.hidden = YES;
            [pleaseSelectVehicleLblTitle setFrame:CGRectMake(pleaseSelectVehicleLblTitle.frame.origin.x, 155, pleaseSelectVehicleLblTitle.frame.size.width, pleaseSelectVehicleLblTitle.frame.size.height)];
            
            selectTimeBtn.hidden = NO;
            selectDateBtn.hidden = NO;
            calenderImg.hidden = NO;
            clockImg.hidden = NO;
            dateLbl.hidden = NO;
            timeLbl.hidden = NO;
            dateLbl.text = self.dateStr;
        }
        
        
    }
    [self.view bringSubviewToFront:selectServiceTypeBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString*locAddr= [[NSUserDefaults standardUserDefaults] valueForKey:@"LocAddress"];
    NSLog(@"%lu",(unsigned long)locAddr.length);
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];

    
    if (locAddr.length !=0)
    {
        locationTxt.text=locAddr;
        addressStr=locAddr;
        lattStr= [[NSUserDefaults standardUserDefaults] valueForKey:@"LocLatitude"];
        longStr=[[NSUserDefaults standardUserDefaults] valueForKey:@"LocLongitude"];
    }
    if ([locListNameArray count] > 1) {
        locationbtnforlocation.hidden =YES;
        
    }else{
        selectLocationBtnAction.hidden = YES;

        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadImageBtnAction:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)getMapLocationBtnAction:(id)sender
{
    
    ServiceLocationViewController*serviceVC=[[ServiceLocationViewController alloc]initWithNibName:@"ServiceLocationViewController" bundle:[NSBundle mainBundle]];
    
    serviceVC.locAddrssStr=addressStr;
    serviceVC.latitudeStr=lattStr;
    serviceVC.longitudeStr=longStr;
    NSLog(@"address,lat,lobg %@, %@ %@",addressStr,lattStr,longStr);
    [self.navigationController pushViewController:serviceVC  animated:YES];
}

- (IBAction)selectLocationBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    serviceLocationTableView.hidden = NO;
    selectTimeTableView.hidden=YES;
    selectTypeTableView.hidden=YES;
    carModaltableView.hidden = YES;
    
    serviceLocationTableView.layer.borderColor = [UIColor grayColor].CGColor;
    serviceLocationTableView.layer.borderWidth = 1.0;
    serviceLocationTableView.layer.cornerRadius = 4.0;
    [serviceLocationTableView setClipsToBounds:YES];
    
    locationTxt.layer.borderColor = [UIColor grayColor].CGColor;
    locationTxt.layer.borderWidth = 1.0;
    locationTxt.layer.cornerRadius = 4.0;
    [locationTxt setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:serviceLocationTableView];
    [serviceLocationTableView reloadData];
}

- (IBAction)selectServiceTimeBtnAction:(id)sender {
    selectTimeTableView.hidden = NO;
    serviceLocationTableView.hidden = YES;
    selectTypeTableView.hidden=YES;
    carModaltableView.hidden = YES;
    
    selectTimeTableView.layer.borderColor = [UIColor grayColor].CGColor;
    selectTimeTableView.layer.borderWidth = 1.0;
    selectTimeTableView.layer.cornerRadius = 4.0;
    [selectTimeTableView setClipsToBounds:YES];
    
    selectTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectTimeBtn.layer.borderWidth = 1.0;
    selectTimeBtn.layer.cornerRadius = 4.0;
    [selectTimeBtn setClipsToBounds:YES];
    
    selectDateBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectDateBtn.layer.borderWidth = 1.0;
    selectDateBtn.layer.cornerRadius = 4.0;
    [selectDateBtn setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:serviceLocationTableView];
    [selectTimeTableView reloadData];
}

- (IBAction)selectDateBtnAction:(id)sender {
    NSString *dateEnd;
    
    if (![dateLbl.text isEqualToString:@"Select Date"]) {
        dateEnd =dateLbl.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePickr.date=date2;
    }
    else{
        NSDate *defualtDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString*strDate=[formatter stringFromDate:defualtDate];
        
        NSDate *date2 = [formatter dateFromString:strDate];
        
        dateTimePickr.date = [NSDate date];
        
        dateTimePickr.date=date2;
        dateSelected=strDate;
    }
    
   timeSelectionType =@"Date";

    pickerBackView.hidden=NO;
    [self.view bringSubviewToFront:pickerBackView];
    dateTimePickr.datePickerMode=UIDatePickerModeDate;
 
}

- (IBAction)selectTimeBtnAction:(id)sender {
    NSString *dateEnd;
    if (![timeLbl.text isEqualToString:@"Select Time"]) {
        dateEnd =timeLbl.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePickr.date=date2;
    }
    else{
        NSDate *defualtDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString*strDate=[formatter stringFromDate:defualtDate];
        NSDate *date2 = [formatter dateFromString:strDate];
        dateTimePickr.date = [NSDate date];
        dateTimePickr.date=date2;
        timeSelected=strDate;
    }
    
    timeSelectionType =@"Time";
    
    pickerBackView.hidden=NO;
    [self.view bringSubviewToFront:pickerBackView];
    dateTimePickr.datePickerMode=UIDatePickerModeTime;
    
}

- (IBAction)selectserviceTypeBtnAction:(id)sender {
    selectTypeTableView.hidden = NO;
    serviceLocationTableView.hidden = YES;
    selectTimeTableView.hidden=YES;
    carModaltableView.hidden = YES;
    
    [self.view endEditing:YES];

    
    selectTypeTableView.layer.borderColor = [UIColor grayColor].CGColor;
    selectTypeTableView.layer.borderWidth = 1.0;
    selectTypeTableView.layer.cornerRadius = 4.0;
    [selectTypeTableView setClipsToBounds:YES];
    
  [self.view bringSubviewToFront:selectTypeTableView];
    [selectTypeTableView reloadData];
}

- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    
   
    if (colorTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter vehicle color." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if (vehicleNumberTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter VIN." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if (maketxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter vehicle make." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if (modeltxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter vehicle model." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (selectServiceLocationLbl.text.length==0 ||[selectServiceLocationLbl.text isEqualToString:@"-Select-"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select service location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (addressStr.length==0 )
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select service location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    if (selectServiceTypeLbl.text.length==0 ||[selectServiceTypeLbl.text isEqualToString:@"-Select-"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select service type." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    if (selectServiceTimeLbl.text.length==0 || [selectServiceTimeLbl.text isEqualToString:@"-Select-"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select service time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }

    if ([selectServiceTimeLbl.text isEqualToString:@"Later"])
    {
      
        if (dateLbl.text.length==0 ||[dateLbl.text isEqualToString:@"Select Date"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select service Date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }

        if (timeLbl.text.length==0||[timeLbl.text isEqualToString:@"Select Time"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please select service time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        NSDateFormatter*dateFormtr=[[NSDateFormatter alloc]init];
        NSDate *currntDate = [NSDate date] ;
        [dateFormtr setDateFormat:@"yyyy-MM-dd"];
        NSString*todayDateStr=[dateFormtr stringFromDate:currntDate];
        currntDate=[dateFormtr dateFromString:todayDateStr];
        
        NSDate *date1= [dateFormtr dateFromString:dateSelected];
        
        NSComparisonResult result3 = [currntDate compare:date1];
        
        if(result3 == NSOrderedDescending)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Titor Helper" message:@"Please select the valid service Date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        else if(result3 == NSOrderedAscending)
        {
            NSLog(@"date2 is later than date1");
        }
        else
        {
            
        }
        
        
        NSDate *currntDateTime = [NSDate date] ;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        NSString*todayDate=[df stringFromDate:currntDateTime];
        currntDateTime=[df dateFromString:todayDate];
        
        NSDate *time1= [dateFormtr dateFromString:timeSelected];
        
        
        NSComparisonResult result2 = [currntDateTime compare:time1];
        if(result2 == NSOrderedDescending && result3==NSOrderedSame)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Titor Helper" message:@"Please select the valid service time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        else if(result2 == NSOrderedAscending)
        {
            NSLog(@"date2 is later than date1");
        }
        else
        {
        }
    }
    
    
   if ([selectServiceTimeLbl.text isEqualToString:@"Later"])
   {
       scheduleAtStr=@"later";
       timeStr=[NSString stringWithFormat:@"%@ %@",dateLbl.text,timeLbl.text];

   }
   else if ([selectServiceTimeLbl.text isEqualToString:@"Now"])
   {
       scheduleAtStr=@"now";
       NSDateFormatter*dateFormtr=[[NSDateFormatter alloc]init];
       NSDate *currntDate = [NSDate date] ;
       [dateFormtr setDateFormat:@"yyyy-MM-dd HH:mm"];
       timeStr=[dateFormtr stringFromDate:currntDate];
   }
    
    if (imagedata ==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please upload image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (self.dateStr != nil) {
        if ([self.userType isEqualToString:@"detailer"]) {
            
            [self requestServiceWebCall :@"After"];
            return;
        }
    }else{
    paymentBackView.hidden=NO;
    }
}

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    uploadImage.image = chosenImage;

    float actualHeight = chosenImage.size.height;
    float actualWidth = chosenImage.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1.0;//50 percent compression
    
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



//{
//    
//    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    
//    uploadImage.image = chosenImage;
//    
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView == serviceLocationTableView) {
        if (locListNameArray.count<=4)
        {
             serviceLocationTableView.frame=CGRectMake(serviceLocationTableView.frame.origin.x, serviceLocationTableView.frame.origin.y, serviceLocationTableView.frame.size.width, 25*locListNameArray.count);
        }
       
        return [locListNameArray count];
        
    }else if (tableView == carModaltableView)
    {
        if (carModalArray.count<=4)
        {
            carModaltableView.frame=CGRectMake(carModaltableView.frame.origin.x, carModaltableView.frame.origin.y, carModaltableView.frame.size.width, 25*carModalArray.count);
        }
        return [carModalArray count];
    }
    else if (tableView == selectTypeTableView)
    {
        
            selectTypeTableView.frame=CGRectMake(selectTypeTableView.frame.origin.x, selectTypeTableView.frame.origin.y, selectTypeTableView.frame.size.width, 25*serviceTpeArray.count);
        
        
        return [serviceTpeArray count];
    }
    else if (tableView == selectTimeTableView)
    {
        if (serviceTimeArray.count<=4)
        {
            selectTimeTableView.frame=CGRectMake(selectTimeTableView.frame.origin.x, selectTimeTableView.frame.origin.y, selectTimeTableView.frame.size.width, 25*serviceTimeArray.count);
        }

        return [serviceTimeArray count];
    }

    else if (tableView == ResultsTableView)
    {
        
        NSLog(@"resultLocArray : %lu",(unsigned long)resultLocArray.count);
        if (resultLocArray.count<=4)
        {
            ResultsTableView.frame=CGRectMake(ResultsTableView.frame.origin.x, ResultsTableView.frame.origin.y, ResultsTableView.frame.size.width, 25*resultLocArray.count);
        }
        else{
            ResultsTableView.frame=CGRectMake(ResultsTableView.frame.origin.x, ResultsTableView.frame.origin.y, ResultsTableView.frame.size.width, 25*4);
        }
        
        return [resultLocArray count];
    }

    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        [cellBackground setImage:[UIImage imageNamed:@"list-bg.png"]];
        [cell.contentView addSubview:cellBackground];
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    
    if (tableView == serviceLocationTableView) {
       // locationListObj* locationList = (locationListObj*)[locationArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[locListNameArray objectAtIndex:indexPath.row ]];
    }
    else if (tableView == carModaltableView)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[carModalArray objectAtIndex:indexPath.row]];
        
    }
    else if (tableView == selectTypeTableView)
    {
       NSString*service_typeStr= [[serviceTpeArray objectAtIndex:indexPath.row]valueForKey:@"service_type"];

       // NSString*service_typeStr=[serviceTpeArray objectAtIndex:indexPath.row]valueForKey:@"service_type" ];
                                  
       // NSString*rate_detailsStr=[NSString stringWithFormat:@"%@",[serviceTpeArray objectAtIndex:indexPath.row]valueForKey:@"rate_details" ];

        cell.textLabel.text = [NSString stringWithFormat:@"%@",service_typeStr];
    }
    else if (tableView == selectTimeTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[serviceTimeArray objectAtIndex:indexPath.row]];
    }
    else if (tableView == ResultsTableView)
    {
        if (resultLocArray.count>0)
        {
            
            NSDictionary *result = [resultLocArray objectAtIndex:indexPath.row];
            
            addressStr=[result objectForKey:@"formatted_address"];
            
            cell.textLabel.text = addressStr;
            
        }
        

       // cell.textLabel.text = [NSString stringWithFormat:@"%@",[resultLocArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == serviceLocationTableView)
    {
        
        addressStr=@"";
        lattStr=@"";
        longStr=@"";
        serviceLocationTableView.hidden = YES;
        
        NSLog(@"newIndexPath: %ld", (long)indexPath.row);
        
        NSString* locnameStr =[locListNameArray objectAtIndex:indexPath.row];
        if([locnameStr isEqualToString:@"Others"])
        {
            
            selectServiceLocationLbl.text = locnameStr;
        }
        else{
            addressStr=@"";
            locationListObj* locationList = (locationListObj*)[locationArray objectAtIndex:indexPath.row];
            selectServiceLocationLbl.text = locationList.loactionName;
            addressStr=locationList.locationAddress;
            lattStr=locationList.locationLatitude;
            longStr=locationList.locationLongitude;
 
        }
        
        if ([locnameStr isEqualToString:@"Others"]) {
            getMapLocationBtn.hidden = NO;
            locationTxt.hidden = NO;
            ResultsTableView.hidden=NO;
            
            [selectServiceLocationView setFrame:CGRectMake(selectServiceLocationView.frame.origin.x, selectServiceLocationView.frame.origin.y, selectServiceLocationView.frame.size.width, selectServiceLocationView.frame.size.height)];
            
            [serviceTypeView setFrame:CGRectMake(serviceTypeView.frame.origin.x,selectServiceLocationView.frame.origin.y+selectServiceLocationView.frame.size.height+5,serviceTypeView.frame.size.width, serviceTypeView.frame.size.height)];
            
              [ResultsTableView setFrame:CGRectMake(ResultsTableView.frame.origin.x,serviceTypeView.frame.origin.y,ResultsTableView.frame.size.width, ResultsTableView.frame.size.height)];
          }
        else{
            
            getMapLocationBtn.hidden = YES;
            locationTxt.hidden = YES;
            ResultsTableView.hidden=YES;

            [selectServiceLocationView setFrame:CGRectMake(selectServiceLocationView.frame.origin.x, selectServiceLocationView.frame.origin.y, selectServiceLocationView.frame.size.width, selectServiceLocationView.frame.size.height)];
            
            
            [serviceTypeView setFrame:CGRectMake(serviceTypeView.frame.origin.x,selectServiceLocationView.frame.origin.y+selectServiceLocationView.frame.size.height/1.5,serviceTypeView.frame.size.width, serviceTypeView.frame.size.height)];
            
        }
    }
    
    else if (tableView == carModaltableView)
    {
        carModaltableView.hidden = YES;
        
      NSString *string = [NSString stringWithFormat:@"%@",[carModalArray objectAtIndex:indexPath.row]];
        lblpleaseselect.text = string;
        
         NSArray* foo = [string componentsSeparatedByString:@" "];
        colorTxt.text = [foo objectAtIndex:0];
        vehicleNumberTxt.text = [foo objectAtIndex:1];
        maketxt.text = [foo objectAtIndex:2];
        modeltxt.text = [foo objectAtIndex:3];
    }
    
    else if (tableView == selectTypeTableView) {
        selectTypeTableView.hidden = YES;
//        serviceTypeIdstr=[NSString stringWithFormat:@"%@",[serviceTpeArray objectAtIndex:indexPath.row]];
//        
//        selectServiceTypeLbl.text = [NSString stringWithFormat:@"%@",[serviceTpeArray objectAtIndex:indexPath.row]];
        
        NSString*service_typeStr= [[serviceTpeArray objectAtIndex:indexPath.row]valueForKey:@"service_type"];
        NSString*rate_detailsStr= [[serviceTpeArray objectAtIndex:indexPath.row]valueForKey:@"rate_details"];
        NSString*time_detailsStr= [[serviceTpeArray objectAtIndex:indexPath.row]valueForKey:@"estimated_time"];
        serviceTypeRateLbl.text=[NSString stringWithFormat:@"Approx price: $%@",rate_detailsStr];
        serviceTypeTimeLbl.text=[NSString stringWithFormat:@"Approx Time: %@",time_detailsStr];
        
        [self.view bringSubviewToFront:submitBtn];
        submitBtn.frame = CGRectMake(submitBtn.frame.origin.x, submitBtn.frame.origin.y+30, submitBtn.frame.size.width, submitBtn.frame.size.height);
        serviceTimeView.frame=CGRectMake(serviceTimeView.frame.origin.x, serviceTypeRateLbl.frame.origin.y+30, serviceTimeView.frame.size.width, serviceTimeView.frame.size.height);
        selectTimeTableView.frame=CGRectMake(selectTimeTableView.frame.origin.x, serviceTypeRateLbl.frame.origin.y+80, selectTimeTableView.frame.size.width, selectTimeTableView.frame.size.height);
        
        if (![selectServiceTimeLbl.text isEqualToString:@"Later"])
        {
            
            submitBtn.frame=CGRectMake(submitBtn.frame.origin.x, serviceTimeView.frame.origin.y+60, submitBtn.frame.size.width, submitBtn.frame.size.height);
        }

        
        
        
        
        serviceTypeIdstr=[NSString stringWithFormat:@"%@",service_typeStr];
        
        selectServiceTypeLbl.text = [NSString stringWithFormat:@"%@",service_typeStr];
    }
    else if (tableView == ResultsTableView) {
        ResultsTableView.hidden = YES;
        
        NSDictionary *result = [resultLocArray objectAtIndex:indexPath.row];
        NSDictionary *geometry = [result objectForKey:@"geometry"];
        NSDictionary*locationDict=[geometry objectForKey:@"location"];
        
        addressStr=[result objectForKey:@"formatted_address"];
        lattStr=[locationDict objectForKey:@"lat"];
        longStr=[locationDict objectForKey:@"lng"];
        
        locationTxt.text=[NSString stringWithFormat:@"%@",addressStr];
        //------
         if ([self.userType isEqualToString:@"detailer"]) {
        selectServiceLocationLbl.text =[NSString stringWithFormat:@"%@",addressStr];
         }
    }
    
    else if (tableView == selectTimeTableView)
    {
        selectTimeTableView.hidden = YES;
        selectServiceTimeLbl.text = [NSString stringWithFormat:@"%@",[serviceTimeArray objectAtIndex:indexPath.row]];
        if ([selectServiceTimeLbl.text isEqualToString:@"Later"]) {
            selectTimeBtn.hidden = NO;
            selectDateBtn.hidden = NO;
            calenderImg.hidden = NO;
            clockImg.hidden = NO;
            dateLbl.hidden = NO;
            timeLbl.hidden = NO;

            [self.view bringSubviewToFront:submitBtn];
            [submitBtn setFrame:CGRectMake(submitBtn.frame.origin.x, serviceTimeView.frame.origin.y+serviceTimeView.frame.size.height, submitBtn.frame.size.width, submitBtn.frame.size.height)];
            
            [serviceTimeView setFrame:CGRectMake(serviceTimeView.frame.origin.x,serviceTimeView.frame.origin.y,serviceTimeView.frame.size.width, serviceTimeView.frame.size.height)];
        }
        
        else{
            
            [submitBtn setFrame:CGRectMake(submitBtn.frame.origin.x, serviceTimeView.frame.origin.y+serviceTimeView.frame.size.height/2+10, submitBtn.frame.size.width, submitBtn.frame.size.height)];
            
            selectTimeBtn.hidden = YES;
            selectDateBtn.hidden = YES;
            calenderImg.hidden = YES;
            clockImg.hidden = YES;
            dateLbl.hidden = YES;
            timeLbl.hidden = YES;

        }
    }
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *strDate ;

    if ([timeSelectionType  isEqualToString:@"Date"] )
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        strDate = [dateFormatter stringFromDate:datePicker.date];

        dateSelected=strDate;

    }
    else
    {
        [dateFormatter setDateFormat:@"HH:mm"];
       strDate = [dateFormatter stringFromDate:datePicker.date];

        timeSelected=strDate;
        if ([self.userType isEqualToString:@"detailer"]) {
      //  selectServiceTimeLbl.text = strDate;
        }
        
    }
}
- (IBAction)doneDateSelectionBttn:(id)sender
{
    
    if ([timeSelectionType  isEqualToString:@"Date"])
    {
        
        NSDateFormatter*dateFormtr=[[NSDateFormatter alloc]init];
        NSDate *currntDate = [NSDate date] ;
        [dateFormtr setDateFormat:@"yyyy-MM-dd"];
        NSString*todayDateStr=[dateFormtr stringFromDate:currntDate];
        currntDate=[dateFormtr dateFromString:todayDateStr];
        
        NSDate *date1= [dateFormtr dateFromString:dateSelected];
        
        NSComparisonResult result3 = [currntDate compare:date1];
        
        if(result3 == NSOrderedDescending)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Titor Helper" message:@"Please select the valid service Date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        else if(result3 == NSOrderedAscending)
        {
            NSLog(@"date2 is later than date1");
        }
        else
        {
        }
        if (dateSelected.length==0) {
            return;
        }
        
        dateLbl.text=dateSelected;
        
        // startBtn.titleLabel.text = dateSelected;
    }
    else
    {
        timeLbl.text=timeSelected;
        // endBtn.titleLabel.text = dateSelected;
    }
    pickerBackView.hidden=YES;
    
}

- (IBAction)cancelDateSelectionBttn:(id)sender {
    dateSelected=@"";
    timeSelected=@"";
    pickerBackView.hidden=YES;
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)payInAdvanceBttn:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
   // [self requestServiceWebCall :@"Advance"];

   
    //----paypal
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"9.95"];
    
    payment.currencyCode = @"USD";
    payment.shortDescription = @"your charges";
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    //payment.shippingAddress = @"address"; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    //    if (!payment.processable) {
    //        // If, for example, the amount was negative or the shortDescription was empty, then
    //        // this payment would not be processable. You would want to handle that here.
    //    }
    
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (IBAction)payAfterServiceBttnn:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];

    [self requestServiceWebCall :@"After"];
}

- (IBAction)payMntBackBttn:(id)sender {
    paymentBackView.hidden=YES;
}

- (IBAction)locationbtnforlocation:(id)sender {
    addLocationViewController*addVehicle=[[addLocationViewController alloc]initWithNibName:@"addLocationViewController" bundle:[NSBundle mainBundle]];
    
    addVehicle.addLocationDataType = @"Edit";
    
    addVehicle.headerLblStr=@"DASH";
    
    addVehicle.triggervalue=@"Add";
    
    
    
    addVehicle.locationOC = locationListOC;
    
    [self.navigationController pushViewController:addVehicle animated:NO];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag==3)
    {
        [backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", textField.text];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        //  NSLog(@"query url%@",queryUrl);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchLongitudeAndLattitude:data];
        });

    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = backScrollView.contentOffset;
    carModaltableView.hidden = YES;
   
        if ( textField.tag ==3) {
            
            CGPoint pt;
            CGRect rc = [textField bounds];
            rc = [textField convertRect:rc toView:backScrollView];
            pt = rc.origin;
            pt.x = 0;
            
            
            pt.y -=90;
            [backScrollView setContentOffset:pt animated:YES];
        }
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    
    
    if (theTextField.tag==3)
    {
        NSString *substring = [NSString stringWithString:locationTxt.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
         substring = [substring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        
        NSOperationQueue *que = [[NSOperationQueue alloc] init];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", substring]]];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:que completionHandler:^(NSURLResponse *response ,NSData *data,NSError *err){
            dispatch_async(dispatch_get_main_queue(), ^{
                //data = [NSData dataWithContentsOfURL:queryUrl];
                [self fetchLongitudeAndLattitude:data];
            });
            
        }];
    }
    
    return YES;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocAddress"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLatitude"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLongitude"];
        homeViewViewController *obj = [[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:nil];
        
        [self.navigationController pushViewController:obj animated:YES];
    }else if (alertView.tag == 3)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocAddress"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLatitude"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLongitude"];
        DetailerFirastViewController *detailerView = [[DetailerFirastViewController alloc]init];
        [self.navigationController pushViewController:detailerView animated:YES];
    }
}
-(void)getCarModal
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM vehiclesList "];
    FMResultSet *queryResults = [database executeQuery:queryString];
    carModalArray = [[NSMutableArray alloc]init];
    
    
    while([queryResults next]) {
        locationListOC = [[locationListObj alloc]init];
        NSString *color = [queryResults stringForColumn:@"vehicleColor"];
        NSString *id = [queryResults stringForColumn:@"vehicleId"];
        NSString *vehNum = [queryResults stringForColumn:@"vehicleNumber"];
        NSString *vehicleMake = [queryResults stringForColumn:@"vehicleMake"];
        NSString *vehicleModal = [queryResults stringForColumn:@"vehicleModal"];
        NSString *carmodal = [NSString stringWithFormat:@"%@ %@ %@ %@",color,vehNum, vehicleMake,vehicleModal];
        
        [carModalArray addObject:carmodal];
        
    }
    
    
    //[carModalArray addObject:[NSString stringWithFormat:@"Others"]];
    [database close];
    [carModaltableView reloadData];
}

-(void)fetchDataFromDb
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM locationsList "];
    FMResultSet *queryResults = [database executeQuery:queryString];
    locationArray = [[NSMutableArray alloc]init];
    locListNameArray = [[NSMutableArray alloc]init];

    while([queryResults next]) {
        locationListOC = [[locationListObj alloc]init];
        locationListOC.loactionName = [queryResults stringForColumn:@"loactionName"];
        locationListOC.locationId = [queryResults stringForColumn:@"locationId"];
        locationListOC.locationAddress = [queryResults stringForColumn:@"locationAddress"];
        locationListOC.locationLatitude = [queryResults stringForColumn:@"locationLatitude"];
        locationListOC.locationLongitude = [queryResults stringForColumn:@"locationLongitude"];
        [locationArray addObject:locationListOC];
        [locListNameArray addObject:locationListOC.loactionName];
        
    }
    
    
    [locListNameArray addObject:[NSString stringWithFormat:@"Others"]];
    [database close];
    [serviceLocationTableView reloadData];
}



-(void )requestServiceWebCall :(NSString*)payment{
    
    // create a square
    CGFloat width = 150.0f;
    CGFloat height = width;
    
    // create the actual HUD
    hudView = [ [ UIView alloc ] initWithFrame:CGRectMake( (self.view.frame.size.width - width) / 2,
                                                          (self.view.frame.size.height - height) / 2+10,
                                                          width,
                                                          height)];
    // make sure to round off the corners
    hudView.layer.cornerRadius = 10.0f;
    
    hudView.backgroundColor = [ UIColor darkTextColor ];
    
    // create a spinner
    UIActivityIndicatorView *spinner = [ [ UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    
    [ spinner startAnimating ];
    
    CGFloat spinnerWidth = 37.0f;
    CGFloat spinnerHeight = spinnerWidth;
    
    // resize the spinner
    spinner.frame = CGRectMake((hudView.frame.size.width - spinnerWidth) / 2,
                               (hudView.frame.size.height - spinnerHeight) / 2,
                               spinnerWidth,
                               spinnerHeight);
    
    // add the spinner to the hud
    [ hudView addSubview:spinner ];
    
    // add the hud to us
    
    CGFloat xPadding = 5.0f;
    
    CGFloat labelHeight = 50.0f;
    
    CGFloat y =  (hudView.frame.size.height - labelHeight)/2 + labelHeight;
    
    CGFloat x = xPadding;
    
    // the width of the label should allow for 5 px of space from the edge
    CGFloat labelWidth = hudView.frame.size.width - ( xPadding * 2);
    
    
    // create the label
    UILabel *label = [ [ UILabel alloc ] initWithFrame:CGRectMake(x, y, labelWidth, labelHeight) ];
    
    // get rid of the white background
    label.backgroundColor = [ UIColor clearColor];
    
    label.numberOfLines = 3;
    // set the text and change the text color to white
    label.text = @"Thank you. Please wait while we locate an available Detailer.";
    label.textColor = [ UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [ UIFont systemFontOfSize:12.0f];
    
    [ hudView addSubview:label];
    
    [self.view addSubview:hudView ];
[paymentBackView bringSubviewToFront:hudView];
    
    UIView *abc = [ [ UIView alloc ] initWithFrame:CGRectMake( 0, 0,self.view.frame.size.width ,self.view.frame.size.height)];
    abc.alpha = 1.0;
     [self.view addSubview:abc ];
    [hudView bringSubviewToFront:abc];
    // make sure to round off the corners

    paymentbackbtn.hidden = YES;
    
   // paymentBackView.userInteractionEnabled = NO;
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"check_now_later"];
    
    [[NSUserDefaults standardUserDefaults]setValue:scheduleAtStr forKey:@"check_now_later"];
    NSString*detailarList;
    
     NSMutableArray*detailrIdArray=[[NSMutableArray alloc]init];
        for (int k=0;k<detailrsArray.count; k++)
        {
             mapDetailsObj *mapObj = (mapDetailsObj *)[detailrsArray objectAtIndex:k];
            [detailrIdArray addObject:mapObj.detailrId];
        }
    
    detailarList = [[detailrIdArray valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSString *det_id;
    NSString *det_lst;
    
    if([detailrId isEqualToString:@"-1"])
    {
        det_id = detailrId;
        det_lst = detailarList;
    }else{
        det_id = @"-1";
        det_lst =detailrId;
    }
    NSString*userid;
    if (self.dateStr != nil) {
        if ([self.userType isEqualToString:@"detailer"])
        {
            userid = @" ";
            det_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
        }
    }else {
    userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    }
    webservice=1;
    
    NSDictionary *_params = @{@"customer_id" : userid,
                              @"detailerId" : det_id,
                              @"address" : addressStr,
                              @"latitude" :lattStr,
                              @"longitude" :longStr,
                              @"serviceTypeId" : serviceTypeIdstr,
                              @"time" : timeStr,
                              @"vehicleColor" :colorTxt.text,
                              @"vehicleMake" :maketxt.text,
                              @"vehicleModal" : modeltxt.text,
                              @"vehicleNo" : vehicleNumberTxt.text,
                              @"nearest_detailers" :det_lst,
                              @"payment_mode" :payment,
                              @"scheduled_at" :scheduleAtStr,
                              @"special_requirements" :specialRequirmentTxt.text,
                              };
    
    NSString *fileName = [NSString stringWithFormat:@"servicePic%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    NSLog(@"%@",_params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    // BASIC AUTH (if you need):
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // BASIC AUTH END
    
    NSString *URLString = [NSString stringWithFormat:@"%@/request-service.php",Kwebservices];
    
    /// !!! only jpg, have to cover png as well
    // image size ca. 50 KB
    [manager POST:URLString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"img" fileName:fileName mimeType:@"image"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success %@", responseObject);
        
        
        if (![responseObject isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[responseObject valueForKey:@"message"];
            int result=[[responseObject valueForKey:@"result" ]intValue];
            UIAlertView *alert;
            if (result ==1)
            {
                
                
                alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [hudView removeFromSuperview];
                [abc removeFromSuperview];

                [alert show];
                  paymentBackView.userInteractionEnabled = YES;
            }
            else if(result==0)
            {
                
                
                if (self.dateStr != nil) {
                    if ([self.userType isEqualToString:@"detailer"])
                    {
                        [hudView removeFromSuperview];
                        [abc removeFromSuperview];

                        NSString *messageStr = [NSString stringWithFormat:@"Your assignment has been added successfully."];
                        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        alert.tag=3;
                        [alert show];
                        paymentBackView.userInteractionEnabled = YES;

                    }}else {
                
                        [hudView removeFromSuperview];
                        [abc removeFromSuperview];

                NSString *messageStr = [NSString stringWithFormat:@"Thank you for requesting DASH. Please wait while we locate an available Detailer."];
             //   UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
               // alert.tag=2;
              //  [alert show];
                        homeViewViewController *go_hone = [[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:nil];
                        [self.navigationController pushViewController:go_hone animated:YES];
                        paymentBackView.userInteractionEnabled = YES;

                    }
            }
            paymentbackbtn.hidden = NO;

        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure %@, %@", error, operation.responseString);
        paymentBackView.userInteractionEnabled = YES;
         paymentbackbtn.hidden = NO;
        
        [hudView removeFromSuperview];
        [abc removeFromSuperview];

        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"DASH" message:@"Somthing went wrong, Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [aler show];
    }];
}


-(void)fetchLongitudeAndLattitude:(NSData *)data
{
    ResultsTableView.hidden=NO;
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
  //  NSString *addressStr;
    resultLocArray =[[NSMutableArray alloc]init];
    
    
    if (results.count>0)
    {
        for (int i = 0;i <[results count]; i++)
        {
            NSDictionary *result = [results objectAtIndex:i];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
           
            NSDictionary*locationDict=[geometry objectForKey:@"location"];
            
            addressStr=[result objectForKey:@"formatted_address"];
            latitudeStr=[locationDict objectForKey:@"lat"];
            longitudeStr=[locationDict objectForKey:@"lng"];
            [resultLocArray addObject:result];
            
        }
    }
    
    [ResultsTableView reloadData];
    
}



- (IBAction)carModelDropdown:(id)sender {
    [self.view endEditing:YES];
    
    serviceLocationTableView.hidden = YES;
    selectTimeTableView.hidden=YES;
    selectTypeTableView.hidden=YES;
    carModaltableView.hidden = NO;
    
    carModaltableView.layer.borderColor = [UIColor grayColor].CGColor;
    carModaltableView.layer.borderWidth = 1.0;
    carModaltableView.layer.cornerRadius = 4.0;
    [carModaltableView setClipsToBounds:YES];
    
    lblpleaseselect.layer.borderColor = [UIColor grayColor].CGColor;
    lblpleaseselect.layer.borderWidth = 1.0;
    lblpleaseselect.layer.cornerRadius = 4.0;
    [lblpleaseselect setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:carModaltableView];
    [carModaltableView reloadData];
    
}
#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:confirmation encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];

    NSArray *array = [ userDetailDict valueForKey:@"response"];
    NSString *statestr = [array valueForKey:@"state"];
    if([statestr isEqualToString: @"approved"])
    {
        UIAlertView *alert = [[ UIAlertView alloc]initWithTitle:@"DASH" message:@"Payment Sucessful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
@end
