//
//  assignmentsViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 6/4/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "assignmentObj.h"
#import "DDCalendarView.h"
#import "mapDetailsObj.h"
@interface assignmentsViewController : UIViewController<DDCalendarViewDelegate>
{
    NSString *buttonDateStr;
    NSMutableData*webData;
    NSMutableArray *assignmentListArray,*indexsArray, *scheduleListArray;
    assignmentObj *assignmentOC;
    IBOutlet UITableView *assignmentTableView;
    IBOutlet UILabel *titleLbl;
    int webservice;
    NSMutableArray *blockUserinfo;
    IBOutlet UIButton *viewAsCalenderBtn;
    IBOutlet UIButton *viewAsListBtn;
    DDCalendarView *calendarView;
    IBOutlet UIView *scheduleTypeSelectionView;
    IBOutlet UIButton *backBtn;
    IBOutlet UITableView *assignmentListTableView;
    bool isEdit;
    NSCalendar *calendar;
    mapDetailsObj *mapDetailsOC;
    __weak IBOutlet UILabel *selectionViewBgLbl;
}
- (IBAction)viewAsListBtnAction:(id)sender;
- (IBAction)viewAsCalenderBtnAction:(id)sender;
- (IBAction)editScheduleBtnAction:(id)sender;
- (IBAction)viewScheduleBtnAction:(id)sender;
- (IBAction)addAssignmentBtnAction:(id)sender;
- (IBAction)viewCloseBtnAction:(id)sender;

@property (strong, nonatomic) NSString *triggerValue, *timing,*detail,*presentuserid,*serviceHistoryUserBlock,*recommend_Detailers,*from_reciveRequest;
- (IBAction)backBtnAction:(id)sender;
@end
