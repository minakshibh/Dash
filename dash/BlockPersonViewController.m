//
//  BlockPersonViewController.m
//  dash
//
//  Created by Krishna Mac Mini 2 on 15/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "BlockPersonViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "workSampleTableViewCell.h"
#import "AsyncImageView.h"


@interface BlockPersonViewController ()
{
     assignmentObj *assignmentOC;
}
@end

@implementation BlockPersonViewController
NSString *ifaccepted;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isBlocked = true;
    [self showData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showData
{
    webservice =1;
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@",_user_id];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    ifaccepted =@"Responce get";
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        
        if ([messageStr isEqualToString:@"Success"]) {
            
            if (webservice ==1) {
           
            
            NSArray *data1 = [[NSArray alloc]init];
            data1 = [userDetailDict valueForKey:@"request_data"];
            
            lblphoneno.text = [userDetailDict valueForKey:@"contact_info"];
            lblName.text = [userDetailDict valueForKey:@"name"];
            lblEmail.text = [userDetailDict valueForKey:@"email"];
            
            
            NSMutableArray *arr = [userDetailDict valueForKey:@"work_sample"];
            assignmentListArray = [[NSMutableArray alloc] init];
            
                NSString *imagestr = [userDetailDict valueForKey:@"imageUrl"];
            if([imagestr isKindOfClass:[NSNull class]])
                {
                    imagestr = @" ";
                }
               
                
            NSURL *imageURL = [NSURL URLWithString:imagestr];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            imageView.image = [UIImage imageWithData:imageData];
            
            
                if ([_usertype isEqualToString:@"fromDetailer"]) {
                    NSMutableArray *userVehicle = [userDetailDict valueForKey:@"vehicle_info"];
                    lblAfter.hidden=YES;
                    lblbefore.text = @"User Car Info.";
                    
                    
                    for (int j=0; j<userVehicle.count; j++) {
                        
                    
                    assignmentOC = [[assignmentObj alloc] init];
                    
                    assignmentOC.vehicleMake = [[userVehicle valueForKey:@"vehicle_make"] objectAtIndex:j];
                    assignmentOC.vehicleModal = [[userVehicle valueForKey:@"vehicle_modal"] objectAtIndex:j];
                    assignmentOC.vehicleNo = [[userVehicle valueForKey:@"vehicle_no"] objectAtIndex:j];
                    assignmentOC.image = [[userVehicle valueForKey:@"vehicle_imageUrl"] objectAtIndex:j];
                        [assignmentListArray addObject:assignmentOC];
                    }
                    
                }else{
            
            for (int i = 0; i < [arr count]; i++)
            {
                assignmentOC = [[assignmentObj alloc] init];
                assignmentOC.after_img_url = [[arr valueForKey:@"afterImageUrl"] objectAtIndex:i];
                assignmentOC.bfr_img_url = [[arr valueForKey:@"beforeImageUrl"] objectAtIndex:i];
                assignmentOC.vehicleMake = [[arr valueForKey:@"makeAndModelDetails"] objectAtIndex:i];
                [assignmentListArray addObject:assignmentOC];
            }
                    }
            [tableView reloadData];
            
            }  //----webservice1----
            
            if (webservice ==2) {
                NSLog(@"block/unblock button pressed");
            }
        }
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [assignmentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    workSampleTableViewCell *cell = (workSampleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"workSampleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
     if ([_usertype isEqualToString:@"fromDetailer"])
     {
         assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
         NSString *detail = [[NSString alloc]initWithFormat:@"%@ %@ %@",assignmentOC.vehicleMake,assignmentOC.vehicleModal, assignmentOC.vehicleNo];
         UILabel *showdetail;
         if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
         {
             showdetail = [[UILabel alloc] initWithFrame:CGRectMake(210, 15, 250, 50)];
         }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
         {
             showdetail = [[UILabel alloc] initWithFrame:CGRectMake(183, 12, 220, 50)];
         }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
         {
             showdetail = [[UILabel alloc] initWithFrame:CGRectMake(168,12, 220, 50)];
         }
         showdetail.text = detail;
         [cell.contentView addSubview:showdetail];
         
         AsyncImageView *beforetemImage = [[AsyncImageView alloc] init];
         NSString *imageUrls = [NSString stringWithFormat:@"%@",assignmentOC.image];
         beforetemImage.imageURL = [NSURL URLWithString:imageUrls];
         beforetemImage.showActivityIndicator = YES;
         if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
         {
             beforetemImage.frame = CGRectMake(11 , 8, 191 , 120);
         }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
         {
             beforetemImage.frame = CGRectMake(20 , 5, 153 , 120);
         }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
         {
             beforetemImage.frame = CGRectMake(5 , 5, 153 , 120);
         }
         [cell.contentView addSubview:beforetemImage];
         
         
     }else{
    assignmentOC = [assignmentListArray objectAtIndex:indexPath.row];
    AsyncImageView *beforetemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",assignmentOC.bfr_img_url];
    NSLog(assignmentOC.bfr_img_url);
    beforetemImage.imageURL = [NSURL URLWithString:imageUrls];
    beforetemImage.showActivityIndicator = YES;
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
    {
        beforetemImage.frame = CGRectMake(11 , 8, 191 , 120);
    }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
    {
        beforetemImage.frame = CGRectMake(20 , 5, 153 , 120);
    }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
    {
        beforetemImage.frame = CGRectMake(5 , 5, 153 , 120);
    }
    [cell.contentView addSubview:beforetemImage];
    
    AsyncImageView *afterItemImage = [[AsyncImageView alloc] init];
    NSString *afterimageUrls = [NSString stringWithFormat:@"%@",  assignmentOC.after_img_url];
    afterItemImage.imageURL = [NSURL URLWithString:afterimageUrls];
    afterItemImage.showActivityIndicator = YES;
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
    {
        afterItemImage.frame = CGRectMake(215 , 8, 191 , 120);
    }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
    {
        afterItemImage.frame = CGRectMake(205 , 5, 153 , 120);
    }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
    {
        afterItemImage.frame = CGRectMake(163 , 5, 153 , 120);
    }
    //afterItemImage.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:afterItemImage];
    
     } //---end else---
    return cell;
}


- (IBAction)btnUnblock:(id)sender {
    
    if (isBlocked)
    {
        [btnUnblock setTitle:@"Block" forState:UIControlStateNormal];
        isBlocked=false;
    }
    else{
        
        [btnUnblock setTitle:@"Un-Block" forState:UIControlStateNormal];
        isBlocked=true;
    }
    
    if(isBlocked)
    {
        BlockStr = @"true";
    }else{
        BlockStr = @"false";
    }
    
    webservice = 3;
    
    NSString*_postData = [NSString stringWithFormat:@"userId=%@&isBlocked=%@&blocked_id=%@&last_updated=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],BlockStr,_user_id,@""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/block-detailer.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
