//
//  WorkSamplesViewController.h
//  dash
//
//  Created by Br@R on 08/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workSampleObj.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "SWTableViewCell.h"

@interface WorkSamplesViewController : UIViewController<SWTableViewCellDelegate>
{
    NSMutableArray *afterImageArrays,* worksampleDetails;
    NSMutableData*webData;
    int webservice;
    IBOutlet UITableView *workSampleTableView;
    workSampleObj *workSampleOC;
    NSMutableArray *beforeImagesArray;
    IBOutlet UILabel *afterBtn;
    IBOutlet UILabel *beforeBtn;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UIButton *addmoreBtn;
}
- (IBAction)addBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *patternImageView;
@property (weak, nonatomic) IBOutlet UILabel *patternLabel;
@end
