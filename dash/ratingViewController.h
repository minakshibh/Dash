//
//  ratingViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface ratingViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

{
    IBOutlet UILabel *placeholder;
    IBOutlet UIScrollView *scrollview;
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIButton *goOnlineBtn;
    IBOutlet UITextView *reviewsTxtView;
    IBOutlet UILabel *reviewPlaceholderlbl;
    IBOutlet UIImageView *userImageView;
    int webservice;
    NSData *data;
    NSString *sender1,*reciever1,*getrequestID;
    NSString* ratingValue;
    IBOutlet UIButton *star1;
    IBOutlet UIButton *star2;
    IBOutlet UIButton *star3;
    IBOutlet UIButton *star4;
    IBOutlet UIButton *star5;
    IBOutlet UILabel *lblRatingName;
    
    
}
@property NSString *req,*status;

- (IBAction)star1:(id)sender;
- (IBAction)star2:(id)sender;
- (IBAction)star3:(id)sender;
- (IBAction)star4:(id)sender;
- (IBAction)star5:(id)sender;
- (IBAction)submitRatingBtnAction:(id)sender;
- (IBAction)myWorkSamples:(id)sender;
@property (strong , nonatomic) NSString *registrationType;
- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
@property NSData *data;
-(void)submitRating;
@end
