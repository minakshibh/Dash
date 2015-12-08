//
//  assignmentsViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 6/4/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "assignmentsViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "Base64.h"
#import "assignmentTableViewCell.h"
#import "reciveRequestdetailViewController.h"
#import "detailerViewController.h"
#import "BlockPersonViewController.h"
#import "homeViewViewController.h"
#import "requestServiceViewController.h"
@interface assignmentsViewController ()

@end

@implementation assignmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.triggerValue isEqualToString:@"customer"] && [self.timing isEqualToString:@"upcoming"]) {
        titleLbl.text = @"Scheduled Services";
        viewAsCalenderBtn.hidden = YES;
        viewAsListBtn.hidden = YES;
        [self fetchAssignmentList];
    }
    else if([self.timing isEqualToString:@"past"]){
        titleLbl.text = @"Service History";
        viewAsCalenderBtn.hidden = YES;
        viewAsListBtn.hidden = YES;
        [self fetchAssignmentList];
    }
    else if([self.triggerValue isEqualToString:@"detailer"] && [self.timing isEqualToString:@"upcoming"])
    {
        titleLbl.text = @"Assignment List";
        [self fetchAssignmentList];
    }else if([self.timing isEqualToString:@"BlockedList"])
    {
        viewAsListBtn.hidden = YES;
        viewAsCalenderBtn.hidden = YES;
        titleLbl.text = @"Blocked User";
        [self fetchdata];
    }else if([self.recommend_Detailers isEqualToString:@"yes"])
    {
        viewAsCalenderBtn.hidden = YES;
        viewAsListBtn.hidden = YES;
        titleLbl.text = @"Recommended Detailers";
        [self fetchdata];
    }
    isEdit = NO;
    [viewAsListBtn setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == assignmentTableView) {
        return [assignmentListArray count];
    }else{
        return [scheduleListArray count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    assignmentTableViewCell *cell = (assignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"assignmentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    if(tableView == assignmentTableView){
        if([self.recommend_Detailers isEqualToString:@"yes"])
        {
            mapDetailsOC = [assignmentListArray objectAtIndex:indexPath.row];
        }else
        {
            assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
        }
    }else{
        assignmentOC = [scheduleListArray objectAtIndex:indexPath.row];
    }
    NSString *serviceDateTime;
    // ~~~~~~~~~ Date conpairison
    NSString *selfAssignedStr = [NSString stringWithFormat:@"%@",assignmentOC.isSelfAssigned];
    if([self.timing isEqualToString:@"BlockedList"])
    {
        [cell setLabelText:assignmentOC.detailer_name :assignmentOC.address :@"BlockedList" :@"":assignmentOC.detailer_image];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _timing = @"BlockedList";
        
        
    }else {
        if(![self.recommend_Detailers isEqualToString:@"yes"]){
            NSDate *todaysDate;
            todaysDate = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-mm-dd"];
            NSString *currentDate = [ dateFormat stringFromDate:todaysDate];
            todaysDate = [dateFormat dateFromString:currentDate];
            if ([assignmentOC.isSelfAssigned isEqualToString:@"true"]) {
                
                UILabel *deleteBtn = [[UILabel alloc] init] ;
                
                
                if (IS_IPHONE_6P || IS_IPHONE_6)
                {
                    deleteBtn.frame = CGRectMake(250.0f, 5.0f,85.0f,25.0f);
                }else{
                    deleteBtn.frame = CGRectMake(205.0f, 5.0f,80.0f,25.0f);
                }
                
                
                [deleteBtn setFont:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]];
                deleteBtn.textColor = [UIColor blackColor];
                deleteBtn.text = @"Is Self Assigned";
                [deleteBtn setBackgroundColor:[UIColor whiteColor]];
                [cell.contentView addSubview:deleteBtn];
            }
            
            
            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
            [dateFormat1 setDateFormat:@"YYYY-mm-dd HH:mm:ss"];
            NSDate *serviceDate = [dateFormat1 dateFromString:assignmentOC.time];
            NSString *serviceDateStr = [dateFormat stringFromDate:serviceDate];
            serviceDate = [dateFormat dateFromString:serviceDateStr];
            NSLog(@"Current Date ..... %@, ServiceDate..... %@",todaysDate,serviceDate);
            
            calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSString *timeFrom = [NSString stringWithFormat:@"%@",assignmentOC.time];
            NSArray* dateFromArray = [timeFrom componentsSeparatedByString: @" "];
            NSString *dateToSelect =[NSString stringWithFormat:@"%@",[dateFromArray objectAtIndex:0]];
            NSArray *dateComponentsArray = [dateToSelect componentsSeparatedByString:@"-"];
            int yearValue = [[dateComponentsArray objectAtIndex:0]intValue];
            
            int monthValue = [[dateComponentsArray objectAtIndex:1]intValue];
            
            int dateValue = [[dateComponentsArray objectAtIndex:2]intValue];
            
            NSDateComponents *dateParts = [[NSDateComponents alloc] init];
            [dateParts setMonth:monthValue];
            [dateParts setYear:yearValue];
            [dateParts setDay:dateValue];
            NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
            
            
            if ([todaysDate compare:serviceDate] == NSOrderedSame) {
                NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                [dateFormat1 setDateFormat:@"HH:mm:ss"];
                NSDate *serviceTime = [dateFormat1 dateFromString:assignmentOC.time];
                serviceDateTime = [dateFormat stringFromDate:serviceTime];
            }else{
                //        NSDate *serviceTime = [dateFormat1 dateFromString:dateOnFirst];
                NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                [dateFormat1 setDateFormat:@"dd MMM"];
                serviceDateTime = [dateFormat1 stringFromDate:dateOnFirst];
                NSLog(@"Service time ..... %@",serviceDateTime);
            }
        }
    NSString *vehicleNameStr = [NSString stringWithFormat:@"%@, %@ %@ %@",assignmentOC.vehicleNo,assignmentOC.vehicleColor,assignmentOC.vehicleMake,assignmentOC.vehicleModal];
        if([self.timing isEqualToString:@"past"])
        {   NSString *time;
            if([assignmentOC.later isEqualToString:@"now"])
            {
                NSArray* foo = [assignmentOC.requested_time componentsSeparatedByString:@" "];
                NSArray *foo1;
                foo1 =[[foo objectAtIndex:0] componentsSeparatedByString:@"-"];
                time = [NSString stringWithFormat:@"%@-%@",[foo1 objectAtIndex:2],[foo1 objectAtIndex:1]];
                
                
                
            }else{
                NSArray* foo = [assignmentOC.time componentsSeparatedByString:@" "];
                NSArray *foo1;
                foo1 =[[foo objectAtIndex:0] componentsSeparatedByString:@"-"];
                time = [NSString stringWithFormat:@"%@-%@",[foo1 objectAtIndex:2],[foo1 objectAtIndex:1]];
                
                
            }
            NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
            
            if ([role isEqualToString:@"customer"])
            {
                
                [cell setLabelText:assignmentOC.detailer_name :vehicleNameStr :assignmentOC.address:time:assignmentOC.detailer_image];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            else
            {
                
                [cell setLabelText:assignmentOC.cust_name :vehicleNameStr :assignmentOC.address:time:assignmentOC.cust_image];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else
        {
            if([self.recommend_Detailers isEqualToString:@"yes"])
            {
                if ([mapDetailsOC.placeImage isKindOfClass:[NSNull class]])
                {
                    mapDetailsOC.placeImage = @" ";
                }
                [cell setLabelText:mapDetailsOC.detailrName :mapDetailsOC.detailrEmail :mapDetailsOC.detailerContact:@"hide":mapDetailsOC.placeImage];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else
            {
                
                [cell setLabelText:vehicleNameStr :assignmentOC.service_type_id :assignmentOC.address:serviceDateTime:assignmentOC.cust_image];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    
//    [cell setLabelText:vehicleNameStr :assignmentOC.service_type_id :assignmentOC.address:serviceDateTime:assignmentOC.image];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell.contentView.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.contentView.layer setBorderWidth:0.5f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.layer.cornerRadius = 10.0;
    [cell setClipsToBounds:YES];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.timing isEqualToString:@"BlockedList"])
    {
        BlockPersonViewController *obj = [[BlockPersonViewController alloc]initWithNibName:@"BlockPersonViewController" bundle:nil];
        
        assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
        obj.user_id =assignmentOC.detailer_ID;
        
        if ([_detail isEqualToString:@"fromDetailer"])
        {
            obj.usertype = @"fromDetailer";
        }
        [self.navigationController pushViewController:obj animated:YES];
        
    }else {
        if([self.recommend_Detailers isEqualToString:@"yes"])
        {
            mapDetailsOC = [assignmentListArray objectAtIndex:indexPath.row];
            detailerViewController *obj = [[detailerViewController alloc]initWithNibName:@"detailerViewController" bundle:nil];
            obj.mapDetailsOC = mapDetailsOC;
            [self.navigationController pushViewController:obj animated:YES];
        }else
        {
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
            
        if(tableView == assignmentTableView){
    assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
        }else{
            assignmentOC = [scheduleListArray objectAtIndex:indexPath.row];
        }
        
        reciveRequestdetailViewController *reciveRequestVc=[[reciveRequestdetailViewController alloc]initWithNibName:@"reciveRequestdetailViewController" bundle:nil];
    reciveRequestVc.assignmentOC = assignmentOC;
            
    if([_triggerValue isEqualToString:@"detailer"])
    {
        reciveRequestVc.distassign =@"detailer";
        if([_timing isEqualToString:@"upcoming"])
        {
            reciveRequestVc.arrivalbtn = @"yes";
        }
    }
            if([_serviceHistoryUserBlock isEqualToString:@"BlockBtn"])
            {
                reciveRequestVc.BlockBtn = @"BlockBtn";
                reciveRequestVc.custid = assignmentOC.customer_id;
                reciveRequestVc.servicehistorypast = @"yes";
            }    NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
    if ([role isEqualToString:@"customer"])
    {     reciveRequestVc.custView = @"Yes"; }
    reciveRequestVc.from_assignment = @"Yes";
        [self.navigationController pushViewController:reciveRequestVc animated:YES];
    }
    }
}
-(void)fetchdata
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    if([self.timing isEqualToString:@"BlockedList"])
    {
        webservice = 4;
        _postData = [NSString stringWithFormat:@"userId=%@&isBlocked=%@&blocked_id=%@&last_updated=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],@"",@"-1",@""];
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/block-detailer.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }else if([self.recommend_Detailers isEqualToString:@"yes"])
    {
        webservice = 8;
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
        
        _postData = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-recommended-user.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    //customer and upcoming
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



-(void)fetchAssignmentList{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
   
        webservice = 3;
        _postData = [NSString stringWithFormat:@"user_id=%@&trigger=%@&timings=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],self.triggerValue,self.timing];
        //NSLog(self.triggerValue);
        //NSLog(self.timing);
        //NSLog([[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]);
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-detailer-assignment.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];

    //customer and upcoming
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
    
    if (webservice == 3) {
        NSLog(@"responseString:%@",userDetailDict);
        NSMutableArray *vehicleInfoArray = [userDetailDict valueForKey:@"request_data"];
        assignmentListArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [vehicleInfoArray count]; i++) {
            assignmentOC = [[assignmentObj alloc] init];
            assignmentOC.requestId = [[vehicleInfoArray valueForKey:@"ID"] objectAtIndex:i];
            assignmentOC.address = [[vehicleInfoArray valueForKey:@"address"] objectAtIndex:i];
            assignmentOC.after_img_url = [[vehicleInfoArray valueForKey:@"after_img_url"] objectAtIndex:i];
            assignmentOC.bfr_img_url = [[vehicleInfoArray valueForKey:@"bfr_img_url"] objectAtIndex:i];
            assignmentOC.cancelled_detailer = [[vehicleInfoArray valueForKey:@"cancelled_detailer"] objectAtIndex:i];
            assignmentOC.customer_id = [[vehicleInfoArray valueForKey:@"customer_id"] objectAtIndex:i];
            assignmentOC.detailer_ID = [[vehicleInfoArray valueForKey:@"detailer_ID"] objectAtIndex:i];
            assignmentOC.image = [[vehicleInfoArray valueForKey:@"vehicle_image"] objectAtIndex:i];
            assignmentOC.later = [[vehicleInfoArray valueForKey:@"later"] objectAtIndex:i];
            assignmentOC.latitude = [[vehicleInfoArray valueForKey:@"latitude"] objectAtIndex:i];
            assignmentOC.longitude = [[vehicleInfoArray valueForKey:@"longitude"] objectAtIndex:i];
            assignmentOC.payment_mode = [[vehicleInfoArray valueForKey:@"payment_mode"] objectAtIndex:i];
            assignmentOC.requested_detailer = [[vehicleInfoArray valueForKey:@"requested_detailer"] objectAtIndex:i];
            assignmentOC.requested_time = [[vehicleInfoArray valueForKey:@"requested_time"] objectAtIndex:i];
            assignmentOC.service_status = [[vehicleInfoArray valueForKey:@"service_status"] objectAtIndex:i];
            assignmentOC.service_type_id = [[vehicleInfoArray valueForKey:@"service_type_id"] objectAtIndex:i];
            assignmentOC.time = [[vehicleInfoArray valueForKey:@"time"] objectAtIndex:i];
            assignmentOC.vehicleColor = [[vehicleInfoArray valueForKey:@"vehicleColor"] objectAtIndex:i];
            assignmentOC.vehicleMake = [[vehicleInfoArray valueForKey:@"vehicleMake"] objectAtIndex:i];
            assignmentOC.vehicleModal = [[vehicleInfoArray valueForKey:@"vehicleModal"] objectAtIndex:i];
            assignmentOC.vehicleNo = [[vehicleInfoArray valueForKey:@"vehicleNo"] objectAtIndex:i];
            assignmentOC.detailer_name = [[vehicleInfoArray valueForKey:@"detailer_name"] objectAtIndex:i];
            assignmentOC.detailer_image = [[vehicleInfoArray valueForKey:@"detailer_image"] objectAtIndex:i];
            assignmentOC.cust_name = [[vehicleInfoArray valueForKey:@"customer_name"] objectAtIndex:i];
            assignmentOC.cust_image = [[vehicleInfoArray valueForKey:@"customer_image"] objectAtIndex:i];
            assignmentOC.cust_rate = [[vehicleInfoArray valueForKey:@"customer_rating"] objectAtIndex:i];
            assignmentOC.dist_rate = [[vehicleInfoArray valueForKey:@"detailer_rating"] objectAtIndex:i];
            NSString *rating = [[vehicleInfoArray valueForKey:@"service_id_rating"] objectAtIndex:i];
            assignmentOC.isSelfAssigned = [[vehicleInfoArray valueForKey:@"isSelfAssigned"] objectAtIndex:i];
            
            assignmentOC.service_id_rating = rating;
            [assignmentListArray addObject:assignmentOC];
        }
        
    }else if ( webservice == 5) {
        NSString *result = [userDetailDict valueForKey:@"message"];
        if ([result isEqualToString:@"success"]) {
            [assignmentTableView reloadData];
        }
    }else if (webservice == 8) {
        NSMutableArray *InfoArray = [userDetailDict valueForKey:@"detailer_info"];
        assignmentListArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [InfoArray count]; i++)
        {
            mapDetailsOC = [[mapDetailsObj alloc]init];
            mapDetailsOC.detailrName = [[InfoArray valueForKey:@"name"]objectAtIndex:i];
            mapDetailsOC.placeRatingStr = [[InfoArray valueForKey:@"rating"]objectAtIndex:i];
            mapDetailsOC.placeImage = [[InfoArray valueForKey:@"imageUrl"]objectAtIndex:i];
            mapDetailsOC.latitudeStr = [[InfoArray valueForKey:@"latitude"]objectAtIndex:i];
            mapDetailsOC.longitudeStr = [[InfoArray valueForKey:@"longitude"]objectAtIndex:i];
            mapDetailsOC.detailrEmail = [[InfoArray valueForKey:@"email"]objectAtIndex:i];
            mapDetailsOC.detailerContact = [[InfoArray valueForKey:@"contact_info"]objectAtIndex:i];
            mapDetailsOC.workSamples = [[InfoArray valueForKey:@"work_sample"]objectAtIndex:i];
            mapDetailsOC.detailrId = [[InfoArray valueForKey:@"ID"]objectAtIndex:i];
            [assignmentListArray addObject:mapDetailsOC];
        }
    }
    
    if(webservice == 4)
    {
        NSString *result = [userDetailDict valueForKey:@"message"];
        if ([result isEqualToString:@"success"]) {
            //NSDictionary *dist = [userDetailDict valueForKey:@"block_list"];
            
            
            NSMutableArray *arr = [userDetailDict valueForKey:@"block_list"];
            assignmentListArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [arr count]; i++) {
                assignmentOC = [[assignmentObj alloc] init];
                assignmentOC.detailer_ID = [[arr valueForKey:@"blocked_id"] objectAtIndex:i];
           assignmentOC.detailer_ID = [[arr valueForKey:@"blocked_id"] objectAtIndex:i];
                assignmentOC.detailer_name = [[arr valueForKey:@"blocked_user_name"] objectAtIndex:i];
                assignmentOC.address = [[arr valueForKey:@"blocked_user_email"] objectAtIndex:i];
                assignmentOC.detailer_image = [[arr valueForKey:@"blocked_user_image"] objectAtIndex:i];
                [assignmentListArray addObject:assignmentOC];
                
                }
            }   
        }
    
    
    
     [assignmentTableView reloadData];
    
}

- (IBAction)backBtnAction:(id)sender {
    if([_from_reciveRequest isEqualToString:@"yes"])
    {
    homeViewViewController *obj = [[homeViewViewController alloc]init];
    obj.presentUserID = _presentuserid;
     [self.navigationController pushViewController:obj animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    // [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewAsListBtnAction:(id)sender {
    assignmentTableView.hidden = NO;
    calendarView.hidden = YES;
    [viewAsListBtn setBackgroundColor:[UIColor blackColor]];
    [viewAsCalenderBtn setBackgroundColor:[UIColor grayColor]];
}

- (IBAction)viewAsCalenderBtnAction:(id)sender {
    
    assignmentTableView.hidden = YES;
    [viewAsListBtn setBackgroundColor:[UIColor grayColor]];
    [viewAsCalenderBtn setBackgroundColor:[UIColor blackColor]];
    if (IS_IPHONE_5)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 203, 300, 200) fontName:@"Helvetica" delegate:self assignmentList:assignmentListArray];
    }
    
    if (IS_IPHONE_6)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10,250, 354, 245) fontName:@"Helvetica" delegate:self assignmentList:assignmentListArray];
    }
    if (IS_IPHONE_6P)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10,280, 394, 245) fontName:@"Helvetica" delegate:self assignmentList:assignmentListArray];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 168, 300, 185) fontName:@"Helvetica" delegate:self assignmentList:assignmentListArray];
    }
    
