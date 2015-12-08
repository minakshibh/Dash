//
//  addLocationViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "addLocationViewController.h"
#import "addVehicleViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@interface addLocationViewController ()

@end

@implementation addLocationViewController
@synthesize headerLblStr,triggervalue,locationOC;

- (void)viewDidLoad {
    
    scrollview.scrollEnabled = YES;
    scrollview.delegate = self;
    // scrollview.contentSize = CGSizeMake(320, 520);
    scrollview.backgroundColor=[UIColor clearColor];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location Address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Longitude"];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self fetchDataFromDb];

    [super viewDidLoad];
    headerLbl.text=headerLblStr;
    
    saveLocationBtn.layer.borderColor = [UIColor grayColor].CGColor;
    saveLocationBtn.layer.borderWidth = 1.0;
    saveLocationBtn.layer.cornerRadius = 4.0;
    [saveLocationBtn setClipsToBounds:YES];

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
    
    double latValue = [[NSString stringWithFormat:@"%@",self.locationOC.locationLatitude] doubleValue];
    double longValue = [[NSString stringWithFormat:@"%@",self.locationOC.locationLongitude] doubleValue];
    GMSCameraPosition *camera;
    if ([self.addLocationDataType isEqualToString:@"Edit"])
    {
        backBtn.hidden=NO;
        stepsImg.hidden=YES;
        skipStepsBttn.hidden=YES;
     if([self.triggervalue isEqualToString:@"Add"])
     {
         backView.frame=CGRectMake(backView.frame.origin.x,backView.frame.origin.y-80,backView.frame.size.width, backView.frame.size.height);
         
         camera = [GMSCameraPosition cameraWithLatitude:current_latitude
                                              longitude:current_longitude
                                                   zoom:11];

     }else{
       
        backView.frame=CGRectMake(backView.frame.origin.x,backView.frame.origin.y-80,backView.frame.size.width, backView.frame.size.height);

        camera = [GMSCameraPosition cameraWithLatitude:latValue
                                             longitude:longValue
                                                  zoom:11];
          }
    }else{
        
        camera = [GMSCameraPosition cameraWithLatitude:latValue
                                             longitude:longValue
                                                  zoom:11];
    }
    
    if (IS_IPHONE_5)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 282 , 267) camera:camera];
        
    }
    if (IS_IPHONE_6)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 332 , 314) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 366 , 347) camera:camera];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 282 , 267) camera:camera];
    }
    [mapView_ setDelegate:self];
    mapView_.myLocationEnabled = YES;
    [mapBackView addSubview:mapView_];
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    if ([self.addLocationDataType isEqualToString:@"Edit"]) {
        
        if([self.triggervalue isEqualToString:@"Add"])
        {
            
            marker.position = CLLocationCoordinate2DMake(current_latitude, current_longitude);
        }else{
            lblAddlocation.text = @"Edit Location" ;
        marker.position = CLLocationCoordinate2DMake(latValue, longValue);
            }
    }else{
        marker.position = CLLocationCoordinate2DMake(current_latitude, current_longitude);
    }
    
   // marker.title = @"Chandigarh";
    marker.map = mapView_;
    
    if (IS_IPHONE_5)
    {
       [searchView setFrame:CGRectMake(18, 185, searchView.frame.size.width-75, searchView.frame.size.height)];
        
    }
    if (IS_IPHONE_6)
    {
       [searchView setFrame:CGRectMake(23, 220, searchView.frame.size.width-30, searchView.frame.size.height)];
    }
    if (IS_IPHONE_6P)
    {
       [searchView setFrame:CGRectMake(25, 245, searchView.frame.size.width, searchView.frame.size.height)];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
       [searchView setFrame:CGRectMake(17, 157, searchView.frame.size.width-75, searchView.frame.size.height)];
    }
    if ([self.addLocationDataType isEqualToString:@"Edit"])
    {
        
        
        [searchView setFrame:CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y-60, searchView.frame.size.width, searchView.frame.size.height)];
    }
    [self.view addSubview:searchView];
    
 
    
    
//    self.view = mapView_;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    locationListArray = [[NSMutableArray alloc]init];
    while([queryResults next]) {
        locationListObj*locationListOC = [[locationListObj alloc]init];
        locationListOC.loactionName = [queryResults stringForColumn:@"loactionName"];
        locationListOC.locationId = [queryResults stringForColumn:@"locationId"];
        locationListOC.locationAddress = [queryResults stringForColumn:@"locationAddress"];
        locationListOC.locationLatitude = [queryResults stringForColumn:@"locationLatitude"];
        locationListOC.locationLongitude = [queryResults stringForColumn:@"locationLongitude"];
        [locationListArray addObject:locationListOC];
    }
    
    [database close];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)skipStepAction:(id)sender {
    addVehicleViewController *addVehicleVC = [[addVehicleViewController alloc] initWithNibName:@"addVehicleViewController" bundle:nil];
    addVehicleVC.headerLblStr=headerLbl.text;
    [self.navigationController pushViewController:addVehicleVC animated:NO];

}

