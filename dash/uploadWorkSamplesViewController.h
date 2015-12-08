//
//  uploadWorkSamplesViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/25/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workSampleObj.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>

#import "AFHTTPRequestOperationManager.h"


@interface uploadWorkSamplesViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSData *afterImageData, *beforeImageData;

    
    IBOutlet UITextField *enterVehicleDetailTxt;
    IBOutlet UIImageView *stepsImg;
    IBOutlet UILabel *headerLbl;
    IBOutlet UITextField *beforeCarImageTxt;
    IBOutlet UITextField *afterCarImageTxt;
    IBOutlet UILabel *backView;
    BOOL isBeforeImage;
    IBOutlet UITableView *workSampleTableView;
    IBOutlet UIView *uploadedSampleView;
    NSMutableArray *beforeImagesArray;
    NSMutableArray *afterImageArrays,* worksampleDetails;
    IBOutlet UIButton *skipStepBttn;
    IBOutlet UIButton *backbtn;
    NSMutableData*webData;
    int webservice;
    NSString*worksample_id ,*beforeImageStr,*afterImageStr;
    IBOutlet UIScrollView *backScrollView;
    IBOutlet UILabel *afterBtn;
    
    IBOutlet UILabel *beforBtn;
    IBOutlet UIButton *uploadFirstImg;
    
    IBOutlet UIButton *uploadAfterImh;
    
    IBOutlet UIButton *addVehicleBtn;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UIButton *addMoreBtn;
    IBOutlet UIButton *getStartedBtn;
}
- (IBAction)uploadBeforeImageBtnAction:(id)sender;
- (IBAction)uploadAfterImageBtnAction:(id)sender;
- (IBAction)addBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)skipStepBtnAction:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)getStartedBttn:(id)sender;


- (IBAction)addMoreSampleBttn:(id)sender;

@property (strong , nonatomic) NSString*headerLblStr,*trigger,*backBtnHiden ;
@property (strong ,nonatomic)     workSampleObj *workSampleOC;

@end
