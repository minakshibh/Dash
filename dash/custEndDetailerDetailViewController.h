//
//  custEndDetailerDetailViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 09/06/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface custEndDetailerDetailViewController : UIViewController
{
    IBOutlet UIImageView *beforeImage;
     NSMutableData*webData;
    NSDictionary *data;
    IBOutlet UIImageView *distImage;
    IBOutlet UILabel *lblnam;
    IBOutlet UILabel *lbladd;
    IBOutlet UILabel *lbltime;
    
    IBOutlet UIImageView *star1image;
    IBOutlet UIImageView *star2iamge;
    IBOutlet UIImageView *star3image;
    IBOutlet UIImageView *star4image;
    IBOutlet UIImageView *star5image;
    IBOutlet UILabel *specialRequirements;
}
@property NSString *pref;
- (IBAction)btnback:(id)sender;
@end
