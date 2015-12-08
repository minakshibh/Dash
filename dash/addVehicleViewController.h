//
//  addVehicleViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "vehiclesLIstObj.h"
#import "AFHTTPRequestOperationManager.h"
@interface addVehicleViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UILabel *lblImage;
    IBOutlet UIImageView *vehicleImage;
    IBOutlet UILabel *lbladdvehicle;
    NSData *imageData;
    IBOutlet UIButton *uploadBtn;
    IBOutlet UILabel *backBgLbl;
    NSMutableData*webData;
    int webservice;
    IBOutlet UILabel *headerLbl;
    IBOutlet UIImageView *stepsImage;
    CGPoint svos;
    NSString *vehicleID,*userID,*color,*vehicleNO,*make,*modal,*imageUrl,*trigger,*RclImageBase64;
    IBOutlet UIButton *backBttn;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSData* imagedata;
    IBOutlet UIButton *skipThisStepBtn;
    IBOutlet UITextField *vehicleImageTxt;
    IBOutlet UITextField *colorTxt;
    IBOutlet UITextField *vehicleNumberTxt;
    IBOutlet UITextField *vehicleMakeTxt;
    IBOutlet UITextField *vehicleModalTxt;
    IBOutlet UIScrollView *addVehicleScroller;
    IBOutlet UIButton *addBtn;
    NSMutableArray* vehicleListArray;
}
@property (strong , nonatomic) NSString*headerLblStr ;

@property (strong, nonatomic) NSString *addVehicleDataType ,*triggerValue;
@property (strong, nonatomic) vehiclesLIstObj*vehicleListOC;
- (IBAction)uploadVehicleImageBtnAction:(id)sender;
- (IBAction)addBtnAction:(id)sender;
- (IBAction)skipStepBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;

@end
