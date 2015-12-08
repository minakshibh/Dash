//
//  WorkSamplesViewController.m
//  dash
//
//  Created by Br@R on 08/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "WorkSamplesViewController.h"
#import "workSampleTableViewCell.h"
#import "AsyncImageView.h"
#import "uploadWorkSamplesViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@interface WorkSamplesViewController ()

@end

@implementation WorkSamplesViewController

- (void)viewDidLoad
{
    [self FetchBasicProfile];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    addmoreBtn.layer.borderColor = [UIColor grayColor].CGColor;
    addmoreBtn.layer.borderWidth = 1.0;
    addmoreBtn.layer.cornerRadius = 4.0;
    [addmoreBtn setClipsToBounds:YES];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"role"] isEqualToString:@"customer"])
    {
        addmoreBtn.hidden=YES;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self fetchWorksampleInfoFromDatabase];
}
-(void) fetchWorksampleInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    worksampleDetails = [[NSMutableArray alloc] init];

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
        beforeBtn.hidden=YES;
        afterBtn.hidden=YES;
    }
    [database close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [worksampleDetails count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel*vehicleLbl;
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        vehicleLbl= [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 230,25)];
    
    NSString *indexStr = [NSString stringWithFormat:@"%lu", (long)indexPath.row];
    
    workSampleOC  =(workSampleObj *) [worksampleDetails objectAtIndex:indexPath.row];

    vehicleLbl.backgroundColor = [UIColor clearColor];
    vehicleLbl.textColor=[UIColor colorWithRed:224.0f/255.0f green:15.0f/255.0f blue:70.0f/255.0f alpha:1.0f ];
    [cell.contentView addSubview:vehicleLbl];


    
    AsyncImageView *beforetemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",workSampleOC.beforeServiceUrl];
    imageUrls = [imageUrls stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    beforetemImage.imageURL = [NSURL URLWithString:imageUrls];
    beforetemImage.showActivityIndicator = YES;
    
    if ( IS_IPHONE_6 ) {
        beforetemImage.frame = CGRectMake(8 , 30, 160 , 120);
    }
    else if ( IS_IPHONE_6P ) {
        beforetemImage.frame = CGRectMake(8 , 30, 180 , 120);
    }
    else{
        beforetemImage.frame = CGRectMake(5 , 30, 148 , 120);
    }
    
    [cell.contentView addSubview:beforetemImage];
    
    AsyncImageView *afterItemImage = [[AsyncImageView alloc] init];
    NSString *afterimageUrls = [NSString stringWithFormat:@"%@",workSampleOC.afterServiceUrl];
    afterimageUrls = [afterimageUrls stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    afterItemImage.imageURL = [NSURL URLWithString:afterimageUrls];
    afterItemImage.showActivityIndicator = YES;
    if ( IS_IPHONE_6 ) {
        afterItemImage.frame = CGRectMake(180 , 30, 160 , 120);
    }
    else if ( IS_IPHONE_6P ) {
        afterItemImage.frame = CGRectMake(200 , 30, 190 , 120);
    }
    else{
        afterItemImage.frame = CGRectMake(157 , 30, 148 , 120);
    }
   
    [cell.contentView addSubview:afterItemImage];

    
    if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"role"] isEqualToString:@"customer"])
    {
        
        
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
        if ( IS_IPHONE_6)
        {
            deleteBtn.frame = CGRectMake(320.0f, 3.0f,20.0f,20.0f);
        }
       else if  (IS_IPHONE_6P )
        {
            deleteBtn.frame = CGRectMake(320.0f, 3.0f,20.0f,20.0f);
        }
        else{
            deleteBtn.frame = CGRectMake(230.0f, 4.0f,20.0f,20.0f);
        }
        
        deleteBtn.tag = indexPath.row;
        deleteBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
        [deleteBtn setTintColor:[UIColor clearColor]] ;
        
        [deleteBtn addTarget:self action:@selector(deleteBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        deleteBtn.layer.borderColor = [UIColor clearColor].CGColor;
        deleteBtn.layer.borderWidth = 1.5;
        deleteBtn.layer.cornerRadius = 7.0;
        
        UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"delete.png"];
        [deleteBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
        
        
        [cell.contentView addSubview:deleteBtn];

        ///////  Edit BUTTON //////////
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       // [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
        if ( IS_IPHONE_6)
        {
            editBtn.frame = CGRectMake(290.0f, 3.0f,20.0f,20.0f);
        }
       else if (IS_IPHONE_6P )
        {
            editBtn.frame = CGRectMake(360.0f, 3.0f,20.0f,20.0f);
        }
        else{
            editBtn.frame = CGRectMake(265.0f, 4.0f,20.0f,20.0f);
        }
        
        editBtn.tag = indexPath.row;
        editBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
        [editBtn setTintColor:[UIColor clearColor]] ;
        
        [editBtn addTarget:self action:@selector(editBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setBackgroundColor:[UIColor clearColor]];
        
    
        UIImage *buttonBackgroundShowDetail1= [UIImage imageNamed:@"edit-icon.png"];
        [editBtn setBackgroundImage:buttonBackgroundShowDetail1 forState:UIControlStateNormal];

        [cell.contentView addSubview:editBtn];
        
    }
    
    vehicleLbl.text=workSampleOC.vehicleDetail;
    
    return cell;
}
- (IBAction)deleteBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    workSampleOC  =(workSampleObj *) [worksampleDetails objectAtIndex:indexPath.row];
    UIAlertView*alrt=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to delete this work sample?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alrt.tag=5;
    [alrt show];
}



- (IBAction)editBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    workSampleOC  =(workSampleObj *) [worksampleDetails objectAtIndex:indexPath.row];
    
    uploadWorkSamplesViewController *workSamples=[[uploadWorkSamplesViewController alloc]initWithNibName:@"uploadWorkSamplesViewController" bundle:[NSBundle mainBundle]];
    workSamples.trigger=@"edit";
    workSamples.workSampleOC=workSampleOC;
    [self.navigationController pushViewController:workSamples animated:YES];
}

