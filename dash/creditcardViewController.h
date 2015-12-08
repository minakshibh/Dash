//
//  creditcardViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface creditcardViewController : UIViewController
{
    IBOutlet UIButton *btnback;
    IBOutlet UITextField *creditCardNumberTxt;
    IBOutlet UILabel *creditHeadrLbl;
    IBOutlet UITextField *ccvNumberTxt;
    IBOutlet UIImageView *stepsmageView;
    NSMutableData*webData;
    int webservice;
    IBOutlet UILabel *dashHeadrLbl;
    IBOutlet UIScrollView *backScrollView;
    IBOutlet UILabel *backBFlbl;
    IBOutlet UITextField *ExpiryDateTxt;
    IBOutlet UIButton *nextBttn;
    IBOutlet UIButton *skipStepBttn;
    IBOutlet UILabel *headerLbl;
    IBOutlet UIView *PickerBgView;
    IBOutlet UIPickerView *PickerView;
    
    NSMutableArray *monthArray;
    NSMutableArray *yearArray;
    NSString *MonthYearValue;
    
    NSString *month;
    NSString *Year;
    NSString*ModifiedMonthYear;
}
- (IBAction)nextBtnAction:(id)sender;
- (IBAction)skipStepBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneBttn:(id)sender;

- (IBAction)btnback:(id)sender;

- (IBAction)cancelBtn:(id)sender;
- (IBAction)expiryDateBttn:(id)sender;


@property (strong , nonatomic) NSString *registrationType ,*headerLblStr ,*trigger;
@end
