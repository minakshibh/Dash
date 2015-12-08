//
//  RegisterationRoleViewController.h
//  dash
//
//  Created by Br@R on 29/04/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterationRoleViewController : UIViewController
{
    
    IBOutlet UIButton *regAsCustomerBttn;
    IBOutlet UIButton *regAsDetailerBttn;
    IBOutlet UIImageView *orImage;
    IBOutlet UIImageView *logoImg;
    IBOutlet UIButton *loginHereBtn;
    IBOutlet UIView *headrView;
}
- (IBAction)LoginBtn:(id)sender;
- (IBAction)RegisterAsDetailer:(id)sender;
- (IBAction)RegisterAsCustomer:(id)sender;
- (IBAction)backBttn:(id)sender;

@property (nonatomic, assign) BOOL backBtnHidden;


@end