//    lessondetailBcakView.hidden=YES;
    
    
    [self.view addSubview: calendarView];
    //    [self.view bringSubviewToFront:buttonsView];NSInteger Aindex = 0;
    
//    [calendarView bringSubviewToFront:buttonsView];
//    [self.view bringSubviewToFront:lessondetailBcakView];
//    [calendarView bringSubviewToFront:lessondetailBcakView];
}

- (IBAction)editScheduleBtnAction:(id)sender {
    isEdit = YES;
    assignmentListTableView.hidden = YES;
    calendarView.hidden = YES;
    calendarView.userInteractionEnabled = YES;
    viewAsListBtn.hidden = NO;
    viewAsCalenderBtn.hidden = NO;
    viewAsCalenderBtn.userInteractionEnabled = YES;
    viewAsListBtn.userInteractionEnabled = YES;
    backBtn.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:scheduleTypeSelectionView];
    scheduleTypeSelectionView.hidden = YES;
    assignmentTableView.hidden = NO;
    [assignmentTableView reloadData];
}

- (IBAction)viewScheduleBtnAction:(id)sender {
    scheduleListArray = [[NSMutableArray alloc] init];
    if(indexsArray.count >0 ){
        assignmentListTableView.hidden = NO;
        calendarView.hidden = YES;
        calendarView.userInteractionEnabled = YES;
        viewAsListBtn.hidden = YES;
        viewAsCalenderBtn.hidden = YES;
        backBtn.userInteractionEnabled = YES;
        [self.view sendSubviewToBack:scheduleTypeSelectionView];
        scheduleTypeSelectionView.hidden = YES;
        for (int i = 0;i < [indexsArray count]; i++) {
            int indexValue = [[indexsArray objectAtIndex:i] intValue];
            assignmentOC = [assignmentListArray objectAtIndex: indexValue];
            [scheduleListArray addObject:assignmentOC];
        }
        [assignmentListTableView reloadData];
    }else{
        assignmentListTableView.hidden = YES;
        calendarView.hidden = YES;
        calendarView.userInteractionEnabled = YES;
        viewAsListBtn.hidden = NO;
        viewAsCalenderBtn.hidden = NO;
        viewAsCalenderBtn.userInteractionEnabled = YES;
        viewAsListBtn.userInteractionEnabled = YES;
        backBtn.userInteractionEnabled = YES;
        [self.view sendSubviewToBack:scheduleTypeSelectionView];
        scheduleTypeSelectionView.hidden = YES;
        assignmentListTableView.hidden = YES;
        [assignmentTableView reloadData];
    }
}

