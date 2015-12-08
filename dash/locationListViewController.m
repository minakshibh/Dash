//
//  locationListViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 06/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "locationListViewController.h"
#import "locationListTableViewCell.h"
#import "addLocationViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "LocationDetailViewController.h"

@interface locationListViewController ()

@end

@implementation locationListViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchDataFromDb];
    [locationListTableView reloadData];
    
    if (locationListArray .count==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"You have added no location.Would you like to add location?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag=2;
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7 && buttonIndex ==1)
    {
        [self deleteVehicle:[NSString stringWithFormat:@"%@",locationListOC.locationId]];
    }
    else if (alertView.tag == 2 && buttonIndex ==1)
    {
        addLocationViewController*addVehicle=[[addLocationViewController alloc]initWithNibName:@"addLocationViewController" bundle:[NSBundle mainBundle]];
        addVehicle.addLocationDataType = @"Edit";
        addVehicle.headerLblStr=@"DASH";
        addVehicle.triggervalue=@"Add";
        addVehicle.locationOC = locationListOC;
        [self.navigationController pushViewController:addVehicle animated:NO];
    }
    else if (alertView.tag == 2 && buttonIndex ==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [locationListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    locationListTableViewCell *cell = (locationListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"locationListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    locationListOC = [locationListArray objectAtIndex:indexPath.row];
    [cell setLabelText:locationListOC.loactionName :locationListOC.locationAddress];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
    
    if (IS_IPHONE_6P || IS_IPHONE_6)
    {
        deleteBtn.frame = CGRectMake(260.0f, 55.0f,85.0f,25.0f);
    }else{
        deleteBtn.frame = CGRectMake(215.0f, 55.0f,80.0f,25.0f);
    }
    
    deleteBtn.tag = indexPath.row;
    deleteBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
    [deleteBtn setTintColor:[UIColor whiteColor]] ;
    [deleteBtn addTarget:self action:@selector(deleteBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteBtn setBackgroundColor:[UIColor blackColor]];
     
    deleteBtn.layer.borderColor = [UIColor clearColor].CGColor;
    deleteBtn.layer.borderWidth = 1.5;
    deleteBtn.layer.cornerRadius = 7.0;
    [cell.contentView addSubview:deleteBtn];
 
    
    ///////  Edit BUTTON //////////
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
    if (IS_IPHONE_6P || IS_IPHONE_6)
    {
        editBtn.frame = CGRectMake(260.0f, 17.0f,85.0f,25.0f);
    }else{
        editBtn.frame = CGRectMake(215.0f, 17.0f,80.0f,25.0f);
    }
    
    editBtn.tag = indexPath.row;
    editBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
    [editBtn setTintColor:[UIColor whiteColor]] ;
    [editBtn addTarget:self action:@selector(editBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:15.0f/255.0f blue:70.0f/255.0f alpha:1.0f ]];
    editBtn.layer.borderColor = [UIColor clearColor].CGColor;
    editBtn.layer.borderWidth = 1.5;
    editBtn.layer.cornerRadius = 7.0;
    [cell.contentView addSubview:editBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
        locationListOC = [[locationListObj alloc]init];
        locationListOC.loactionName = [queryResults stringForColumn:@"loactionName"];
        locationListOC.locationId = [queryResults stringForColumn:@"locationId"];
        locationListOC.locationAddress = [queryResults stringForColumn:@"locationAddress"];
        locationListOC.locationLatitude = [queryResults stringForColumn:@"locationLatitude"];
        locationListOC.locationLongitude = [queryResults stringForColumn:@"locationLongitude"];
        [locationListArray addObject:locationListOC];
    }
    [database close];
    [locationListTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
//    locationListOC = (locationListObj*)[locationListArray objectAtIndex:indexPath.row];
//
//    LocationDetailViewController *detailVc=[[LocationDetailViewController alloc]initWithNibName:@"LocationDetailViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:detailVc animated:YES];
}






- (IBAction)editBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    locationListOC = [locationListArray objectAtIndex:indexPath.row];
    addLocationViewController*addVehicle=[[addLocationViewController alloc]initWithNibName:@"addLocationViewController" bundle:[NSBundle mainBundle]];
    addVehicle.addLocationDataType = @"Edit";
    addVehicle.headerLblStr=@"DASH";
    addVehicle.locationOC = locationListOC;
    [self.navigationController pushViewController:addVehicle animated:NO];
}

- (IBAction)deleteBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    locationListOC = [locationListArray objectAtIndex:indexPath.row];

    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to delete this location?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
    alert.tag=7;
    [alert show];

}


-(void)deleteVehicle:(NSString *)vehicleId{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    trigger = [NSString stringWithFormat:@"delete"];
    _postData = [NSString stringWithFormat:@"loc_id=%@&user_id=%@&loc_name=%@&address=%@&latitude=%@&longitude=%@&trigger=%@",vehicleId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],@"",@"",@"",@"",trigger];
    NSLog([[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
    
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
    [self fetchDataFromDb];
}
- (IBAction)addLocationBttn:(id)sender
{
    addLocationViewController*addVehicle=[[addLocationViewController alloc]initWithNibName:@"addLocationViewController" bundle:[NSBundle mainBundle]];
    addVehicle.addLocationDataType = @"Edit";
    addVehicle.headerLblStr=@"DASH";
    addVehicle.triggervalue=@"Add";
    
    addVehicle.locationOC = locationListOC;
    [self.navigationController pushViewController:addVehicle animated:NO];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
