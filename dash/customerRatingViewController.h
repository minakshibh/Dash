//
//  customerRatingViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customerRatingViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    NSMutableData*webData;
    NSDictionary *data;
    NSString* ifaccepted,*review,*cust_id,*dist_id;
    IBOutlet UILabel *placeholder;
    NSString *ratingValue;
    IBOutlet UIImageView *distimage;
    IBOutlet UITextView *txtreview;
    int webservice;
    IBOutlet UIButton *star1;
    IBOutlet UIButton *star2;
    IBOutlet UIButton *star3;
    IBOutlet UIButton *star4;
    IBOutlet UIButton *star5;
    CGPoint svos;
    IBOutlet UILabel *lblRatingName;
}
@property NSString *pref;
- (IBAction)star5:(id)sender;

- (IBAction)star4:(id)sender;
- (IBAction)star1:(id)sender;
- (IBAction)btnRating:(id)sender;
- (IBAction)star2:(id)sender;
- (IBAction)star3:(id)sender;
@end
