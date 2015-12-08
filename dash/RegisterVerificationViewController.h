//
//  RegisterVerificationViewController.h
//  dash
//
//  Created by Br@R on 29/04/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>



@interface RegisterVerificationViewController : UIViewController
{
    NSMutableData*webData;
    int webservice;

    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    IBOutlet UILabel *backViewLbl;
    IBOutlet UITextField *verifyCodetxt;
    IBOutlet UIButton *registrAgainBttn;
    IBOutlet UIButton *verifyBttn;
    IBOutlet UIButton *resendBttn;
    IBOutlet UIScrollView *backScrollView;
    IBOutlet UIImageView *logoImg;
}
- (IBAction)verificationBttn:(id)sender;
- (IBAction)registerBttn:(id)sender;
- (IBAction)resendBttn:(id)sender;
@end
