//
//  registerViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "registerViewController.h"
#import "loginViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "RegisterVerificationViewController.h"
#import "creditcardViewController.h"
#import "TagSampleViewController.h"
@interface registerViewController ()
@property (nonatomic, strong) IBOutlet TLTagsControl *defaultEditingTagControl;
@end

@implementation registerViewController
@synthesize role,trigger;
NSArray *skills,*skill_desc;
NSMutableArray *tags;
int i;
- (void)viewDidLoad {
    i=0;
    skillstableview.delegate = self;
    skillstableview.dataSource = self;
    _defaultEditingTagControl.hidden=YES;
    
    tags = [[NSMutableArray alloc]init];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    skills = [[NSArray alloc]init];
    skill_desc = [[NSArray alloc]init];
    skills = [user valueForKey:@"get_available_skills_id"];
    skill_desc = [user valueForKey:@"get_available_skills_vehicleDesc"];
    
    registerScroller.scrollEnabled = YES;
    registerScroller.delegate = self;
    registerScroller.contentSize = CGSizeMake(200, 460);
    registerScroller.backgroundColor=[UIColor clearColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [super viewDidLoad];
    skillstableview.hidden = YES;
    skillsdropdownbutton.hidden= YES;
    lblskillline.hidden=YES;
    imageIconSkill.hidden = YES;
    
    
    if([role isEqualToString:@"detailer"] || [trigger isEqualToString:@"edit"])
    {
        imageIconSkill.hidden = NO;

        lblskill.text = @"Skills";
        if ([trigger isEqualToString:@"edit"]) {
            
            lblskill.hidden = YES;
            
            for (int i =0; i<_skil.count; i++) {
                [tags addObject:[_skil objectAtIndex:i]];
            }
            _defaultEditingTagControl.hidden=NO;
        _defaultEditingTagControl.tags = [tags mutableCopy];
        
        //_defaultEditingTagControl.mode = TLTagsControlModeList ;
        
        
        [_defaultEditingTagControl reloadTagSubviews];
        
        }
        
        
        
      
        
        
        skillsdropdownbutton.hidden=NO;
        lblskillline.hidden = NO;
        //[skillsdropdownbutton setTitle:@"Add Skills" forState:UIControlStateNormal];
          CGRect frame = registerBttn.frame;
        float y_axis_reg_btn = frame.origin.y;
        frame.origin.y = y_axis_reg_btn +60;
         registerBttn.frame = frame;
        
        CGRect frame1 = loginHereBttn.frame;
        float y_axis_loginHere_btn = frame1.origin.y;
        frame1.origin.y = y_axis_loginHere_btn +60;
        loginHereBttn.frame = frame1;

        CGRect frame2 = alreadyAccountBtn.frame;
        float y_axis_alreadyAccount_lbl = frame2.origin.y;
        frame2.origin.y = y_axis_alreadyAccount_lbl +60;
        alreadyAccountBtn.frame = frame2;
        
        CGRect newFrame3 = backgroundlbl.frame;
        float height_axis_background_lbl = newFrame3.size.height;
                newFrame3.size.height = height_axis_background_lbl +55;
                backgroundlbl.frame = newFrame3;
    }
//    if ([_creditcard isEqualToString:@"card"]) {
//        CGRect frame = registerBttn.frame;
//        frame.origin.y = 435;
//        registerBttn.frame = frame;
//        
//        
//        CGRect newFrame = backgroundlbl.frame;
//        newFrame.size.height = 330;
//        backgroundlbl.frame = newFrame;
//        
//        creaditcard.hidden = YES;
//        lblcard.hidden = NO;
//        lbl1.hidden = NO;
//        lbl2.hidden=NO;
//        cardImage.hidden = NO;
//        cardEdit.hidden=NO;
//    }else{
        creaditcard.hidden = YES;
        cardEdit.hidden = YES;
        lblcard.hidden = YES;
        cardImage.hidden = YES;
        lbl1.hidden = YES;
        lbl2.hidden=YES;
//  }
    
    
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:singleTap];
    
    registerBttn.layer.borderColor = [UIColor grayColor].CGColor;
    registerBttn.layer.borderWidth = 1.0;
    registerBttn.layer.cornerRadius = 4.0;
    [registerBttn setClipsToBounds:YES];
    
//    skillsdropdownbutton.layer.borderColor = [UIColor grayColor].CGColor;
//    skillsdropdownbutton.layer.borderWidth = 1.0;
//    skillsdropdownbutton.layer.cornerRadius = 4.0;
//    [skillsdropdownbutton setClipsToBounds:YES];
    
    registerBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
    registerBgLbl.layer.borderWidth = 1.0;
    registerBgLbl.layer.cornerRadius = 4.0;
    [registerBgLbl setClipsToBounds:YES];
    
    if ([trigger isEqualToString:@"edit"])
    {
        backBttn.hidden=NO;
        [self fetchProfileInfoFromDatabase];
        [registerBttn setTitle:@"UPDATE" forState:UIControlStateNormal];
        alreadyAccountBtn.hidden=YES;
        loginHereBttn.hidden=YES;
        lineLbl.hidden=YES;
    }
    
    if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"view" ] isEqualToString:@"verifyView"])
    {
        backBttn.hidden=NO;
    }
    
   NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Login Here"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    [loginHereBttn setAttributedTitle:commentString forState:UIControlStateNormal];
    
    [loginHereBttn setTintColor:[UIColor colorWithRed:224.0f/255.0f green:15.0f/255.0f blue:70.0f/255.0f alpha:1.0f ]] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapDetected{
    [registerScroller setContentOffset:CGPointMake(0, 0) animated:YES];

    [self.view endEditing:YES];
}
- (IBAction)skillsdropdownbutton:(id)sender {
    
    
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Select Skills" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    for(NSString* number in skill_desc)
        [view addButtonWithTitle:number];
    view.tag = 6;
    [view show];
    
    
    
    
//    
//    skillstableview.hidden = NO;
//    [skillstableview setUserInteractionEnabled:YES];
//    [self.view bringSubviewToFront:skillstableview];
//    skillstableview.layer.borderColor = [UIColor grayColor].CGColor;
//    skillstableview.layer.borderWidth = 1.0;
//    skillstableview.layer.cornerRadius = 4.0;
//    [skillstableview setClipsToBounds:YES];
//    [skillstableview bringSubviewToFront:_defaultEditingTagControl];
//    [self.view bringSubviewToFront:skillstableview];
}

