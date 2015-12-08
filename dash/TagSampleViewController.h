//
//  TagSampleViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 04/08/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
@interface TagSampleViewController : UIViewController<TLTagsControlDelegate>
{
    IBOutlet UITextField *txtfield;
    TLTagsControl *demoTagsControl;
    IBOutlet UIScrollView *defaultEditingTagControl1;
    NSMutableData *webData;
    IBOutlet UITextField *txtemail;
    IBOutlet UIButton *btnBack;
}
- (IBAction)btnSubmit:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *defaultEditingTagControl1;
- (IBAction)btnGo:(id)sender;
- (IBAction)btnBack:(id)sender;


@end