- (IBAction)searchLocationBtnAction:(id)sender {
}

- (IBAction)addNameBtnAction:(id)sender {
    [self.view endEditing:YES];
  
    
    if ([triggervalue isEqualToString:@"Add"])
    {
        
        for (int k=0; k<locationListArray.count; k++)
        {
            locationListObj*locListObj=(locationListObj*)[locationListArray objectAtIndex:k];
            NSString*address=addLocationNameTxt.text;
            NSString*locNamer=locListObj.loactionName;
            
            
            if ([locListObj.loactionName isEqualToString:address])
            {
                locationOC=locListObj;
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"You have already added this location.would you like to edit this location?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                alert.tag=4;
                
                [alert show];
                return;
            }
        }

    }
    
    
    addNameView.hidden = YES;
    disableImg.hidden=YES;
    [self addLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4 && buttonIndex ==1)
    {
        [self editLocation];
        addNameView.hidden = YES;
        disableImg.hidden=YES;
        
    }
    else if (alertView.tag == 4 && buttonIndex ==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (IBAction)saveLocationBtnAction:(id)sender {
    
    locationAddress  = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Location Address"]];

    
    if (locationAddress.length==0 || [locationAddress isEqualToString:@"(null)"])
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please select location to save" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self.view bringSubviewToFront:disableImg];
    [self.view sendSubviewToBack:mapView_];
    [searchView bringSubviewToFront:disableImg];
    
    
    addNameView.hidden = NO;
    if ([self.addLocationDataType isEqualToString:@"Edit"] && ![triggervalue isEqualToString:@"Add"])
    {
        if([self.triggervalue isEqualToString:@"Add"])
        {
            addLocationNameTxt.text=@"";
            [addNameBtn setTitle:@"Save" forState:UIControlStateNormal];
        }else
        {
            addLocationNameTxt.text=locationOC.loactionName;
            [addNameBtn setTitle:@"Update" forState:UIControlStateNormal];
        }
    }
    else{
        addLocationNameTxt.text = @"";
    }
    disableImg.hidden=NO;
    
    addNameView.layer.cornerRadius = 15;
    addNameView.layer.masksToBounds = YES;
    
    addNameBtn.layer.cornerRadius = 5;
    addNameBtn.layer.masksToBounds = YES;
    
    [self.view bringSubviewToFront:addNameView];
    //[searchView bringSubviewToFront:addNameView];
    //[disableImg bringSubviewToFront:addNameView];
}

#pragma mark - Text Field Delegates

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    
    if (theTextField.tag==4)
    {
        NSString *substring = [NSString stringWithString:searchLocationTxt.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        
        //  NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&radius=5000&sensor=false&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds",substring,current_latitude,current_longitude];
        
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%f,%f&radius=10000&sensor=false&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds&input=%@",current_latitude,current_longitude,substring];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
                       {
                           NSURL *queryUrl = [NSURL URLWithString:url];
                           NSData *data = [NSData dataWithContentsOfURL:queryUrl];
                           
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [self fetchLocaotionList:data];
                                          });
                       });
    }
    
    return YES;
    
    
    
}
#pragma mark - Fetch Locations List

-(void)fetchLocaotionList:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"predictions"];
    NSLog(@"Data is:%@" ,results);
    if (results.count>0)
    {
        ResultsTableView.hidden=NO;
    }
    else
    {
        ResultsTableView.hidden=YES;
    }
    
    locationArray=[[NSMutableArray alloc]init];
    if (results.count>0) {
        for (int i = 0;i <[results count]; i++)
        {
            NSDictionary *result = [results objectAtIndex:i];
            NSString *placesName = [result objectForKey:@"description"];
            NSArray* tempArray = [placesName componentsSeparatedByString: @","];
            if (tempArray.count>0)
            {
                placesName =[NSString stringWithFormat:@"%@", [tempArray objectAtIndex:0]];
            }
            
            [locationArray addObject:result];
        }
    }

    
    [ResultsTableView reloadData];
}
#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //  NSLog(@"%@",locationArray);
    if (locationArray.count>0)
    {
        NSMutableDictionary *tempDict=[locationArray objectAtIndex:indexPath.row];
        NSString *placesName = [tempDict objectForKey:@"description"];
        cell.textLabel.text = placesName;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSString *placesName;
    ResultsTableView.hidden = YES;
    
    if (locationArray.count>0)
    {
        NSMutableDictionary *tempDict=[locationArray objectAtIndex:indexPath.row];
        placesName = [tempDict objectForKey:@"description"];
    }
    TempDictForSource=[[NSMutableArray alloc] init];
    [TempDictForSource addObject:placesName];
    searchLocationTxt.text = placesName;
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", placesName];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    //  NSLog(@"query url%@",queryUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchLongitudeAndLattitude:data];
    });
    
    //[self MoveToHomeView];
}
#pragma mark - Fetch Lattitude and Longitude

