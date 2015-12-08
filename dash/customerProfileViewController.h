//
//  customerProfileViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"



@interface customerProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableData*webData;
    int webservice;
    IBOutlet UILabel *imageUploadBG;
    IBOutlet UIButton *backBttn;
    IBOutlet UIImageView *uploadImageView;
    IBOutlet UIView *backView;
    IBOutlet UIButton *uploadBtn;
    IBOutlet UIImageView *stepsmageView;
    IBOutlet UILabel *headerLbl;
    IBOutlet UIButton *skipStepBtn;
    NSData* imagedata;

    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    NSString*nameStr,*emailStr,*contactStr,*creditCardStr,*imageStr ,*usrIdStr ,*passwrdStr;
    
    IBOutlet UIImageView *steps2;
}
@property (strong , nonatomic) NSString *registrationType ,*backBtnHiden;
- (IBAction)uploadBtnAction:(id)sender;
- (IBAction)skipStepBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)btnImage:(id)sender;
@end