- (IBAction)cardEdit:(id)sender {
    creditcardViewController *obj = [[creditcardViewController alloc]init];
    obj.trigger = @"edit";
    
    [self presentViewController:obj animated:YES completion:nil];
}

- (IBAction)registerBtnAction:(id)sender
{
    
    if([role isEqualToString:@"detailer"] || [trigger isEqualToString:@"edit"])
    {
    //---get tag arry and compare and check it with orignal
    if(tags.count == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DASH" message:@"Atlest select one skill" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSMutableArray *id_array = [[NSMutableArray alloc]init];
    for (int k=0; k<tags.count; k++) {
        NSInteger anIndex=[skill_desc indexOfObject:[tags objectAtIndex:k]];
        anIndex = anIndex+1;
        [id_array addObject:[NSString stringWithFormat:@"%ld",(long)anIndex]];
    }
    NSMutableArray *abc = [[NSMutableArray alloc]init];
    for(int d=0;d<id_array.count;d++)
    {
        NSString *anc = [id_array objectAtIndex:d];
       [abc addObject:[skills objectAtIndex:[anc integerValue]-1]];
    }
    joinedString = [abc componentsJoinedByString:@","];
        
        
    }
    
    
    
    [self.view endEditing:YES];
    [registerScroller setContentOffset:CGPointMake(0, 0) animated:YES];

    NSString* nameStr = [nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* emailAddressStr = [emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* passwordStr = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* confrmPassStr = [confirmPasswordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* phoneNumStr = [phoneNumberTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    
    
    
    
     if (nameStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
     else if (emailAddressStr.length==0)
     {
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Email Address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
         return;
     }
    
   else  if (![self validateEmailWithString:emailAddressStr]==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Check Your Email Address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [emailTxt becomeFirstResponder];
        return;
    }
   else if (phoneNumStr.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Phone Number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
       return;
   }
    

   else if (passwordStr.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
       return;
   }
   else if (confrmPassStr.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter password to confirm." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
       return;
   }
    
    
    else if (![passwordStr isEqualToString:confrmPassStr])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Password donot match." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [passwordTxt becomeFirstResponder];
        return;
        
    }
    [self UserRegistration:nameStr Emailid:emailAddressStr Password:passwordStr Contactnum:phoneNumStr];
}


-(void)UserRegistration:(NSString*)name Emailid:(NSString*)emailid Password:(NSString *)password Contactnum:(NSString *)contactnum
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    if ([trigger isEqualToString:@"edit"])
    {
        webservice=2;
        _postData = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&phone=%@&img=&user_id=%@&skills=%@",name,emailid,password,contactnum,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],joinedString];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/edit-profile.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    else{
        webservice=1;
        _postData = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&phone=%@&role=%@&skills=%@",name,emailid,password,contactnum,role,joinedString];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/register.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    
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
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if(result==0)
        {
            if (webservice==1)
            {
              
                NSString*userId=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"user_id"]];
                [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userid"];
                
                NSString *verificationCode = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"verification_code"]];
                verificationCode121 = [userDetailDict valueForKey:@"verification_code"];
                
                NSString *messageStr = [NSString stringWithFormat:@"Thank you for registering with us. A verification code has been sent to you via email. Please check."];
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=2;
                [alert show];
                
            }
            else if (webservice==2)
            {
              
                [self FetchBasicProfile];
            }
            else if (webservice==3)
            {
                [kappDelegate HideIndicator];
                
                NSString*userName=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"name"]];
                [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
                
                [self saveDataTodtaaBase:userDetailDict];
                
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your Profile updated Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=3;
                [alert show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 2){
        RegisterVerificationViewController *registrVerifyVc=[[RegisterVerificationViewController alloc]initWithNibName:@"RegisterVerificationViewController" bundle:nil];
        NSString *abc = [NSString stringWithFormat:@"Your Verification Code is"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:abc message:verificationCode121 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self.navigationController pushViewController:registrVerifyVc animated:YES];
        
    }else if (alertView.tag == 6)
    {   lblskill.hidden = YES;
        if (buttonIndex==0) {
            if(tags.count==0)
            {lblskill.hidden = NO;}
            return;
        }
        NSString *dupliacate = [NSString stringWithFormat:@"%@",[skill_desc objectAtIndex:buttonIndex-1]];
        for (int j=0; j<tags.count; j++) {
            NSString *compare = [NSString stringWithFormat:@"%@",[tags objectAtIndex:j]];
            if([compare isEqualToString:dupliacate])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DASH" message:@"Skill already added" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                skillstableview.hidden = YES;
                return;
            }
        }
        
        
        
        
        skillstableview.hidden = YES;
        [tags addObject:[skill_desc objectAtIndex:buttonIndex-1]];
        _defaultEditingTagControl.hidden=NO;
        _defaultEditingTagControl.tags = [tags mutableCopy];
        [_defaultEditingTagControl reloadTagSubviews];

    }
}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginHereBtnAction:(id)sender {
    loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [registerScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = registerScroller.contentOffset;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        if ( textField == emailTxt|| textField == passwordTxt || textField == phoneNumberTxt || textField == confirmPasswordTxt) {
            
            CGPoint pt;
            CGRect rc = [textField bounds];
            rc = [textField convertRect:rc toView:registerScroller];
            pt = rc.origin;
            pt.x = 0;
            pt.y -=98;
            [registerScroller setContentOffset:pt animated:YES];
        }

    }
    else
    if (textField == emailTxt|| textField == passwordTxt || textField == phoneNumberTxt || textField == confirmPasswordTxt) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:registerScroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y -=130;
        [registerScroller setContentOffset:pt animated:YES];
    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void) fetchProfileInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM userProfile where userId=\"%@\" ",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        nameTxt.text =[results stringForColumn:@"name"];
        emailTxt.text =[results stringForColumn:@"email"];
        passwordTxt.text =[results stringForColumn:@"password"];
        confirmPasswordTxt.text =[results stringForColumn:@"password"];
        phoneNumberTxt.text =[results stringForColumn:@"contact"];
        imageUrlStr=[results stringForColumn:@"image"];
        creditCardNumbrStr=[results stringForColumn:@"creditCardNumber"];
        creaditcard.text = [results stringForColumn:@"creditCardNumber"];
        lblcard.text = [results stringForColumn:@"creditCardNumber"];
    }
    [database close];
}

