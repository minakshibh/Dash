//
//  homeViewViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//
#import "AppDelegate.h"
#import "homeViewViewController.h"
#import "detailerViewController.h"
#import "AsyncImageView.h"
#import "customerProfileViewController.h"
#import "vehicleListViewController.h"
#import "registerViewController.h"
#import "requestServiceViewController.h"
#import "NSData+Base64.h"
#import "locationListViewController.h"
#import "loginViewController.h"
#import "MyprofileViewController.h"
#import "WorkSamplesViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "RegisterationRoleViewController.h"
#import "assignmentsViewController.h"
#import "AppDelegate.h"
#import "notificationViewController.h"
#import "customerRatingViewController.h"
#import "confirmServiceViewController.h"
#import "notificationViewController.h"
#import "TagSampleViewController.h"
@interface homeViewViewController ()

@end

@implementation homeViewViewController
int i =1;
NSTimer *timer;
NSArray *skills_id_array,*skills_vehicleDesc_array,*img_arr;
- (void)viewDidLoad
{
    img_arr = [[NSArray alloc]initWithObjects:@"comfort_03.png",@"luxury_03.png",@"classic_03.png",@"suv_03.png",@"bus_03.png",@"semi_truck_03.png",@"boat_03.png",@"bike_03.png", nil];
    //------slider back image set-----
//    UIImage *clearImage = [[UIImage imageNamed:@"progressBar.png"] stretchableImageWithLeftCapWidth:14.0 topCapHeight:0.0];
//    [slideroutlet setMinimumTrackImage:clearImage forState:UIControlStateNormal];
//    [slideroutlet setMaximumTrackImage:clearImage forState:UIControlStateNormal];
    [self.view bringSubviewToFront:slideroutlet];
    
     [slideroutlet setThumbImage:[UIImage imageNamed:@"icon_06.png"] forState:UIControlStateNormal];
    
    [slideroutlet addTarget:self
               action:@selector(sliderDidEndSliding:)
     forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    lblComfort.text = @"COMFORT CALENDER";

    
    skills_id_array =[[NSArray alloc]init];
    skills_vehicleDesc_array = [[NSArray alloc]init];
    
    NSUserDefaults *user_default = [NSUserDefaults standardUserDefaults];
    skills_id_array = [user_default valueForKey:@"get_available_skills_id"];
    skills_vehicleDesc_array = [user_default valueForKey:@"get_available_skills_vehicleDesc"];
    if (skills_id_array.count>0)
    {
        selected_Vehcl_Id=[NSString stringWithFormat:@"%@",[skills_id_array objectAtIndex:0]];
    }

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addSlider:) userInfo:nil repeats:NO];

    
//    frame.origin.y = 250;
//    addNameView.frame = frame;
    //------end-----slider action------
    
    
    [mapView_ bringSubviewToFront:sideView];

    [self.view addSubview:_testView];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.testView addGestureRecognizer:singleTapGestureRecognizer];
    
          lblTime.text = @" ";
            
    distance =[[ NSMutableArray alloc] init];
     sideView.hidden=YES;
     [self registerDevice];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    detailerListArray=[[NSMutableArray alloc]init];
    [super viewDidLoad];
 
    menuIconImg.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

    [viewAsMapBtn setBackgroundColor:[UIColor blackColor]];
    
    [nameSort setBackgroundColor:[UIColor blackColor]];
    [distancSort setBackgroundColor:[UIColor lightGrayColor]];
    [feesSort setBackgroundColor:[UIColor lightGrayColor]];
    [ratingSort setBackgroundColor:[UIColor lightGrayColor]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    cur_lat=[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    cur_long=[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
 
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[cur_lat floatValue] longitude:[cur_long floatValue] zoom:11];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 60, self.view.frame.size.width , self.view.frame.size.height-420)camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 70, self.view.frame.size.width , self.view.frame.size.height-370) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 85, self.view.frame.size.width , self.view.frame.size.height-300) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 90, self.view.frame.size.width , self.view.frame.size.height-250) camera:camera];
    }
     [mapView_ setDelegate:self];
     mapView_.settings.myLocationButton = YES;
     mapView_.settings.compassButton = YES;
     mapView_.myLocationEnabled = YES;
     [self.view addSubview:mapView_];
    
     [self.view bringSubviewToFront:detailrDetailBackView];
     [self.view bringSubviewToFront:viewAsListBtn];
     [self.view bringSubviewToFront:viewAsMapBtn];
     [self.view bringSubviewToFront:sideView];

     profileImage.layer.borderColor = [UIColor grayColor].CGColor;
     profileImage.layer.borderWidth = 1.5;
     profileImage.layer.cornerRadius = 10.0;
     [profileImage setClipsToBounds:YES];
}
-(void)addSlider:(NSTimer *)timer
{
    CGRect frame = slideroutlet.frame;
    
    float y = frame.origin.y;
    float x = frame.origin.x;
    float width = frame.size.width;
    
    float size_of_partition = (width-15)/(skills_id_array.count-1);
    UIImageView *image_view ;
    UILabel*vehicleNameLbl;
    
    for (int i=0; i<skills_id_array.count; i++)
    {
        image_view = [[UIImageView alloc]initWithFrame:CGRectMake(x+size_of_partition*i , y+8, 16, 16)];
        image_view.image = [UIImage imageNamed:[img_arr objectAtIndex:i]];
        image_view.tag=i+100;
        if (i==0)
        {
            image_view.image = [UIImage imageNamed:@"icon_06.png"];

        }
        [self.view addSubview:image_view];
        
        
        float xOfLbl=image_view.frame.origin.x+image_view.frame.size.width/2-((width/skills_id_array.count)/2);
       
        
        vehicleNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOfLbl, y+22, width/skills_id_array.count+4, 16)];
        vehicleNameLbl.textAlignment=NSTextAlignmentCenter;
        vehicleNameLbl.textColor=[UIColor colorWithRed:92.0f/255.0f green:123.0f/255.0f blue:140.0f/255.0f alpha:1.0];
        vehicleNameLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:8];
        vehicleNameLbl.text = [NSString stringWithFormat:@"%@",[skills_vehicleDesc_array objectAtIndex:i]];
        
        [self.view addSubview:vehicleNameLbl];
        
        [slideroutlet bringSubviewToFront:image_view];
        
      //  [lblSlider addSubview:image_view];
        //[image_view bringSubviewToFront:slideroutlet];
        }
    slideroutlet.minimumValue = 0.0;
    slideroutlet.maximumValue = width;
    slideroutlet.continuous = YES;
    
}
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^
     {
         
         CGRect frame = sideView.frame;
         frame.origin.y = sideView.frame.origin.y;
         frame.origin.x = -225;
         sideView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    _testView.hidden = YES;
    Downtimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:NO];
}
-(void)DownTimeCal
{
    [self.view bringSubviewToFront:mapView_];
    [mapView_ bringSubviewToFront:mapView_];
    
    [self.view bringSubviewToFront:viewAsMapBtn];
    [mapView_ bringSubviewToFront:viewAsMapBtn];
    
    [self.view bringSubviewToFront:viewAsListBtn];
    [mapView_ bringSubviewToFront:viewAsListBtn];
}
-(void)viewWillAppear:(BOOL)animated{
    [self FadeView];
    NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    
    NSUserDefaults *status = [NSUserDefaults standardUserDefaults];
    NSString* ID = [status valueForKey:@"Service_Pref_id"];
    NSString* state = [status valueForKey:@"Service_Pref_state"];
    if(ID.length !=0)
    {
        if([state isEqualToString:@"ConfirmService"])
        {
            customerRatingViewController *obj = [[customerRatingViewController alloc]initWithNibName:@"customerRatingViewController" bundle:nil];
            obj.pref = @"yes";
            [timer invalidate];
            [self.navigationController pushViewController:obj animated:YES];
        }else{
        notificationViewController *obj = [[notificationViewController  alloc]initWithNibName:@"notificationViewController" bundle:nil];
        obj.pref = @"yes";
            [timer invalidate];
        [self.navigationController pushViewController:obj animated:YES];
        }
    }
     if ([userId isKindOfClass:[NSNull class]])
    {
        userId=@"";
        
    }
    
    if( userId.length==0)
    {
        isguestUser=YES;
        logOutBtn.hidden=YES;
        logOutLineLbl.hidden=YES;
        viewProfileBttn.hidden=YES;
        myLocBttn.hidden=YES;
        myVehiclBtn.hidden=YES;
        serviceHistoryBtn.hidden = YES;
        workSampleBtn.hidden = YES;
        ScheduleServiceBtn.hidden = YES;
        servicehistoryLineLbl.hidden = YES;
        workSampleLineLbl.hidden= YES;
        scheduleServiceLineLbl.hidden = YES;
        BlockedList.hidden = YES;
        lbllogout.hidden = YES;
        lblLOGOUT.hidden = YES;
        recommended_detailers.hidden = YES;
        logIn.hidden=NO;
        signUp.hidden=NO;
        
        profileName.text = [NSString stringWithFormat:@"Guest"];
        profileImage.image = [UIImage imageNamed:@"dummy-user-img.png"];
    }
    else {
        [self fetchProfileInfoFromDatabase];
        
        logOutBtn.hidden=NO;
        logOutLineLbl.hidden=NO;
        isguestUser=NO;
        viewProfileBttn.hidden=NO;
        myLocBttn.hidden=NO;
        myVehiclBtn.hidden=NO;
        serviceHistoryBtn.hidden = NO;
        workSampleBtn.hidden = NO;
        ScheduleServiceBtn.hidden = NO;
        servicehistoryLineLbl.hidden = NO;
        workSampleLineLbl.hidden= NO;
        scheduleServiceLineLbl.hidden = NO;
        BlockedList.hidden = NO;
        lblLOGOUT.hidden = NO;
        recommended_detailers.hidden = NO;
        logIn.hidden=YES;
        signUp.hidden=YES;

       // NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
    
        
        
        profileName.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
        
        

    }
    [timer invalidate];
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshMethod) userInfo:nil repeats:YES];
   // [self addSlider];
    
}
-(void)refreshMethod
{
    [self fetchOnlineDetailers];
    i++;
}

