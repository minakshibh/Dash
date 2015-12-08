//
//  MyprofileViewController.m
//  dash
//
//  Created by Br@R on 08/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "MyprofileViewController.h"
#import "registerViewController.h"
#import "customerProfileViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "TLTagsControl.h"
@interface MyprofileViewController ()
@property (nonatomic, strong) IBOutlet TLTagsControl *defaultEditingTagControl;

@end

@implementation MyprofileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    profileImg.layer.borderWidth = 1.5;
    profileImg.layer.cornerRadius = 10.0;
    [profileImg setClipsToBounds:YES];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchProfileInfoFromDatabase];
    [self showSkills];
}
-(void)showSkills
{
   
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
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
        nameLbl.text =[results stringForColumn:@"name"];
        emailLbl.text =[NSString stringWithFormat:@"%@",[results stringForColumn:@"email"]];
        contactLbl.text =[NSString stringWithFormat:@"%@",[results stringForColumn:@"contact"]];
        NSString*imgUrl=[results stringForColumn:@"image"];
        creditCardLbl.text=[NSString stringWithFormat:@"%@",[results stringForColumn:@"creditCardNumber"]];
        
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                profileImg.image = [UIImage imageWithData:imageData];
            });
        });
    }
    [database close];
}

- (IBAction)profileImageEditBttn:(id)sender
{
    customerProfileViewController *vehiclelistVC = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
    vehiclelistVC.registrationType = @"customer";
    vehiclelistVC.backBtnHiden=@"NO";
    
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
 }

- (IBAction)profileEditBttn:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
    registerVC.trigger=@"edit";
    registerVC.creditcard = @"card";
    
    for (int i=0; i<skill_arr.count; i++) {
        if ([[skill_arr objectAtIndex:i] isKindOfClass:[NSNull class]])
        {
           
           
            skill_arr = [[NSArray alloc]init];
        }
    }

    registerVC.skil = skill_arr;
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)BackBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showSkills];

    
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
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
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
            NSDictionary *dict = [userDetailDict valueForKey:@"skill"];
            skill_arr = [dict valueForKey:@"vehicleDesc"];
            
            for (int i=0; i<skill_arr.count; i++) {
                if ([[skill_arr objectAtIndex:i] isKindOfClass:[NSNull class]])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DASH" message:@"Skill array contain null values" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
            

            lblskills.text = [skill_arr componentsJoinedByString:@", "];
           
        }
    }
}
@end
