//
//  reciveRequestdetailViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/14/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "DetailerFirastViewController.h"
#import "assignmentObj.h"
#import "updateRequest.h"
@interface reciveRequestdetailViewController : UIViewController <updateRequestStatus>
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIButton *goOnlineBtn;
    DetailerFirastViewController *detailerFirstVC;
    IBOutlet UILabel *userNameLbl;
    IBOutlet UILabel *vehicleNameLbl;
    IBOutlet UILabel *addressLbl;
    IBOutlet UILabel *stateLbl;
    IBOutlet UILabel *dateTimeLbl;
    IBOutlet UIImageView *vehicleImage;
    IBOutlet UIImageView *customerImage;
    updateRequest *updateRequestObj;
    IBOutlet UIButton *btnbeingArrival;
    IBOutlet UIButton *btnMenu;
    IBOutlet UIImageView *menuicon;
    IBOutlet UIButton *btnback;
    IBOutlet UIImageView *star1image;
    IBOutlet UIImageView *star2iamge;
    IBOutlet UIImageView *star3image;
    IBOutlet UIImageView *star4image;
    IBOutlet UIImageView *star5image;
    NSString *serviceID;
    IBOutlet UIButton *btnBlock;
    BOOL isBlocked;
    NSString *BlockStr;
    int webservice;
    IBOutlet UILabel *lblSpecialreq2;
    IBOutlet UILabel *lblSpecialreq1;
    IBOutlet UILabel *lbltimer;
    IBOutlet UILabel *lblTimer1;
    int TimerValue;
    NSTimer *DownTimer;
    int webservices;
    NSString *userRequestNow,*reqid23,*detailerID,*customerID,*id_block;
    
    IBOutlet UIButton *addToWorkSampleBttn;
    IBOutlet UIView *tapToacceptViewIphone5;
    IBOutlet UIView *tapToAcceptView;
    
}
- (IBAction)tabToAcceptBtnAction:(id)sender;
- (IBAction)btnBlock:(id)sender;
@property NSString *from_assignment,*detailerEnd_UserInfo,*timervalue,*timing,*now_later,*servicehistorypast;
- (IBAction)btnback:(id)sender;
@property (strong, nonatomic) assignmentObj *assignmentOC;
@property (strong, nonatomic) NSString *custView,*distassign,*BlockBtn,*custid,*arrivalbtn,*idrequest;
- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)myWorkSamples:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
- (IBAction)beginArrivalBtnAction:(id)sender;
-(void)recivedResponce;


- (IBAction)addToWorkSamplesBtn:(id)sender;



@end