-(void) fetchLocation
{
    
    CLLocation *CameraLocation = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    
    [geocoder1 reverseGeocodeLocation:CameraLocation
                    completionHandler:^(NSArray *placemarks, NSError* error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         if (placemarks.count>0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSLog(@"placemark.ISOcountryCode %@",placemark.addressDictionary);
             NSLog(@"placemark.ISOcountryCode %@ %@ %@",[placemark.addressDictionary valueForKey:@"SubLocality"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"Country"]);
             
             city = [NSString stringWithFormat:@"%@",[placemark.addressDictionary valueForKey:@"City"]];
             [self fetchOnlineDetailers];
         }
     }];
    
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
        //  nameLbl.text =[results stringForColumn:@"name"];
        NSString*imgUrl=[results stringForColumn:@"image"];
        
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                profileImage.image = [UIImage imageWithData:imageData];
            });
        });
    }
    [database close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)mapView:(GMSMapView *)mapView
   markerInfoWindow:(GMSMarker *)marker {
    UIView *infoWindow = [[UIView alloc] init];
    infoWindow.frame = CGRectMake(0, 0, 200, 50);
    infoWindow.backgroundColor = [UIColor whiteColor];
    infoWindow.layer.borderColor =[UIColor grayColor].CGColor;
    infoWindow.layer.borderWidth = 1.0;
    infoWindow.layer.cornerRadius = 6.0;
    infoWindow.layer.shadowColor = [[UIColor blackColor] CGColor];
    infoWindow.layer.shadowOpacity = 1;
    infoWindow.layer.shadowRadius = 10;
    infoWindow.layer.shadowOffset = CGSizeMake(-2, 7);
    [infoWindow setClipsToBounds:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(50, 5, 150, 16);
    titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [infoWindow addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.text = marker.title;
    
    NSInteger Aindex = 0;
    
    for (int i = 0; i < [detailerListArray count]; i++) {
        mapDetailsOC = [detailerListArray objectAtIndex:i];
        if ([mapDetailsOC.detailrName isEqualToString:marker.title]) {
             Aindex = i;
        }
    }
    
    mapDetailsOC = [detailerListArray objectAtIndex:Aindex];
    
    AsyncImageView *itemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",mapDetailsOC.placeImage];
    itemImage.imageURL = [NSURL URLWithString:imageUrls];
    itemImage.showActivityIndicator = YES;
    itemImage.frame = CGRectMake(5, 5, 40, 40);
    itemImage.contentMode = UIViewContentModeScaleAspectFill;
    itemImage.userInteractionEnabled = YES;
    itemImage.multipleTouchEnabled = YES;
    itemImage.layer.borderColor = [UIColor clearColor].CGColor;
    itemImage.layer.borderWidth = 1.5;
    itemImage.layer.cornerRadius = 4.0;
    [itemImage setClipsToBounds:YES];
    [infoWindow addSubview:itemImage];
    
    UILabel *ratingTitleLabel = [[UILabel alloc] init];
    ratingTitleLabel.frame = CGRectMake(50, 25, 150, 15);
    ratingTitleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:8];
    ratingTitleLabel.text = @"Rating:";
    [infoWindow addSubview:ratingTitleLabel];
    
    int x = 80;
    mapDetailsOC = [detailerListArray objectAtIndex:Aindex];
    int rate;
    if([mapDetailsOC.placeRatingStr isKindOfClass:[NSNull class]])
    {
        rate=0;
    }
    else{
        rate = [mapDetailsOC.placeRatingStr intValue];
        
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton *rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 27, 12, 12)];
        if (i < rate) {
            [rateButton setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        }else{
            [rateButton setBackgroundImage:[UIImage imageNamed:@"yellow-star.png"] forState:UIControlStateNormal];
        }
        [infoWindow addSubview:rateButton];
        x= x+12;
    }
    return infoWindow;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
}

