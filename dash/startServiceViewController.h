//
//  startServiceViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "updateRequest.h"
@interface startServiceViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UIImageView *uploadImage;
    NSData* imagedata;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIView *tapToAcceptView;
    IBOutlet UIView *userRequestView;
    IBOutlet UIButton *goOnlineBtn;
    updateRequest *updateRequestObj;
    IBOutlet UIButton *btnmenu;
    IBOutlet UIImageView *menuIcon;
}
@property NSString* reqid;
@property NSData *startPic1;
- (IBAction)uploadImagebtnAction:(id)sender;
- (IBAction)startServiceBtnAction:(id)sender;
- (IBAction)myWorkSamples:(id)sender;
-(void)recivedResponce;
- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
@end