-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    
    NSString* updateSQL = [NSString stringWithFormat:@"UPDATE userProfile SET  name = \"%@\", email = \"%@\", password =\"%@\", role = \"%@\" ,contact = \"%@\" ,image =\"%@\", creditCardNumber = \"%@\"  where userId = %@" ,[userDetailDict valueForKey:@"name"],[userDetailDict valueForKey:@"email"],[userDetailDict valueForKey:@"password"],[userDetailDict valueForKey:@"role"],[userDetailDict valueForKey:@"contact_info"],[userDetailDict valueForKey:@"imageUrl"],[userDetailDict valueForKey:@"CreditCardNumber"],userId ];

    [database executeUpdate:updateSQL];
    
    [database close];
}



-(void) FetchBasicProfile
{
    webservice=3;
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]];
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return skills.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.textLabel.text = [skill_desc objectAtIndex:indexPath.row];
    cell.userInteractionEnabled = YES;
    [skillstableview bringSubviewToFront:_defaultEditingTagControl];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //  NSString *skill_name = [NSString stringWithFormat:@"%@",[skill_desc objectAtIndex:indexPath.row]];
  //  [skillsdropdownbutton setTitle:skill_name forState:UIControlStateNormal];
    
    
    NSString *dupliacate = [NSString stringWithFormat:@"%@",[skill_desc objectAtIndex:indexPath.row]];
    for (int j=0; j<tags.count; j++) {
        NSString *compare = [NSString stringWithFormat:@"%@",[tags objectAtIndex:j]];
        if([compare isEqualToString:dupliacate])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DASH" message:@"Skill already added" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            skillstableview.hidden = YES;
            return;
        }
    }
    
    
    
    
    skillstableview.hidden = YES;
    [tags addObject:[skill_desc objectAtIndex:indexPath.row]];
    _defaultEditingTagControl.hidden=NO;
     _defaultEditingTagControl.tags = [tags mutableCopy];
    [_defaultEditingTagControl reloadTagSubviews];
    
    
    
    //----shift buttons
    if (i==0) {
        
    
    CGRect frame = registerBttn.frame;
    float y_axis_reg_btn = frame.origin.y;
    frame.origin.y = y_axis_reg_btn +20;
    registerBttn.frame = frame;
    
    CGRect frame1 = loginHereBttn.frame;
    float y_axis_loginHere_btn = frame1.origin.y;
    frame1.origin.y = y_axis_loginHere_btn +20;
    loginHereBttn.frame = frame1;
    
    CGRect frame2 = alreadyAccountBtn.frame;
    float y_axis_alreadyAccount_lbl = frame2.origin.y;
    frame2.origin.y = y_axis_alreadyAccount_lbl +20;
    alreadyAccountBtn.frame = frame2;
    
    CGRect newFrame3 = backgroundlbl.frame;
    float height_axis_background_lbl = newFrame3.size.height;
    newFrame3.size.height = height_axis_background_lbl +25;
    backgroundlbl.frame = newFrame3;
    
    CGRect newFrame4 = skillstableview.frame;
    float y_axis_skillstableview_lbl = newFrame4.origin.y;
    newFrame4.origin.y = y_axis_skillstableview_lbl +25;
    skillstableview.frame = newFrame4;
        
        i++;
    }
}
#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}
- (void)deleteTagButton:(NSString*)abc
{
   // NSInteger index = [tagSubviews_ indexOfObject:view];
    NSInteger myInt = [abc intValue];
    [tags removeObjectAtIndex:myInt];
    if(tags.count ==0)
    {
        lblskill.hidden = NO;
        lblskill.text = @"Skills";
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
       
   [_defaultEditingTagControl resignFirstResponder];
}
@end
