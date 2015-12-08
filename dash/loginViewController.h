//
//  loginViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/25/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface loginViewController : UIViewController
{
    CGPoint svos;
    NSMutableData*webData;
    int webservice;
    
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    IBOutlet UIView *headerView;
    IBOutlet UIButton *forgtPasswrdBttn;
    IBOutlet UIImageView *logoImg;
    
    IBOutlet UILabel *alreadyHaveAccount;
    IBOutlet UILabel *loginBGLbl;
    IBOutlet UITextField *emailAddressTxt;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UIScrollView *loginScroller;
    IBOutlet UIButton *loginBttn;
    IBOutlet UIButton *regHereBttn;
    
}
@property (nonatomic, assign) BOOL backBtnHidden;
@property (nonatomic, strong) NSString* callerView;
@property (nonatomic, strong) NSString* detailerId;
@property (nonatomic, strong) NSArray* detailerArray;


- (IBAction)loginBtnAction:(id)sender;
- (IBAction)forgotPasswordAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)registerBtnAction:(id)sender;
- (IBAction)backBttn:(id)sender;
@end
