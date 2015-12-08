//
//  detailerViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/22/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapDetailsObj.h"
#import "workSampleObj.h"

#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"


@interface detailerViewController : UIViewController
{
    IBOutlet UILabel *nameLbl;
    IBOutlet UIImageView *profileImage;
    IBOutlet UITableView *workSampleTableView;
    NSMutableArray *beforeImagesArray;
    NSMutableArray *afterImageArrays,* worksampleDetails;
    IBOutlet UIButton *favBtn;
    workSampleObj *workSampleOC;
    
    NSMutableData*webData;
    int webservice;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath,*trigger;
    FMDatabase *database;
    NSString*FavStr,*BlockStr;
    BOOL isFavorite,isBlocked;
   
    IBOutlet UIImageView *favouriteImageView;
    IBOutlet UIButton *btnBlock;
}
- (IBAction)btnBlock:(id)sender;
- (IBAction)backAction:(id)sender;
@property(strong,nonatomic)    NSString*fromView;
- (IBAction)requestService:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *favouriteImageView;

- (IBAction)profileBttn:(id)sender;
@property (strong, nonatomic) mapDetailsObj *mapDetailsOC;
@property (strong,nonatomic)NSArray*detailrsArray;
- (IBAction)markAsFavBttn:(id)sender;
@property  NSMutableArray *name5;
@end