- (IBAction)addAssignmentBtnAction:(id)sender {
    calendarView.userInteractionEnabled = YES;
    viewAsCalenderBtn.userInteractionEnabled = YES;
    viewAsListBtn.userInteractionEnabled = YES;
    backBtn.userInteractionEnabled = YES;
    scheduleTypeSelectionView.hidden =YES;
    requestServiceViewController *requestVC = [[requestServiceViewController alloc] initWithNibName:@"requestServiceViewController" bundle:nil];
    requestVC.detailrId=@"-1";
    requestVC.dateStr=buttonDateStr;
    requestVC.userType = self.triggerValue;
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)viewCloseBtnAction:(id)sender {
    calendarView.userInteractionEnabled = YES;
    viewAsListBtn.userInteractionEnabled = YES;
    viewAsCalenderBtn.userInteractionEnabled = YES;
    backBtn.userInteractionEnabled = YES;
    scheduleTypeSelectionView.hidden = YES;
}
- (void)dayButtonPressed:(DayButton *)button
{
    indexsArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    for (int i = 0; i < [assignmentListArray count]; i++) {
        assignmentOC = [assignmentListArray objectAtIndex:i];
        NSInteger Aindex = 0;
       
        NSString *timeFrom = [NSString stringWithFormat:@"%@",assignmentOC.time];
        NSArray* dateFromArray = [timeFrom componentsSeparatedByString: @" "];
        NSString *selectedDateStr = [NSString stringWithFormat:@"%@",[dateFromArray objectAtIndex:0]];
        
        
        if ([selectedDateStr isEqualToString:buttonDateStr]) {
            Aindex = i;
            NSString *indexStr = [NSString stringWithFormat:@"%d",i];
            [indexsArray addObject:indexStr];
            NSLog(@"Got the date");
//            assignmentOC = [assignmentListArray objectAtIndex:Aindex];
//            reciveRequestdetailViewController *reciveRequestVc=[[reciveRequestdetailViewController alloc]initWithNibName:@"reciveRequestdetailViewController" bundle:nil];
//            reciveRequestVc.assignmentOC = assignmentOC;
//            if([_triggerValue isEqualToString:@"detailer"])
//            {
//                reciveRequestVc.distassign =@"detailer";
//                if([_timing isEqualToString:@"upcoming"])
//                {
//                    reciveRequestVc.arrivalbtn = @"yes";
//                }
//            }
//            if([_serviceHistoryUserBlock isEqualToString:@"BlockBtn"])
//            {
//                reciveRequestVc.BlockBtn = @"BlockBtn";
//                reciveRequestVc.custid = assignmentOC.customer_id;
//            }
//            NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
//            if ([role isEqualToString:@"customer"])
//            {     reciveRequestVc.custView = @"Yes"; }
//            reciveRequestVc.from_assignment = @"Yes";
//            [self.navigationController pushViewController:reciveRequestVc animated:YES];
            
        }
        }
    buttonDateStr = [dateFormatter stringFromDate:button.buttonDate];
    selectionViewBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
    selectionViewBgLbl.layer.borderWidth = 1.5;
    selectionViewBgLbl.layer.cornerRadius = 5.0;
    [selectionViewBgLbl setClipsToBounds:YES];
    calendarView.userInteractionEnabled = NO;
    viewAsListBtn.userInteractionEnabled = NO;
    viewAsCalenderBtn.userInteractionEnabled = NO;
    backBtn.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:scheduleTypeSelectionView];
    scheduleTypeSelectionView.hidden = NO;
    
}
- (IBAction)deleteBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Are you sure you want to delete this location?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
    alert.tag=7;
    [alert show];
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == assignmentTableView) {
        assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
    }else{
        assignmentOC = [scheduleListArray objectAtIndex:indexPath.row];
    }
    
    UITableViewRowAction *deleteAction;
    if (![assignmentOC.isSelfAssigned isEqualToString:@"true"]) {
//    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"More" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        // maybe show an action sheet with more options
//        
//    }];
//    moreAction.backgroundColor = [UIColor lightGrayColor];
//    
//    UITableViewRowAction *blurAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Blur" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        
//    }];
//    blurAction.backgroundEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
//    
    deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //[self.mySongsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self removeAssignmentList:assignmentOC.requestId :assignmentOC.detailer_ID];
    
    }];
        
    return @[deleteAction];
    }else{
        deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            //[self.mySongsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
        }];
        deleteAction.backgroundColor = [UIColor grayColor];
        return @[deleteAction];
    }
    return nil;
}
-(void) removeAssignmentList: (NSString *)service_id: (NSString *)detailerId
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    webservice = 5;
    _postData = [NSString stringWithFormat:@"service_id=%@&detailerId=%@",service_id,detailerId];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/remove-assignment.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    //customer and upcoming
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
-(void) deleteItems: (NSString *)trackCode: (NSString *)localUrl
{
   
  
    
}
// From Master/Detail Xcode template
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
@end
