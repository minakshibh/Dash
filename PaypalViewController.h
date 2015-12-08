//
//  PaypalViewController.h
//  dash
//
//  Created by Krishna Mac Mini 2 on 28/07/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface PaypalViewController : UIViewController<PayPalPaymentDelegate>
{
    
}
- (IBAction)btnPayment:(id)sender;

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end