-(void)fetchLongitudeAndLattitude:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
    // NSLog(@"Data is:%@" ,results);
    NSString *addressStr;
    
    //  30.714131, 76.690016
    
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
            
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude = [latitudeStr doubleValue];
    center.longitude = [longitudeStr doubleValue];
      NSLog(@"latt of address.. %.2f",[latitudeStr doubleValue]);
     NSLog(@"long of address .. %.2f",[longitudeStr doubleValue]);
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",[latitudeStr doubleValue]] forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",[longitudeStr doubleValue]] forKey:@"Longitude"];
    [[NSUserDefaults standardUserDefaults] setValue:searchLocationTxt.text forKey:@"Location Address"];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitudeStr doubleValue]
                                                            longitude:[longitudeStr doubleValue]
                                                                 zoom:11];
    
    if (IS_IPHONE_5)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 282 , 267) camera:camera];
        
    }
    if (IS_IPHONE_6)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 332 , 314) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 366 , 347) camera:camera];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(2, 2, 282 , 267) camera:camera];
    }
    [mapView_ setDelegate:self];
    mapView_.myLocationEnabled = YES;
    [mapBackView addSubview:mapView_];
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([latitudeStr doubleValue], [longitudeStr doubleValue]);
    marker.map = mapView_;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    CGRect frame = addNameView.frame;
    frame.origin.y = 250;
    addNameView.frame = frame;
    
    return  YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    if (textField == addLocationNameTxt) {
        
        CGRect frame = addNameView.frame;
        frame.origin.y = 185;
        addNameView.frame = frame;
    }
}


-(void)addLocation{
    
    
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    locationId = @"0";
    locationName = [NSString stringWithFormat:@"%@",addLocationNameTxt.text];
    locationAddress  = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Location Address"]];
    locationLatitude = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    locationLongitude = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
    
    if ([self.addLocationDataType isEqualToString:@"Edit"])
    {
        
        if ([triggervalue isEqualToString:@"Add"])
        {
            webservice=1;
            trigger = [NSString stringWithFormat:@"add"];
            _postData = [NSString stringWithFormat:@"loc_id=%@&user_id=%@&loc_name=%@&address=%@&latitude=%@&longitude=%@&trigger=%@",locationId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],locationName,locationAddress,locationLatitude,locationLongitude,trigger];
        }
        else
        {
            webservice=2;
            trigger = [NSString stringWithFormat:@"edit"];

            _postData = [NSString stringWithFormat:@"loc_id=%@&user_id=%@&loc_name=%@&address=%@&latitude=%@&longitude=%@&trigger=%@",locationOC.locationId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],locationName,locationAddress,locationLatitude,locationLongitude,trigger];
        }
      
    }
    else{
        webservice=1;
        trigger = [NSString stringWithFormat:@"add"];
       _postData = [NSString stringWithFormat:@"loc_id=%@&user_id=%@&loc_name=%@&address=%@&latitude=%@&longitude=%@&trigger=%@",locationId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],locationName,locationAddress,locationLatitude,locationLongitude,trigger];
        
    }
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/location-shortcut.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    
    
    
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
    
    if ([self.addLocationDataType isEqualToString:@"Edit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
//          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] animated:NO];
        
    }
    else{
        addVehicleViewController *addVehicleVC = [[addVehicleViewController alloc] initWithNibName:@"addVehicleViewController" bundle:nil];
        addVehicleVC.headerLblStr=headerLbl.text;
        
        
        [self.navigationController pushViewController:addVehicleVC animated:NO];
    
    }
    
    
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editLocation{
    
    
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    
    locationName = [NSString stringWithFormat:@"%@",addLocationNameTxt.text];
    locationAddress  = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Location Address"]];
    locationLatitude = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    locationLongitude = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
 
    webservice=2;
    trigger = [NSString stringWithFormat:@"edit"];
            _postData = [NSString stringWithFormat:@"loc_id=%@&user_id=%@&loc_name=%@&address=%@&latitude=%@&longitude=%@&trigger=%@",locationOC.locationId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],locationName,locationAddress,locationLatitude,locationLongitude,trigger];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/location-shortcut.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
