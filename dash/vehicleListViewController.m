//
//  vehicleListViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 5/5/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "vehicleListViewController.h"
#import "VehicleTableViewCell.h"
#import "addVehicleViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "Base64.h"
#import "VehicleDetailViewController.h"

@interface vehicleListViewController ()

@end

@implementation vehicleListViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self fetchDataFromDb];
    [vehicleListTableView reloadData];
    if (vehicleListArray .count==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"You have added no vehicle.Would you like to add vehicles?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag=2;
        [alert show];
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
    
    return [vehicleListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    VehicleTableViewCell *cell = (VehicleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VehicleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    vehiclesListOC = [vehicleListArray objectAtIndex:indexPath.row];
    NSLog(vehiclesListOC.vehicle_imageUrl);
    [cell setLabelText:vehiclesListOC.vehicle_imageUrl :vehiclesListOC.color :vehiclesListOC.vehicle_no:vehiclesListOC.vehicle_make:vehiclesListOC.vehicle_modal];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
    if (IS_IPHONE_6P || IS_IPHONE_6)
    {
        deleteBtn.frame = CGRectMake(265.0f, 60.0f,80.0f,25.0f);
        deleteBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];

    }else{
        deleteBtn.frame = CGRectMake(225.0f, 60.0f,75.0f,25.0f);
        deleteBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];

    }
    
    deleteBtn.tag = indexPath.row;
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
        editBtn.frame = CGRectMake(265.0f,25.0f,80.0f,25.0f);
        editBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];

    }else{
        editBtn.frame = CGRectMake(225.0f, 25.0f,75.0f,25.0f);
        editBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];

    }
    
    editBtn.tag = indexPath.row;
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
//
//{
//    static NSString *simpleTableIdentifier = @"ArticleCellID";
//    
//    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        
//    }
//    [cell setBackgroundColor:[UIColor clearColor]];
//    vehiclesListOC = [vehicleListArray objectAtIndex:indexPath.row];
//    
//    [cell setLabelText:vehiclesListOC.vehicle_imageUrl :vehiclesListOC.color :vehiclesListOC.vehicle_no:vehiclesListOC.vehicle_make:vehiclesListOC.vehicle_modal];
//    
//    
//    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
//    if (IS_IPHONE_6P)
//    {
//        deleteBtn.frame = CGRectMake(250.0f, 55.0f,120.0f,30.0f);
//    }else{
//        deleteBtn.frame = CGRectMake(210.0f, 55.0f,100.0f,30.0f);
//    }
//    
//    deleteBtn.tag = indexPath.row;
//    deleteBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
//    [deleteBtn setTintColor:[UIColor blackColor]] ;
//    [deleteBtn addTarget:self action:@selector(deleteBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [deleteBtn setBackgroundColor:[UIColor colorWithRed:207/255.0f green:191/255.0f blue:142/255.0f alpha:1.0]];
//    deleteBtn.layer.borderColor = [UIColor clearColor].CGColor;
//    deleteBtn.layer.borderWidth = 1.5;
//    deleteBtn.layer.cornerRadius = 16.0;
//    [cell.contentView addSubview:deleteBtn];
//    ///////  Edit BUTTON //////////
//    
//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
//    if (IS_IPHONE_6P)
//    {
//        editBtn.frame = CGRectMake(250.0f, 15.0f,120.0f,30.0f);
//    }else{
//        editBtn.frame = CGRectMake(210.0f, 15.0f,100.0f,30.0f);
//    }
//    
//    editBtn.tag = indexPath.row;
//    editBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
//    [editBtn setTintColor:[UIColor blackColor]] ;
//    [editBtn addTarget:self action:@selector(editBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [editBtn setBackgroundColor:[UIColor colorWithRed:207/255.0f green:191/255.0f blue:142/255.0f alpha:1.0]];
//    editBtn.layer.borderColor = [UIColor clearColor].CGColor;
//    editBtn.layer.borderWidth = 1.5;
//    editBtn.layer.cornerRadius = 16.0;
//    [cell.contentView addSubview:editBtn];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
//}

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
        vehiclesListOC = [[vehiclesLIstObj alloc]init];
        vehiclesListOC.vehicle_make = [queryResults stringForColumn:@"vehicleMake"];
        vehiclesListOC.vehicle_modal = [queryResults stringForColumn:@"vehicleModal"];
        vehiclesListOC.vehicle_no = [queryResults stringForColumn:@"vehicleNumber"];
        vehiclesListOC.vehicleId = [queryResults stringForColumn:@"vehicleId"];
        vehiclesListOC.vehicle_imageUrl = [queryResults stringForColumn:@"vehicleImageUrl"];
        NSLog(vehiclesListOC.vehicle_imageUrl);
        vehiclesListOC.color = [queryResults stringForColumn:@"vehicleColor"];
        [vehicleListArray addObject:vehiclesListOC];
            }
    [database close];
    [vehicleListTableView reloadData];
}
- (IBAction)editBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    vehiclesListOC = [vehicleListArray objectAtIndex:indexPath.row];
    addVehicleViewController*addVehicle=[[addVehicleViewController alloc]initWithNibName:@"addVehicleViewController" bundle:[NSBundle mainBundle]];
    addVehicle.addVehicleDataType = @"Edit";
    addVehicle.headerLblStr=@"DASH";
    addVehicle.vehicleListOC = vehiclesListOC;
    [self.navigationController pushViewController:addVehicle animated:NO];
}
- (IBAction)deleteBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    vehiclesListOC = [vehicleListArray objectAtIndex:indexPath.row];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to delete this vehicle?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
    alert.tag=7;
    [alert show];
    
    
}
-(void)deleteVehicle:(NSString *)vehicleId{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    vehcleIdStr=vehicleId;
    
    trigger = [NSString stringWithFormat:@"delete"];
    
    _postData = [NSString stringWithFormat:@"vehicle_id=%@&user_id=%@&color=%@&vehicleNo=%@&make=%@&modal=%@&imageUrl=%@&trigger=%@",vehicleId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],@"",@"",@"",@"",@"",trigger];
   
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/location-vehicle.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    [self fetchDataFromDb];
}
- (IBAction)addVehicleBtn:(id)sender {
    
    addVehicleViewController*addVehicle=[[addVehicleViewController alloc]initWithNibName:@"addVehicleViewController" bundle:[NSBundle mainBundle]];
    addVehicle.addVehicleDataType = @"Edit";
    addVehicle.headerLblStr=@"DASH";
    addVehicle.triggerValue=@"Add";
    addVehicle.vehicleListOC = vehiclesListOC;
    [self.navigationController pushViewController:addVehicle animated:NO];
    
    
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7 && buttonIndex ==1)
    {
        [self deleteVehicle:[NSString stringWithFormat:@"%@",vehiclesListOC.vehicleId]];
    }
    else if (alertView.tag == 2 && buttonIndex ==1)
    {
        addVehicleViewController*addVehicle=[[addVehicleViewController alloc]initWithNibName:@"addVehicleViewController" bundle:[NSBundle mainBundle]];
        addVehicle.addVehicleDataType = @"Edit";
        addVehicle.headerLblStr=@"DASH";
        addVehicle.triggerValue=@"Add";
        addVehicle.vehicleListOC = vehiclesListOC;
        [self.navigationController pushViewController:addVehicle animated:NO];

    }
    else if (alertView.tag == 2 && buttonIndex ==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
//    VehicleDetailViewController *detailVc=[[VehicleDetailViewController alloc]initWithNibName:@"VehicleDetailViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:detailVc animated:YES];
}


-(void)deleteFromDatabase {
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    if ([trigger isEqualToString:@"delete"])
    {
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM vehiclesList where vehicleId=\"%@\"",vehcleIdStr];
        [database executeUpdate:queryString1];
    }
}



@end
