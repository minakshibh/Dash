//
//  detailerViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/22/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "detailerViewController.h"
#import "AsyncImageView.h"
#import "workSampleTableViewCell.h"
#import "customerProfileViewController.h"
#import "loginViewController.h"
#import "homeViewViewController.h"
#import "requestServiceViewController.h"

#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@interface detailerViewController ()

@end

@implementation detailerViewController
@synthesize fromView,detailrsArray;
isBlocked = false;
- (void)viewDidLoad {
    
    NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    if ([userId isKindOfClass:[NSNull class]])
    {
        userId=@"";
    }
    if( userId.length==0)
    {
        favBtn.hidden=YES;
        
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    NSLog(@"Name.... %@",self.mapDetailsOC.detailrName);
    NSLog(@"Lats.... %@",self.mapDetailsOC.latitudeStr);
    
    [self getDriverFavFromDatabase];
    
    nameLbl.text = self.mapDetailsOC.detailrName;
    
    beforeImagesArray = [[NSMutableArray alloc] init];
    afterImageArrays = [[NSMutableArray alloc] init];
    
    for (int k=0;k< self.mapDetailsOC.workSamples.count ; k++)
    {
       mapDetailsObj* detailrObj =[[mapDetailsObj alloc]init];
        detailrObj.workSampleId=[[self.mapDetailsOC.workSamples valueForKey:@"ID"] objectAtIndex:k];
        detailrObj.makeAndModelDetails=[[self.mapDetailsOC.workSamples valueForKey:@"makeAndModelDetails"] objectAtIndex:k];
        detailrObj.beforeImageUrl=[[self.mapDetailsOC.workSamples valueForKey:@"beforeImageUrl"] objectAtIndex:k];
        detailrObj.afterImageUrl=[[self.mapDetailsOC.workSamples valueForKey:@"afterImageUrl"] objectAtIndex:k];
        
        [beforeImagesArray addObject:detailrObj.beforeImageUrl];
        [afterImageArrays addObject:detailrObj.afterImageUrl];
    }

    
    AsyncImageView *itemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",self.mapDetailsOC.placeImage];
    itemImage.imageURL = [NSURL URLWithString:imageUrls];
    itemImage.showActivityIndicator = YES;
    
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 )
    {
        itemImage.frame = CGRectMake(8 , 100,130 , 130);
    }
    if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
    {
        itemImage.frame = CGRectMake(12 , 100,100 , 100);
    }
    if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
    {
        itemImage.frame = CGRectMake(8 , 80,100 , 100);
    }
    //itemImage.contentMode = UIViewContentModeScaleAspectFill;
    itemImage.userInteractionEnabled = YES;
    itemImage.multipleTouchEnabled = YES;
    itemImage.layer.borderColor = [UIColor clearColor].CGColor;
    itemImage.layer.borderWidth = 1.5;
    itemImage.layer.cornerRadius = 4.0;
    [itemImage setClipsToBounds:YES];
    [self.view addSubview:itemImage];
    int x = 0;
    int rate = [self.mapDetailsOC.placeRatingStr intValue];
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
        x = 200;
    }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 )
    {
        x = 190;
        
    }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
    {
        x = 170;
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton *rateButton;
        if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
            rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 157, 15, 15)];
        }if ([[ UIScreen mainScreen ] bounds ].size.width == 375 ){
            rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 142, 15, 15)];
        }if ([[ UIScreen mainScreen ] bounds ].size.width == 320 )
        {
            rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 120, 15, 15)];
        }
        
        if (i < rate) {
            [rateButton setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        }else{
            [rateButton setBackgroundImage:[UIImage imageNamed:@"yellow-star.png"] forState:UIControlStateNormal];
        }
        [self.view addSubview:rateButton];
        x= x+15;
    }
    worksampleDetails = [[NSMutableArray alloc] init];
    for (int i =0 ; i < [beforeImagesArray count]; i++) {
        workSampleOC = [[workSampleObj alloc]init];
        workSampleOC.beforeServiceUrl = [NSString stringWithFormat:@"%@",[beforeImagesArray objectAtIndex:i]];
        workSampleOC.afterServiceUrl = [NSString stringWithFormat:@"%@",[afterImageArrays objectAtIndex:i]];
        [worksampleDetails addObject:workSampleOC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBlock:(id)sender {
   
    if (isBlocked)
    {
        [btnBlock setTitle:@"Block" forState:UIControlStateNormal];
        isBlocked=false;
    }
    else{
       
        [btnBlock setTitle:@"Unblock" forState:UIControlStateNormal];
        isBlocked=true;
    }
    
    if(isBlocked)
    {
    BlockStr = @"true";
    }else{
    BlockStr = @"false";
    }
    
    webservice = 5;
    
    NSString*_postData = [NSString stringWithFormat:@"userId=%@&isBlocked=%@&blocked_id=%@&last_updated=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],BlockStr,self.mapDetailsOC.detailrId,@""];
    
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

- (IBAction)backAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
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
    
    workSampleTableViewCell *cell = (workSampleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"workSampleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    workSampleOC = [worksampleDetails objectAtIndex:indexPath.row];
    AsyncImageView *beforetemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",workSampleOC.beforeServiceUrl];
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
    
    //beforetemImage.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:beforetemImage];
    
    AsyncImageView *afterItemImage = [[AsyncImageView alloc] init];
    NSString *afterimageUrls = [NSString stringWithFormat:@"%@",workSampleOC.afterServiceUrl];
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
    return cell;
}

- (IBAction)requestService:(id)sender {
    
    NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    if ([userId isKindOfClass:[NSNull class]])
    {
        userId=@"";
    }
    if( userId.length==0)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please log in to continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
        return;
    }
    requestServiceViewController *requestVC = [[requestServiceViewController alloc] initWithNibName:@"requestServiceViewController" bundle:nil];
    requestVC.detailrId=self.mapDetailsOC.detailrId;
    requestVC.detailrsArray=[detailrsArray mutableCopy];
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)profileBttn:(id)sender {
    customerProfileViewController *profileVc = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
    profileVc.registrationType = @"detailer";
    [self.navigationController pushViewController:profileVc animated:NO];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
        loginVC.callerView=@"recomndedRequest";

        loginVC.backBtnHidden=YES;
        loginVC.detailerId=self.mapDetailsOC.detailrId;
        loginVC.detailerArray=[detailrsArray mutableCopy];

        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


- (IBAction)markAsFavBttn:(id)sender
{
    
    
    
    if (isFavorite)
    {   //favouriteImageView.image = [UIImage imageNamed:@"gray-star"];
        //[favBtn setTitle:@"Remove from favorite" forState:UIControlStateNormal];
        [favBtn setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
        isFavorite=NO;
    }
    else{
        //favouriteImageView.image = [UIImage imageNamed:@"yellow-star"];
        //[favBtn setTitle:@"Mark as Favorite" forState:UIControlStateNormal];
 [favBtn setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
        isFavorite=YES;
    }
    
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    webservice=1;
    
    if (isFavorite)
    {
        FavStr=@"true";
    }
    else{
        FavStr=@"false";
    }

   NSString*lastupdated= [[NSUserDefaults standardUserDefaults] valueForKey:@"fav_last_updated"];
    if ([lastupdated isKindOfClass:[NSNull class]])
    {
        lastupdated=@"";
    }
    NSString *abc = self.mapDetailsOC.detailrId;
    
    _postData = [NSString stringWithFormat:@"userId=%@&detailerId=%@&isFavorite=%@&last_updated=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],self.mapDetailsOC.detailrId,FavStr,lastupdated];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mark-detailer.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
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
            if (webservice==1)
            {
                NSString*lastUpdated=[userDetailDict valueForKey:@"last_updated_max"];
                [[NSUserDefaults standardUserDefaults] setValue:lastUpdated forKey:@"fav_last_updated"];
               
                [self saveFavDetailerToDatabase];
            }
            if(webservice == 5)
            {
                NSLog(@"responce success user bloc/unblock btn");
            }
        }
    }
}


-(void)saveFavDetailerToDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM favDetailers where userId= \"%@\"",userId];
    
    FMResultSet *queryResults = [database executeQuery:queryString];
    NSMutableArray* idsArray = [[NSMutableArray alloc]init];
    while([queryResults next]) {
        NSString*detailrId = [queryResults stringForColumn:@"detailerId"];
        [idsArray addObject:detailrId];
    }

    NSString*isFav;
    
    if (isFavorite )
    {
        isFav=@"true";
    }
    else
    {
        isFav=@"false";
    }
    
    if ([idsArray containsObject:self.mapDetailsOC.detailrId ])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE favDetailers SET IsFavorite = \"%@\" where detailerId = %@" ,isFav,self.mapDetailsOC.detailrId ];
        [database executeUpdate:updateSQL];
    }
    else
    {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO favDetailers (detailerId, IsFavorite, userId) VALUES (\"%@\", \"%@\",\"%@\")",self.mapDetailsOC.detailrId,isFav,userId];
        [database executeUpdate:insert];
    }
    
    [database close];
}

-(void)getDriverFavFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM favDetailers where userId= \"%@\" and detailerId = \"%@\"",userId,self.mapDetailsOC.detailrId];
    NSLog(self.mapDetailsOC.detailrId);
    FMResultSet *queryResults = [database executeQuery:queryString];

    while([queryResults next])
    {
        NSString*isFav = [queryResults stringForColumn:@"IsFavorite"];
        if ([isFav isEqualToString:@"true"])
        {
            isFavorite=YES;
            [favBtn setImage:[UIImage imageNamed:@"gray-star"] forState:UIControlStateNormal];
            
            //[favBtn setTitle:@"Remove from favorite" forState:UIControlStateNormal];
            //favouriteImageView.image = [UIImage imageNamed:@"yellow-star.png"];
        }else{
            isFavorite=NO;
            [favBtn setImage:[UIImage imageNamed:@"yellow-star"] forState:UIControlStateNormal];
        }
    
    }
    [database close];

}
@end
