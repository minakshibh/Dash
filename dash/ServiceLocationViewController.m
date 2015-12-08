//
//  ServiceLocationViewController.m
//  dash
//
//  Created by Br@R on 01/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "ServiceLocationViewController.h"

@interface ServiceLocationViewController ()

@end

@implementation ServiceLocationViewController
@synthesize latitudeStr,longitudeStr,locAddrssStr;
- (void)viewDidLoad {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocAddress"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLatitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocLongitude"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    cur_lat=self.locationManager.location.coordinate.latitude;
    cur_long=self.locationManager.location.coordinate.longitude;
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude zoom:11];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 140, self.view.frame.size.width , self.view.frame.size.height-140)camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 140, self.view.frame.size.width , self.view.frame.size.height-140) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 145, self.view.frame.size.width , self.view.frame.size.height-140) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 140, self.view.frame.size.width , self.view.frame.size.height-140) camera:camera];
    }
    
    
    if (![locAddrssStr isKindOfClass:[NSNull class]] || locAddrssStr.length==0)
    {
        
        searchLocTXt.text=[NSString stringWithFormat:@"%@",locAddrssStr];
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        float lat=[latitudeStr floatValue];
        float longit=[longitudeStr floatValue];

        marker.position = CLLocationCoordinate2DMake(lat, longit);
        marker.title = longitudeStr;
        marker.map = mapView_;
    }
    
    [mapView_ setDelegate:self];
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    [self.view bringSubviewToFront:resultsTableView];
    [mapView_ bringSubviewToFront:resultsTableView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", textField.text];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    //  NSLog(@"query url%@",queryUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchLongitudeAndLattitude:data];
    });
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
  }


- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    
        NSString *substring = [NSString stringWithString:searchLocTXt.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
    substring = [substring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", substring];
//    
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSURL *queryUrl = [NSURL URLWithString:url];
//    //  NSLog(@"query url%@",queryUrl);
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
//        [self fetchLongitudeAndLattitude:data];
//    });
    
    
    NSOperationQueue *que = [[NSOperationQueue alloc] init];
     NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", substring]]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:que completionHandler:^(NSURLResponse *response ,NSData *data,NSError *err){
        dispatch_async(dispatch_get_main_queue(), ^{
            //data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchLongitudeAndLattitude:data];
        });

    }];
    return YES;
    
    
}

-(void)fetchLongitudeAndLattitude:(NSData *)data
{
    resultsTableView.hidden = NO;
    resultLocArray =[[NSMutableArray alloc]init];
    locDetailArray = [[NSMutableArray alloc] init];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
 
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
            [resultLocArray addObject:addressStr];
            [locDetailArray addObject:result];
            float lat =[latitudeStr floatValue];
            float longit =[longitudeStr floatValue];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(lat, longit);
            marker.title = addressStr;
            marker.map = mapView_;
        }
    }
    
    if (results.count>0)
    {
        for (int i = 0;i <[results count]; i++)
        {
            NSDictionary *result = [results objectAtIndex:0];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            NSDictionary*locationDict=[geometry objectForKey:@"location"];
           // addressStr=[result objectForKey:@"formatted_address"];
          //  searchLocTXt.text=addressStr;
           // latitudeStr=[locationDict objectForKey:@"lat"];
           // longitudeStr=[locationDict objectForKey:@"lng"];
        }
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitudeStr doubleValue]
                                                                longitude:[longitudeStr doubleValue]
                                                                     zoom:13];
        mapView_.camera= camera;
    }
    [resultsTableView reloadData];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
        NSLog(@"resultLocArray : %lu",(unsigned long)resultLocArray.count);
        if (resultLocArray.count<=5)
        {
            resultsTableView.frame=CGRectMake(resultsTableView.frame.origin.x, resultsTableView.frame.origin.y, resultsTableView.frame.size.width, 30*resultLocArray.count);
        }
        else{
            resultsTableView.frame=CGRectMake(resultsTableView.frame.origin.x, resultsTableView.frame.origin.y, resultsTableView.frame.size.width, 30*5);
        }
        
        return [resultLocArray count];
}
    


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
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

        if (resultLocArray.count>0)
        {
            NSString *placesName=[resultLocArray objectAtIndex:indexPath.row];
           // NSString *placesName = [tempDict objectForKey:@"description"];
            cell.textLabel.text = placesName;
            
        }
        // cell.textLabel.text = [NSString stringWithFormat:@"%@",[resultLocArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    resultsTableView.hidden = YES;
    NSLog(@"%@",locDetailArray);

    NSDictionary *result = [locDetailArray objectAtIndex:indexPath.row];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary*locationDict=[geometry objectForKey:@"location"];
    
    NSString*placesName=[result objectForKey:@"formatted_address"];
    latitudeStr=[locationDict objectForKey:@"lat"];
    longitudeStr=[locationDict objectForKey:@"lng"];
    searchLocTXt.text=[NSString stringWithFormat:@"%@",placesName];

}
- (IBAction)PlaceSelectedDoneBttn:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:searchLocTXt.text forKey:@"LocAddress"];
    
    [[NSUserDefaults standardUserDefaults] setValue:latitudeStr forKey:@"LocLatitude"];
    
    [[NSUserDefaults standardUserDefaults] setValue:longitudeStr forKey:@"LocLongitude"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    mapView.selectedMarker = marker;
    
    NSString *placesName = marker.title;
    latitudeStr=[NSString stringWithFormat:@"%f",marker.position.latitude];
    longitudeStr=[NSString stringWithFormat:@"%f",marker.position.longitude];
    searchLocTXt.text=[NSString stringWithFormat:@"%@",placesName];
    return YES;
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchLocationBttn:(id)sender {
    [searchLocTXt resignFirstResponder];
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", searchLocTXt.text];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    //  NSLog(@"query url%@",queryUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchLongitudeAndLattitude:data];
    });

}
@end