- (void) mapView :(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSInteger Aindex = 0;
    if (detailerListArray .count>0) {
        for (int i = 0; i < [detailerListArray count]; i++)
        {
            mapDetailsOC = [detailerListArray objectAtIndex:i];
            if ([mapDetailsOC.detailrName isEqualToString:marker.title]) {
                Aindex = i;
            }
        }
        mapDetailsOC = [detailerListArray objectAtIndex:Aindex];

    }
    detailerViewController *detailerVC = [[detailerViewController alloc] initWithNibName:@"detailerViewController" bundle:nil];
     [timer invalidate];
    detailerVC.mapDetailsOC = mapDetailsOC;
    detailerVC.detailrsArray=[detailerListArray mutableCopy];

    [self hideSideView];
    [self.navigationController pushViewController:detailerVC animated:NO];
}

- (IBAction)workSamples:(id)sender
{
    WorkSamplesViewController *workSamples=[[WorkSamplesViewController alloc]initWithNibName:@"WorkSamplesViewController" bundle:[NSBundle mainBundle]];
    [self hideSideView];
     [timer invalidate];
    [self.navigationController pushViewController:workSamples animated:YES];
}

- (IBAction)viewAsMapBttn:(id)sender
{
    [viewAsMapBtn setBackgroundColor:[UIColor blackColor]];
    [viewAsListBtn setBackgroundColor:[UIColor lightGrayColor]];
    mapView_.hidden=NO;
    [self hideSideView];
    detailrDetailBackView.hidden=YES;
   
}

- (IBAction)viewAsListBtn:(id)sender
{
    if (detailerListArray.count==0)
    {
        nameSort.hidden=YES;
        distancSort.hidden=YES;
        ratingSort.hidden=YES;
    }
    [viewAsListBtn setBackgroundColor:[UIColor blackColor]];
    [viewAsMapBtn setBackgroundColor:[UIColor lightGrayColor]];
    mapView_.hidden=YES;
    detailrDetailBackView.hidden=NO;
    [self hideSideView];
    [detailrDetailTableView reloadData];
}

