//
//  creditcardViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "creditcardViewController.h"
#import "addLocationViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "registerViewController.h"

@interface creditcardViewController ()

@end

@implementation creditcardViewController
@synthesize headerLblStr;

- (void)viewDidLoad {
    
    if ([_trigger isEqualToString:@"edit"]) {
        [nextBttn setTitle:@"Update" forState:UIControlStateNormal];
        stepsmageView.hidden=YES;
        btnback.hidden = NO;
        skipStepBttn.hidden = YES;
    }else{
        btnback.hidden = YES;
    }
    
    
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    headerLbl.text=headerLblStr;
   
     
    [self.view addSubview:PickerBgView];
    [self.view bringSubviewToFront:PickerBgView];
    PickerBgView.hidden=YES;
    
    monthArray=[[NSMutableArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    
    yearArray=[NSMutableArray new];
    for (int i=2015; i<=2170; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    month=[monthArray objectAtIndex:0];
    Year=[yearArray objectAtIndex:0];
    MonthYearValue=[NSString stringWithFormat:@"%@%@",month,Year];
    ModifiedMonthYear=[NSString stringWithFormat:@"%@/%@",month,[Year substringFromIndex: [Year length] - 2]];
    

    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected1)];
    singleTap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *textFieldTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldTapDetected)];
    textFieldTap.numberOfTapsRequired = 1;
    [ExpiryDateTxt setUserInteractionEnabled:YES];
    [ExpiryDateTxt addGestureRecognizer:textFieldTap];

    
    
    
    backBFlbl.layer.borderColor = [UIColor grayColor].CGColor;
    backBFlbl.layer.borderWidth = 1.0;
    backBFlbl.layer.cornerRadius = 4.0;
    [backBFlbl setClipsToBounds:YES];
    
    stepsmageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    creditHeadrLbl.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
   
    


    if ([self.registrationType isEqualToString:@"customer"]) {
        stepsmageView.image = [UIImage imageNamed:@"4steps-2.png"];
    }else{
        stepsmageView.image = [UIImage imageNamed:@"3steps-2.png"];
        stepsmageView.frame=CGRectMake(stepsmageView.frame.origin.x+30, stepsmageView.frame.origin.y, 171, stepsmageView.frame.size.height);

    }
    nextBttn.layer.borderColor = [UIColor grayColor].CGColor;
    nextBttn.layer.borderWidth = 1.0;
    nextBttn.layer.cornerRadius = 4.0;
    [nextBttn setClipsToBounds:YES];
    // Do any additional setup after loading the view from its nib.
}

-(void)textFieldTapDetected
{
    [self.view endEditing:YES];
    [creditCardNumberTxt resignFirstResponder];
    [ccvNumberTxt resignFirstResponder];
    [ExpiryDateTxt resignFirstResponder];
    PickerBgView.hidden=NO;
}

#pragma mark - Picker View Delegate
#pragma mark -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
        return [monthArray count];
    else
        return [yearArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        return [monthArray objectAtIndex:row];
    }
    else
    {
        return [yearArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component==0)
    {
        month=[monthArray objectAtIndex:row];
        
        // MonthYearValue=[NSString stringWithFormat:@"%@ %@",month,Year];
        // ExpiryDateTextField.text=MonthYearValue;
    }
    else
    {
        Year=[yearArray objectAtIndex:row];
        
    }
    
    MonthYearValue=[NSString stringWithFormat:@"%@%@",month,Year];
    ModifiedMonthYear=[NSString stringWithFormat:@"%@%@",month,Year];
    
    ExpiryDateTxt.text=ModifiedMonthYear;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapDetected1{
    [self.view endEditing:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    PickerBgView.hidden=YES;

    if (textField .tag== 4) {
        [self tapDetected1];
//        [creditCardNumberTxt resignFirstResponder] ;
//        [ccvNumberTxt resignFirstResponder];
//        [self.view endEditing:YES];
        PickerBgView.hidden=NO;
    }
}


- (IBAction)nextBtnAction:(id)sender {
    if (creditCardNumberTxt.text.length<16)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Valid Credit Card Number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (ccvNumberTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Credit Card CVV Number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (ExpiryDateTxt.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Credit Card expiry date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        
        webservice=1;
        [kappDelegate ShowIndicator];
        NSMutableURLRequest *request ;
        
        NSString*_postData = [NSString stringWithFormat:@"creditcardNumber=%@&cvv=%@&expiryDate=%@&user_id=%@",creditCardNumberTxt.text,ccvNumberTxt.text,ExpiryDateTxt.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
        
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/validate-credit-card.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        NSLog(@"data post >>> %@",_postData);
        
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webData==nil)
            {
                webData = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webData=nil;
                webData = [NSMutableData data] ;
            }
            NSLog(@"server connection made");
        }
        else
        {
            NSLog(@"connection is NULL");
        }
    }
}

- (IBAction)skipStepBtnAction:(id)sender
{
    if ([self.registrationType isEqualToString:@"customer"]) {
        addLocationViewController *addLocationVC = [[addLocationViewController alloc] initWithNibName:@"addLocationViewController" bundle:nil];
        addLocationVC.headerLblStr=headerLbl.text;

        [self.navigationController pushViewController:addLocationVC animated:NO];
    }else{
        uploadWorkSamplesViewController *uploadWorkSamplesVC = [[uploadWorkSamplesViewController alloc] initWithNibName:@"uploadWorkSamplesViewController" bundle:nil];
        uploadWorkSamplesVC.headerLblStr=headerLbl.text;
        uploadWorkSamplesVC.trigger=@"add";
        [self.navigationController pushViewController:uploadWorkSamplesVC animated:NO];
    }
    
}

- (IBAction)doneBttn:(id)sender {
    PickerBgView.hidden=YES;
}

- (IBAction)btnback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [webData appendData:data1];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            [kappDelegate HideIndicator];
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(result==0)
        {
            if (webservice==1)
            {
                 [kappDelegate HideIndicator];
                if([_trigger isEqualToString:@"edit"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Sucessfully updated creadit card" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    registerViewController *registerVC = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
                    registerVC.trigger=@"edit";
                    registerVC.creditcard = @"card";
                    [self.navigationController pushViewController:registerVC animated:NO];
                    
                }else{
                if ([self.registrationType isEqualToString:@"customer"]) {
                    addLocationViewController *addLocationVC = [[addLocationViewController alloc] initWithNibName:@"addLocationViewController" bundle:nil];
                    addLocationVC.headerLblStr=headerLbl.text;
                    
                    [self.navigationController pushViewController:addLocationVC animated:NO];
                }else{
                    uploadWorkSamplesViewController *uploadWorkSamplesVC = [[uploadWorkSamplesViewController alloc] initWithNibName:@"uploadWorkSamplesViewController" bundle:nil];
                    uploadWorkSamplesVC.headerLblStr=headerLbl.text;
                    uploadWorkSamplesVC.trigger=@"add";
                    
                    [self.navigationController pushViewController:uploadWorkSamplesVC animated:NO];
                
                }
                }
            }
        }
    }
}





- (IBAction)expiryDateBttn:(id)sender {
    [self tapDetected1];
    //        [creditCardNumberTxt resignFirstResponder] ;
    //        [ccvNumberTxt resignFirstResponder];
    //        [self.view endEditing:YES];
    PickerBgView.hidden=NO;
}
@end
