//
//  confirmServiceViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "updateRequest.h"

@interface confirmServiceViewController : UIViewController
{
    
    IBOutlet UIImageView *beforeImage;
    IBOutlet UIImageView *afterImage;
    NSMutableData*webData;
    NSDictionary *data;
    NSString* ifaccepted;
    updateRequest *updateRequestObj;
    int webservice;
    
}
@property NSString *pref;
- (IBAction)btnConfirmServices:(id)sender;
-(void)recivedResponce;

@end