- (IBAction)logIn:(id)sender {
    
    loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
    loginVC.backBtnHidden=YES;
    
    loginVC.callerView=@"";
     [timer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:loginVC animated:YES];
    
    
}

- (IBAction)menuBtnAction:(id)sender
{
    
    if (sideView.frame.origin.x==0)
    {
        [self hideSideView];

        
    }
    else{
        [self.view bringSubviewToFront:_testView];
        [mapView_ bringSubviewToFront:_testView];
        
        [self.view bringSubviewToFront:sideView];
        [mapView_ bringSubviewToFront:sideView];
        
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
        _testView.hidden = NO;
        [self.view bringSubviewToFront:_testView];
        [mapView_ bringSubviewToFront:_testView];
        
        [self.view bringSubviewToFront:sideView];
        [mapView_ bringSubviewToFront:sideView];
        
        }
    
}
-(void)hideSideView{
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^
     {
         
         CGRect frame = sideView.frame;
         frame.origin.y = sideView.frame.origin.y;
         frame.origin.x = -225;
         sideView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    _testView.hidden = YES;
    [_testView bringSubviewToFront:slideroutlet];
    Downtimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:NO];

}




- (IBAction)MyVehicles:(id)sender {
    
    if (isguestUser)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please log in to continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        callerView=@"vehicle";
        alert.tag=1;
        [alert show];
        return;
        
    }
    [self hideSideView];
    
    vehicleListViewController *vehiclelistVC = [[vehicleListViewController alloc] initWithNibName:@"vehicleListViewController" bundle:nil];
     [timer invalidate];
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
}

- (IBAction)MyLocationsBtn:(id)sender {
    if (isguestUser)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please log in to continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        callerView=@"location";

        alert.tag=1;
        [alert show];
        return;
        
    }
    [self hideSideView];

    locationListViewController *vehiclelistVC = [[locationListViewController alloc] initWithNibName:@"locationListViewController" bundle:nil];
     [timer invalidate];
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
}


