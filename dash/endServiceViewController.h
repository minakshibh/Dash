//
//  endServiceViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/25/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "updateRequest.h"
@interface endServiceViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSData* endServiceImage;
    IBOutlet UIImageView *uploadImage;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIButton *goOnlineBtn;
    IBOutlet UIButton *uploadBtnOutlet;
    IBOutlet UIButton *endServiceBtn;
    updateRequest * updateRequestObj;
    IBOutlet UIImageView *firstImage;
    IBOutlet UIButton *btnmenu;
    IBOutlet UIImageView *menuicon;
    int webservice;
}
@property NSString* reqid,*pref;
- (IBAction)uploadImageBtnAction:(id)sender;
- (IBAction)endServiceBtnAction:(id)sender;
- (IBAction)myWorkSamples:(id)sender;
@property (strong , nonatomic) NSString *registrationType;
- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
@property NSData *startServiceImage;
-(void)recivedResponce;
@end
