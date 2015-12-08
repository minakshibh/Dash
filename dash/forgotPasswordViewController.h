//
//  forgotPasswordViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgotPasswordViewController : UIViewController
{
    NSMutableData*webData;

    IBOutlet UITextField *emailTxt;
    IBOutlet UIScrollView *backScrollView;
    IBOutlet UIImageView *logoImg;
    IBOutlet UILabel *backLbl;
    IBOutlet UIButton *retreivePasswrdBttn;
    IBOutlet UILabel *headrLbl;
}
- (IBAction)retrivePasswordbtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@end