- (IBAction)requestService:(id)sender {
    
    [self hideSideView];

    if (detailerListArray.count==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"No detailer is online." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (isguestUser)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please log in to continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        callerView=@"randomRequest";

        alert.tag=1;
        [alert show];
        return;
        
    }
    

    requestServiceViewController *requestVC = [[requestServiceViewController alloc] initWithNibName:@"requestServiceViewController" bundle:nil];
    requestVC.detailrId=@"-1";
    requestVC.detailrsArray=[detailerListArray mutableCopy];
     [timer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)profileBttn:(id)sender
{
    [self hideSideView];

    MyprofileViewController*myProfile = [[MyprofileViewController alloc] initWithNibName:@"MyprofileViewController" bundle:nil];
     [timer invalidate];
    [self.navigationController pushViewController:myProfile animated:NO];
    [self hideSideView];
}

- (IBAction)homeBtnAction:(id)sender {
    [self hideSideView];
}

- (IBAction)serviceHistoryBttn:(id)sender {
    assignmentsViewController *assignmentVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
    assignmentVC.triggerValue = @"customer";
    assignmentVC.timing = @"past";
    [timer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:assignmentVC animated:NO];
}

- (IBAction)logOutBttn:(id)sender {
    
    [self hideSideView];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"role"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [self deletDataFromDatabase];
    
    [self viewWillAppear:YES];
}

- (IBAction)feesSortBttn:(id)sender {
    
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"fees"
                                                                    ascending:NO
                                                                     selector:@selector(localizedStandardCompare:)];
    
    detailerListArray = [[detailerListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    [detailrDetailTableView reloadData];
    [nameSort setBackgroundColor:[UIColor lightGrayColor]];
    [distancSort setBackgroundColor:[UIColor lightGrayColor]];
    [feesSort setBackgroundColor:[UIColor blackColor]];
    [ratingSort setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)ratingSortBttn:(id)sender {
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"placeRatingStr"
                                                                    ascending:NO
                                                                     selector:@selector(localizedStandardCompare:)];
    
    detailerListArray = [[detailerListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    [detailrDetailTableView reloadData];

    [nameSort setBackgroundColor:[UIColor lightGrayColor]];
    [distancSort setBackgroundColor:[UIColor lightGrayColor]];
    [feesSort setBackgroundColor:[UIColor lightGrayColor]];
    [ratingSort setBackgroundColor:[UIColor blackColor]];

}

- (IBAction)distanceSortBttn:(id)sender {
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                                    ascending:NO
                                                                     selector:@selector(localizedStandardCompare:)];
    
    detailerListArray = [[detailerListArray sortedArrayUsingDescriptors:@[firstNameSort]]mutableCopy];
    [detailrDetailTableView reloadData];

    [nameSort setBackgroundColor:[UIColor lightGrayColor]];
    [distancSort setBackgroundColor:[UIColor blackColor]];
    [feesSort setBackgroundColor:[UIColor lightGrayColor]];
    [ratingSort setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)nameSortBttn:(id)sender {
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"detailrName" ascending:YES];
    
    [detailerListArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [detailrDetailTableView reloadData];
    
    [nameSort setBackgroundColor:[UIColor blackColor]];
    [distancSort setBackgroundColor:[UIColor lightGrayColor]];
    [feesSort setBackgroundColor:[UIColor lightGrayColor]];
    [ratingSort setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)scheduledServicesBtnAction:(id)sender {
    assignmentsViewController *assignmentVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
    assignmentVC.triggerValue = @"customer";
    assignmentVC.timing = @"upcoming";
     [timer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:assignmentVC animated:NO];
}

- (IBAction)serviceHistoryBtnAction:(id)sender {
    assignmentsViewController *assignmentVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
    assignmentVC.triggerValue = @"customer";
    assignmentVC.timing = @"past";
     [timer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:assignmentVC animated:NO];
}

- (IBAction)signUp:(id)sender {
    
    RegisterationRoleViewController*registerVC = [[RegisterationRoleViewController alloc] initWithNibName:@"RegisterationRoleViewController" bundle:nil];
   
    registerVC.backBtnHidden=YES;
         [timer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)button:(id)sender {
    TagSampleViewController *obj = [[TagSampleViewController alloc]initWithNibName:@"TagSampleViewController" bundle:nil];
     [timer invalidate];
    [Downtimer invalidate];
    [self hideSideView];
    [self.navigationController pushViewController:obj animated:YES];
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

-(void) fetchOnlineDetailers
{
    
       NSMutableURLRequest *request ;
    NSString*_postData ;
    webservice=1;
    
    
    //cur_lat=@"30.711193";
    // cur_long=@"76.686332";
    //city=@"mohali";
 
    _postData = [NSString stringWithFormat:@"lat=%@&long=%@&city=%@&user_id=%@&skill_id=%@",cur_lat,cur_long,city,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],selected_Vehcl_Id];
        
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/nearby-online-detailers.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data];
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
-(void)FadeView{
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self fetchLocation1];
}
-(void) fetchLocation1
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    lat=self.locationManager.location.coordinate.latitude;
    lon=self.locationManager.location.coordinate.longitude;
    
    
    //customer current location
    NSNumber *aNumber = [NSNumber numberWithFloat:lat];
    NSNumber *bNumber = [NSNumber numberWithFloat:lon];
    
    [[NSUserDefaults standardUserDefaults]setValue:aNumber forKey:@"cust_current_lat"];
    [[NSUserDefaults standardUserDefaults]setValue:bNumber forKey:@"cust_current_lon"];
    
    
    
    
    
    
    NSLog(@"%f %f",lat,lon);
    CLLocation *CameraLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    [geocoder1 reverseGeocodeLocation:CameraLocation
                    completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         if (placemarks.count>0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSLog(@"placemark.ISOcountryCode %@",placemark.addressDictionary);
             NSLog(@"placemark.ISOcountryCode %@ %@ %@",[placemark.addressDictionary valueForKey:@"SubLocality"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"Country"]);
             nameStr = [NSString stringWithFormat:@"%@",[placemark.addressDictionary valueForKey:@"City"]];
             
         }
         [self updatelocation];
     }];
    
}

-(void) updatelocation
{
    
    webservice = 10;
      [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSLog(@"---------***************");
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@&latitude=%@&longitude=%@&current_city=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],[NSString stringWithFormat:@"%f",lat],[NSString stringWithFormat:@"%f",lon],nameStr];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/update-location.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
            NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",responseString);
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
    
   // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
   // [alert show];
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
    NSMutableDictionary *userDetailDict = [[NSMutableDictionary alloc]init];
    userDetailDict=[json objectWithString:responseString error:&error];
   if(userDetailDict == nil)
   {
      // UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"user detail empty" message:@"No Detailer Found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
      // [alert show];
       NSLog(@"No Detailer Found");
   }
   
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
            if (webservice == 10 && [messageStr isEqualToString:@"Success"])
            {
                NSLog(@"Lovation updated on server");
                
                //[self fetchLocation];
            }
            if (webservice==1)
            {
                [detailerListArray removeAllObjects];
                [distance removeAllObjects];

                
                NSMutableArray *detailerInfoArray = [userDetailDict valueForKey:@"detailer_info"];
                
                   for (int i = 0; i < [detailerInfoArray count]; i++)
                   {
                       mapDetailsOC =[[mapDetailsObj alloc]init];
                       mapDetailsOC.workSamples=[[detailerInfoArray valueForKey:@"work_sample"] objectAtIndex:i];
                       float lat=[[[detailerInfoArray valueForKey:@"latitude"] objectAtIndex:i]floatValue];
                       
                       float lon=[[[detailerInfoArray valueForKey:@"longitude"] objectAtIndex:i]floatValue];
                       
                       mapDetailsOC.latitudeStr=[[detailerInfoArray valueForKey:@"latitude"] objectAtIndex:i];
                       mapDetailsOC.longitudeStr=[[detailerInfoArray valueForKey:@"longitude"] objectAtIndex:i];
                       mapDetailsOC.placeImage=[[detailerInfoArray valueForKey:@"imageUrl"] objectAtIndex:i];
                       
                       if([[[detailerInfoArray valueForKey:@"rating"] objectAtIndex:i] isKindOfClass:[NSNull class]])
                       {
                           mapDetailsOC.placeRatingStr=@"0";
                       }
                       else{
                           mapDetailsOC.placeRatingStr=[[detailerInfoArray valueForKey:@"rating"] objectAtIndex:i];
                           
                       }

                       
                       mapDetailsOC.detailrName=[[detailerInfoArray valueForKey:@"name"] objectAtIndex:i];
                       mapDetailsOC.detailerContact=[[detailerInfoArray valueForKey:@"contact_info"] objectAtIndex:i];
                       mapDetailsOC.detailrEmail=[[detailerInfoArray valueForKey:@"email"] objectAtIndex:i];
                       mapDetailsOC.detailrId=[[detailerInfoArray valueForKey:@"ID"] objectAtIndex:i];

                     
                     float lat1  =self.locationManager.location.coordinate.latitude;
                    float long1=self.locationManager.location.coordinate.longitude;
                       
                       
                       CLLocation *location1 = [[CLLocation alloc] initWithLatitude: lat longitude:lon];
                       CLLocation *location2 = [[CLLocation alloc] initWithLatitude: lat1 longitude:long1];
                       
                       
                       NSLog(@"LOC1  = %f, %f", location1.coordinate.latitude,  location1.coordinate.longitude);
                       NSLog(@"LOC2 = %f, %f", location2.coordinate.latitude, location2.coordinate.longitude);
                      
                       distInMeter = [location1 distanceFromLocation:location2];
                       float distInMile = 0.000621371192 * distInMeter;
                       
                       NSLog(@"Actual Distance in Mile : %f",distInMile);
                       
                       
                       NSNumber *num = [NSNumber numberWithFloat:distInMeter];
                       [distance addObject:num];
                       
                       mapDetailsOC.distance=[NSString  stringWithFormat:@"%f",distInMile];

                       [detailerListArray addObject:mapDetailsOC];
                   }
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"detailrName" ascending:YES];
                
                [detailerListArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];

                
                if (detailerListArray.count==0)
                {   lblTime.text = @"No Detailer Online";
                    nameSort.hidden=YES;
                    distancSort.hidden=YES;
                    ratingSort.hidden=YES;
                }
                if([distance count]!=0)
                {
                    NSSortDescriptor *sortDescriptor;
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                                  ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    NSArray *sortedArray;
                    sortedArray = [distance sortedArrayUsingDescriptors:sortDescriptors];
                    NSString *lbl = [sortedArray objectAtIndex:0];
                    float distInMile = 0.000621371192 * [lbl floatValue];
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setMaximumFractionDigits:2];
        
                    NSString *result = [formatter stringFromNumber:[NSNumber numberWithFloat:distInMile]];
                    
                    NSString *str;
                    
                    
                    
                    if([result isEqualToString:@".00"] || [result isEqualToString:@"0"])
                    {
                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                        [formatter setMaximumFractionDigits:2];
                        
                        NSString *abc = [formatter stringFromNumber:[NSNumber numberWithFloat:distInMeter]];
                        NSLog(abc);
                        
                        str = [NSString stringWithFormat:@"Nearest Detailer is approx %@ meters away",abc];
                        
                    }else{
                    str =[NSString stringWithFormat:@"Nearest Detailer is approx %@ miles away",result];
                    }
                    lblTime.text = str;
                }else{
                    lblTime.text = @"No Detailer is Online";
                }
                [detailrDetailTableView reloadData];
                
                [self showDetailersOnMapView];
                
            }
            else if (webservice==4)
            {
                //[kappDelegate HideIndicator];
                NSLog(@"device token udid userid");

            }
        }
    }
}

