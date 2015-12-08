//
//  RegisterationRoleViewController.m
//  dash
//
//  Created by Br@R on 29/04/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "RegisterationRoleViewController.h"
#import "registerViewController.h"
#import "loginViewController.h"

@interface RegisterationRoleViewController ()

@end

@implementation RegisterationRoleViewController
@synthesize backBtnHidden;


- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"view" ] isEqualToString:@"verifyView"])
    {
        headrView.hidden=NO;
    }
    
    if (backBtnHidden)
    {
        headrView.hidden=NO;
    }
    

    regAsCustomerBttn.layer.borderColor = [UIColor grayColor].CGColor;
    regAsCustomerBttn.layer.borderWidth = 1.0;
    regAsCustomerBttn.layer.cornerRadius = 4.0;
    [regAsCustomerBttn setClipsToBounds:YES];
    
    regAsDetailerBttn.layer.borderColor = [UIColor grayColor].CGColor;
    regAsDetailerBttn.layer.borderWidth = 1.0;
    regAsDetailerBttn.layer.cornerRadius = 4.0;
    [regAsDetailerBttn setClipsToBounds:YES];
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Login Here"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    [loginHereBtn setAttributedTitle:commentString forState:UIControlStateNormal];
    
    [loginHereBtn setTintColor:[UIColor colorWithRed:224.0f/255.0f green:15.0f/255.0f blue:70.0f/255.0f alpha:1.0f ]] ;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)LoginBtn:(id)sender {
    loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    
//    if (backBtnHidden)
//    {
//        loginVC.backBtnHidden=YES;
//    }

    [self.navigationController pushViewController:loginVC animated:NO];
}

- (IBAction)RegisterAsDetailer:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
    registerVC.role=@"detailer";
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)RegisterAsCustomer:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
    registerVC.role=@"customer";
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end