- (IBAction)addBtnAction:(id)sender
{
    uploadWorkSamplesViewController *workSamples=[[uploadWorkSamplesViewController alloc]initWithNibName:@"uploadWorkSamplesViewController" bundle:[NSBundle mainBundle]];
    workSamples.trigger=@"add";
    workSamples.backBtnHiden=@"NO";
    workSamples.headerLblStr=@"DASH";
    [self.navigationController pushViewController:workSamples animated:YES];

}
- (IBAction)backBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5 && buttonIndex ==1)
    {
        [self deleteVehicle];
    }
}

-(void)deleteVehicle
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    
    NSString*trigger = [NSString stringWithFormat:@"delete"];
    
    NSString*_postData = [NSString stringWithFormat:@"worksample_id=%@&carDetails= &user_id=%@&vehicleNo= &make= &modal= &imageUrl= &trigger=%@",workSampleOC.workSampleId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],trigger];

    
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/work-sample.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
            if (webservice==12) {
                [self saveWorkSampleData:userDetailDict];
            }else{
            [self saveWorkSampleData:userDetailDict];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your work sample deleted Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=1;
                [alert show];
            }
        }
    }
}

-(void) saveWorkSampleData :(NSDictionary*)userDetailDict
{
    if(webservice==12)
    {   webservice = 0 ;
        NSMutableArray *workSamplArray = [userDetailDict valueForKey:@"work_sample"];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM workSamples"];
        [database executeUpdate:queryString1];
        
        for (int i = 0; i < [workSamplArray count]; i++) {
            
            NSString *workSampleId = [[workSamplArray valueForKey:@"ID"] objectAtIndex:i];
            NSString *vehicledetail = [[workSamplArray valueForKey:@"makeAndModelDetails"] objectAtIndex:i];
            NSString *beforeImage = [[workSamplArray valueForKey:@"beforeImageUrl"] objectAtIndex:i];
            NSString *afterImage = [[workSamplArray valueForKey:@"afterImageUrl"] objectAtIndex:i];
            
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO workSamples (workSampleId,vehiclDetail,beforeImage,afterImage) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",workSampleId,vehicledetail,beforeImage,afterImage];
            [database executeUpdate:insert];
        }
        
        [database close];
        
    }else{
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
    [self fetchWorksampleInfoFromDatabase];
    [workSampleTableView reloadData];
}
-(void) FetchBasicProfile
{
    webservice=12;
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