-(void) showDetailersOnMapView
{
    [mapView_ clear];
  
    
    // Creates a marker in the center of the map.
    for (int i = 0; i < [detailerListArray count]; i++) {
        mapDetailsOC = [detailerListArray objectAtIndex:i];
        float lat = [mapDetailsOC.latitudeStr floatValue];
        float longit = [mapDetailsOC.longitudeStr floatValue];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat, longit);
        marker.title = mapDetailsOC.detailrName;
        marker.icon = [UIImage imageNamed:@"pin1.png"];
        marker.map = mapView_;
    }


}

-(void) sendSliderBack{
    [sendBackTimer invalidate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [detailerListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    mapDetailsObj*detailrListObj = (mapDetailsObj*)[detailerListArray objectAtIndex:indexPath.row];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel*backLbl= [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 300,80)];
    backLbl.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:backLbl ];
    
    UILabel*detailerNameLbl= [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200,30)];
    detailerNameLbl.backgroundColor = [UIColor clearColor];
    detailerNameLbl.numberOfLines=1;
    detailerNameLbl.font =  [UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:detailerNameLbl ];
    
    UILabel*rating= [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 280,30)];
    rating.backgroundColor = [UIColor clearColor];
    rating.numberOfLines=1;
    rating.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:rating ];
    
    AsyncImageView *itemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",detailrListObj.placeImage];
    itemImage.imageURL = [NSURL URLWithString:imageUrls];
    itemImage.showActivityIndicator = YES;
    itemImage.frame = CGRectMake(5, 5, 70, 70);
    itemImage.contentMode = UIViewContentModeScaleAspectFill;
    itemImage.userInteractionEnabled = YES;
    itemImage.multipleTouchEnabled = YES;
    itemImage.layer.borderColor = [UIColor clearColor].CGColor;
    itemImage.layer.borderWidth = 1.5;
    itemImage.layer.cornerRadius = 4.0;
    [itemImage setClipsToBounds:YES];
    [cell.contentView addSubview:itemImage];
    int rate;
    if([mapDetailsOC.placeRatingStr isKindOfClass:[NSNull class]])
    {
        rate=0;
    }
    else{
        rate = [mapDetailsOC.placeRatingStr intValue];
  
    }
    int x=160;
    for (int i = 0; i < 5; i++) {
        UIButton *rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 35, 20, 20)];
        if (i < rate) {
            [rateButton setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        }else{
            [rateButton setBackgroundImage:[UIImage imageNamed:@"yellow-star.png"] forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:rateButton];
        x= x+20;
    }

    
    
    
    
    if ( IS_IPHONE_6P || IS_IPHONE_6)
    {
        itemImage.frame= CGRectMake(6, 10, 70,70);
        rating.frame= CGRectMake(100, 35, 330,30);
        detailerNameLbl.frame= CGRectMake(100, 5, 300,30);
        backLbl.frame= CGRectMake(0, 1, 400,80);
    }
    
    cell.backgroundColor=[UIColor clearColor];
    rating.text=[NSString stringWithFormat:@"Rating :"];
    detailerNameLbl.text=[NSString stringWithFormat:@"%@",detailrListObj.detailrName];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    mapDetailsObj *mapObj = (mapDetailsObj *)[detailerListArray objectAtIndex:indexPath.row];
    [self hideSideView];

    detailerViewController *detailerVC = [[detailerViewController alloc] initWithNibName:@"detailerViewController" bundle:nil];
     [timer invalidate];
    detailerVC.mapDetailsOC = mapObj;
    detailerVC.detailrsArray=[detailerListArray mutableCopy];
    
    [self.navigationController pushViewController:detailerVC animated:NO];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        [self hideSideView];

            loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
            loginVC.backBtnHidden=YES;
            loginVC.callerView=callerView;
            loginVC.detailerId=@"-1";
            loginVC.detailerArray=[detailerListArray mutableCopy];
        
             [timer invalidate];
            [self.navigationController pushViewController:loginVC animated:YES];
    }
}


