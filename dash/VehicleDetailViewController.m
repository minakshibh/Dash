//
//  VehicleDetailViewController.m
//  dash
//
//  Created by Br@R on 11/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "VehicleDetailViewController.h"

@interface VehicleDetailViewController ()

@end

@implementation VehicleDetailViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBttn:(id)sender {
}
@end
