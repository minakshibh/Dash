//
//  registerViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface registerViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITextField *creaditcard;
    IBOutlet UIButton *backBttn;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*imageUrlStr ,*creditCardNumbrStr;
    IBOutlet UIImageView *logoImg;

    IBOutlet UILabel *lbl2;
    IBOutlet UILabel *lbl1;
    CGPoint svos;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *phoneNumberTxt;
    IBOutlet UILabel *alreadyAccountBtn;
    IBOutlet UIButton *loginHereBttn;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UITextField *confirmPasswordTxt;
    IBOutlet UILabel *lblcard;
    IBOutlet UILabel *lineLbl;
    NSMutableData*webData;
    int webservice;

    IBOutlet UIButton *cardEdit;
    IBOutlet UILabel *registerBgLbl;
    IBOutlet UIScrollView *registerScroller;
    IBOutlet UIButton *registerBttn;
    IBOutlet UILabel *backgroundlbl;
    IBOutlet UIImageView *cardImage;
    NSString *verificationCode121,*at_index,*joinedString;
    IBOutlet UITableView *skillstableview;
    IBOutlet UIButton *skillsdropdownbutton;
    IBOutlet UILabel *lblskillline;
    IBOutlet UILabel *lblskill;
    IBOutlet UIImageView *imageIconSkill;
}
- (IBAction)skillsdropdownbutton:(id)sender;
- (IBAction)cardEdit:(id)sender;
- (IBAction)registerBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)loginHereBtnAction:(id)sender;
@property(strong,nonatomic)NSString*role,*trigger,*creditcard;
- (void)deleteTagButton:(NSString*)abc;
@property(strong,nonatomic) NSArray *skil;
@end