-(void)registerDevice
{
    webservice=4;
    
    NSString*deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    NSLog(deviceToken);
    NSString*UDID=[[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];
    NSLog(UDID);
     NSString*role=@"";
    
    NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    NSLog(userId);
    if ([userId isKindOfClass:[NSNull class]])
        
    {
        userId=@"";
        
    }

    
    if (userId.length!=0)
    {
        NSString* _postData = [NSString stringWithFormat:@"trigger=ios&role=%@&reg_id=%@&user_id=%@&ud_id=%@",role,deviceToken,userId,UDID ];
        
        NSLog(@"data post >>> %@",_postData);
       // [kappDelegate ShowIndicator];
        
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


- (IBAction)recommended_detailers:(id)sender {
    assignmentsViewController *obj = [[assignmentsViewController alloc]initWithNibName:@"assignmentsViewController" bundle:nil];
    obj.recommend_Detailers = @"yes";
    [self.navigationController pushViewController:obj animated:nil];
}

- (IBAction)BlockedList:(id)sender {
    
    assignmentsViewController *vehiclelistVC = [[assignmentsViewController alloc] initWithNibName:@"assignmentsViewController" bundle:nil];
//    vehiclelistVC.presentuserid = [[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    vehiclelistVC.timing = @"BlockedList";
     [timer invalidate];
    [self.navigationController pushViewController:vehiclelistVC animated:NO];

}
- (IBAction)slideraction:(id)sender {
    //-----set image of slider button at different positions
   
    
//    if(slideroutlet.value >= 1)
//    {
//        if(slideroutlet.value < 1.630)
//        { [slideroutlet setThumbImage:[UIImage imageNamed:@"calendar-i.png"] forState:UIControlStateNormal];}
//        
//    }
//    if(slideroutlet.value > 1.630)
//    {
//        if(slideroutlet.value < 2.564)
//        { [slideroutlet setThumbImage:[UIImage imageNamed:@"car-i_2.png"] forState:UIControlStateNormal];}
//        
//    }
//    if(slideroutlet.value > 2.564)
//    {
//        if(slideroutlet.value < 3.607)
//        { [slideroutlet setThumbImage:[UIImage imageNamed:@"cvv-i.png"] forState:UIControlStateNormal]; }
//    }
//    if(slideroutlet.value > 3.607)
//    {
//        if(slideroutlet.value < 4.587)
//        {  [slideroutlet setThumbImage:[UIImage imageNamed:@"credit-card-i.png"] forState:UIControlStateNormal]; }
//    }
//    if(slideroutlet.value > 4.587)
//    {
//        if(slideroutlet.value < 5.559)
//        {  [slideroutlet setThumbImage:[UIImage imageNamed:@"cvv-i.png"] forState:UIControlStateNormal]; }
//    }
//    if(slideroutlet.value > 5.559)
//    {   if(slideroutlet.value < 6.530)
//    { [slideroutlet setThumbImage:[UIImage imageNamed:@"car-i_2.png"] forState:UIControlStateNormal]; }
//    }
//    if(slideroutlet.value > 6.530)
//    {
//        if(slideroutlet.value <= 7.000)
//        { [slideroutlet setThumbImage:[UIImage imageNamed:@"cvv-i.png"] forState:UIControlStateNormal]; }
//    }
}
- (void)sliderDidEndSliding:(NSNotification *)notification {
    //---take slider to particular position
    
    CGRect frame = slideroutlet.frame;
    
    float y = frame.origin.y;
    float x = frame.origin.x;
    float width = frame.size.width;
    
    float size_of_partition = width/(skills_id_array.count-1);
//    UIImageView *image_view ;
//    for (int i=0; i<skills_id_array.count; i++) {
//        image_view = [[UIImageView alloc]initWithFrame:CGRectMake(x+size_of_partition*i , y+6, 16, 16)];
//        image_view.image = [UIImage imageNamed:@"circle-16.png"];
//        [self.view addSubview:image_view];
//    }
    
    
    for (int j=0; j<skills_id_array.count; j++)
    {   NSLog(@"%f",slideroutlet.value);
        if(slideroutlet.value == 0.000000)
        {
            [slideroutlet setValue:size_of_partition*j animated:YES];
            
            for (int i=0; i<skills_id_array.count; i++) {
                UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:i+100];
                myImageView.image = [UIImage imageNamed:[img_arr objectAtIndex:i]];
            }
            
            
            UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:j+100];
            
            myImageView.image = [UIImage imageNamed:@"icon_06.png"];
            selected_Vehcl_Id=[NSString stringWithFormat:@"%@",[skills_id_array objectAtIndex:j]];
            lblComfort.text=[NSString stringWithFormat:@"%@",[skills_vehicleDesc_array objectAtIndex:j]];
            [self fetchOnlineDetailers];
            break;

        }
        if (slideroutlet.value >size_of_partition*j/2) {
            NSLog(@"%f",slideroutlet.value);
            if(slideroutlet.value < size_of_partition/2 +size_of_partition*j)
            {
                [slideroutlet setValue:size_of_partition*j animated:YES];
                
                for (int i=0; i<skills_id_array.count; i++) {
                    UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:i+100];
                    myImageView.image = [UIImage imageNamed:[img_arr objectAtIndex:i]];
                }

                    
                
                UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:j+100];
                
                myImageView.image = [UIImage imageNamed:@"icon_06.png"];
                selected_Vehcl_Id=[NSString stringWithFormat:@"%@",[skills_id_array objectAtIndex:j]];
                lblComfort.text=[NSString stringWithFormat:@"%@",[skills_vehicleDesc_array objectAtIndex:j]];
                [self fetchOnlineDetailers];
                break;
            }
        }
    }
    
    
    
//    if(slideroutlet.value >= 1)
//    {
//        
//        if(slideroutlet.value < 1.630)
//        {
//                [slideroutlet setValue:1.107 animated:YES];
//          //      [slideroutlet setThumbImage:[UIImage imageNamed:@"calendar-i.png"] forState:UIControlStateNormal];
//                lblComfort.text = @"COMFORT CALENDER";
//        }
//    }
//    if(slideroutlet.value > 1.630)
//    {
//        if(slideroutlet.value < 2.564)
//        {
//            [slideroutlet setValue:2.058 animated:YES];
//        //    [slideroutlet setThumbImage:[UIImage imageNamed:@"car-i_2.png"] forState:UIControlStateNormal];
//            lblComfort.text = @"COMFORT CAR";
//        }
//    }
//    if(slideroutlet.value > 2.564)
//    {
//        if(slideroutlet.value < 3.607)
//        {
//            [slideroutlet setValue:3.080 animated:YES];
//          //  [slideroutlet setThumbImage:[UIImage imageNamed:@"cvv-i.png"] forState:UIControlStateNormal];
//            lblComfort.text = @"COMFORT CVV";
//        }
//    }
//    if(slideroutlet.value > 3.607)
//    {
//        if(slideroutlet.value < 4.587)
//        {
//            [slideroutlet setValue:4.113 animated:YES];
//         //   [slideroutlet setThumbImage:[UIImage imageNamed:@"credit-card-i.png"] forState:UIControlStateNormal];
//            lblComfort.text = @"COMFORT CREADIT";
//        }
//    }
//    if(slideroutlet.value > 4.587)
//    {
//        if(slideroutlet.value < 5.559)
//        {
//            [slideroutlet setValue:5.094 animated:YES];
//          //  [slideroutlet setThumbImage:[UIImage imageNamed:@"cvv-i.png"] forState:UIControlStateNormal];
//            lblComfort.text = @"COMFORT CVV";
//        }
//    }
//    if(slideroutlet.value > 5.559)
//    {
//        if(slideroutlet.value < 6.530)
//        {
//            [slideroutlet setValue:6.065 animated:YES];
//           // [slideroutlet setThumbImage:[UIImage imageNamed:@"car-i_2.png"] forState:UIControlStateNormal];
//            lblComfort.text = @"COMFORT CAR";
//        }
//    }
//    if(slideroutlet.value > 6.530)
//    {
//        if(slideroutlet.value <=7)
//        {
//            [slideroutlet setValue:7 animated:YES];
//          //  [slideroutlet setThumbImage:[UIImage imageNamed:@"cvv-i.png"] forState:UIControlStateNormal];
//            lblComfort.text = @"COMFORT CVV";
//        }
//    }
}

@end
