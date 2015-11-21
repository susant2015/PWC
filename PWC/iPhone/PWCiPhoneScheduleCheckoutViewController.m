//
//  PWCiPhoneScheduleCheckoutViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleCheckoutViewController.h"
#import "PWCGlobal.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "PWCCustomers.h"
#import "PWCiPhoneScheduleCustomerDetailViewController.h"

@interface PWCiPhoneScheduleCheckoutViewController ()

@end

@implementation PWCiPhoneScheduleCheckoutViewController

@synthesize custInfo;
@synthesize prodInfo;
@synthesize cCardNumber;
@synthesize cardHolderName;
@synthesize cardExpireDate;
@synthesize cardTypeImage;
@synthesize track1value;
@synthesize track2value;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    //init alert views
    prompt_doConnection = [[UIAlertView alloc] initWithTitle:@"PWC"
                                                     message:@"Device detected in headphone jack. Try connecting it?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    
    prompt_connecting = [[UIAlertView alloc] initWithTitle:@"PWC"
                                                   message:@"Connecting with the device..."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:nil];
    
    prompt_waitingForSwipe = [[UIAlertView alloc] initWithTitle:@"Payment System Ready"
                                                        message:@"Please swipe the card now."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    
    prompt_noCardData = [[UIAlertView alloc] initWithTitle:@"PWC"
                                                   message:@"Can't read card data yet!"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Swipe again", nil];
    
    //reset ui state
    [self setConnectedLabelState:FALSE];
    
    //activate SDK
    [self umsdk_activate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //deallocate alert views
    prompt_doConnection = nil;
    prompt_connecting = nil;
    prompt_waitingForSwipe = nil;
    prompt_noCardData = nil;
    
    //deactivate SDK
    [self umsdk_deactivate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"Customer Info: %@", self.custInfo);
    NSLog(@"Product Info: %@", self.prodInfo);
    
    [self resetValues];
    [self useSwipeChanged:self];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.expireMonth || textField == self.expireYear) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
    } else if (textField == self.cardNumber) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 16) ? NO : YES;
    } else {
        return NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.cardNumber resignFirstResponder];
    [self.cardName resignFirstResponder];
    [self.expireMonth resignFirstResponder];
    [self.expireYear resignFirstResponder];
    [self.cvc resignFirstResponder];
    [self updateCardTypeImage];
}

- (void)updateCardTypeImage
{
    if (self.useSwipe.isOn) {
        // SWIPE ON
        self.cardType.image = [UIImage imageNamed:self.cardTypeImage];
    } else {
        // SWIPE OFF
        if ([self.cardNumber.text length] > 10) {
            // SET CARD TYPE IMAGE
            NSString *firstDigit = [self.cardNumber.text substringToIndex:1];
            NSLog(@"First Digit: %@", firstDigit);
            
            if ([firstDigit isEqualToString:@"3"]) {
                // AMEX
                self.cardTypeImage = @"amex";
            } else if ([firstDigit isEqualToString:@"4"]) {
                // VISA
                self.cardTypeImage = @"visa";
            } else if ([firstDigit isEqualToString:@"5"]) {
                // MasterCard
                self.cardTypeImage = @"mastercard";
            } else if ([firstDigit isEqualToString:@"6"]) {
                // Discover
                self.cardTypeImage = @"discover";
            }
            self.cardType.image = [UIImage imageNamed:self.cardTypeImage];
            
            self.chargeCard.enabled = YES;
        } else {
            // REMOVE
            self.cardTypeImage = @"";
            self.cardType.image = nil;
        }
    }
}

- (void)updateDisplay
{
    self.cardNumber.text = self.cCardNumber;
    self.cardName.text = self.cardHolderName;
    
    if ([self.cardExpireDate length] > 1) {
        self.expireMonth.text = [self.cardExpireDate substringToIndex:2];
        self.expireYear.text = [self.cardExpireDate substringFromIndex:3];
    } else {
        self.expireMonth.text = @"";
        self.expireYear.text = @"";
    }
    self.cvc.text = @"";
    
    [self updateCardTypeImage];
}

- (void)resetValues
{
    self.cCardNumber = @"";
    self.cardHolderName = @"";
    self.cardExpireDate = @"";
    self.cardTypeImage = @"";
    self.track1value = @"";
    self.track2value = @"";
    
    self.chargeCard.enabled = NO;
    
    [self updateDisplay];
}

- (void)changeTextFieldState:(UITextField *)textField enable:(BOOL)yesNo
{
    if (yesNo) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        textField.enabled = YES;
    } else {
        textField.backgroundColor = [UIColor darkGrayColor];
        textField.textColor = [UIColor lightTextColor];
        textField.enabled = NO;
    }
}

- (IBAction)useSwipeChanged:(id)sender {
    //NSLog(@"%@",self.useSwipe.state);
    if (self.useSwipe.isOn) {
        // SWIPE ON
        NSLog(@"SWIPE ON");
        [self changeTextFieldState:self.cardNumber enable:NO];
        [self changeTextFieldState:self.cardName enable:NO];
        [self changeTextFieldState:self.expireMonth enable:NO];
        [self changeTextFieldState:self.expireYear enable:NO];
        [self changeTextFieldState:self.cvc enable:NO];
        
        self.swipeButton.enabled = YES;
    } else {
        // SWIPE OFF
        NSLog(@"SWIPE OFF");
        [self changeTextFieldState:self.cardNumber enable:YES];
        [self changeTextFieldState:self.cardName enable:YES];
        [self changeTextFieldState:self.expireMonth enable:YES];
        [self changeTextFieldState:self.expireYear enable:YES];
        [self changeTextFieldState:self.cvc enable:YES];
        self.swipeButton.enabled = NO;
    }
    
    [self resetValues];
}

- (IBAction)startSwiping:(id)sender
{
    [self hideKeyboard];
    UmRet ret = [uniReader requestSwipe];
    NSLog(@"requestSwipe return code: \"%@\"", UmRet_lookup(ret));
    if ([UmRet_lookup(ret) isEqualToString:@"UMRET_NO_READER"]) {
        [SVProgressHUD dismissWithError:@"Connect Reader" afterDelay:5.0];
    }
}

- (IBAction)chargeTheCard:(id)sender {
    [self hideKeyboard];
    
    BOOL everythingOk = NO;
    
    // CHECKING
    if (self.useSwipe.isOn) {
        if (self.track1value.length > 20) {
            everythingOk = YES;
        }
    } else {
        if (self.cardNumber.text.length == 16 &&
            self.expireMonth.text.length == 2 &&
            self.expireYear.text.length == 2 &&
            self.cardName.text.length > 1 &&
            self.cvc.text.length > 2 &&
            self.cvc.text.length < 5) {
            everythingOk = YES;
        } else {
            everythingOk = NO;
        }
    }
    
    if (everythingOk) {
        [SVProgressHUD showWithStatus:@"Processing transaction ..." maskType:SVProgressHUDMaskTypeBlack];
        
        SEL backSel = @selector(doProcessTransaction);
        [self performSelectorInBackground:backSel withObject:self];
    } else {
        [SVProgressHUD dismissWithError:@"Re-check all fields." afterDelay:1.5];
    }
}

//-------START: DO PROCESS TRANSACTION --------------

- (void)doProcessTransaction
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    
    // USER INFO
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCGlobal getTheGlobal].merchantId forKey:@"merchantid"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCGlobal getTheGlobal].applicationApiKey forKey:@"apikey"]];
    
    // QUANTITY
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.prodInfo objectForKey:@"quantity"] forKey:@"quantity"]];
    
    // CUSTOMER INFORMATION
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.custInfo objectForKey:@"email"] forKey:@"customer_email"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.custInfo objectForKey:@"firstName"] forKey:@"first_name"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.custInfo objectForKey:@"lastName"] forKey:@"last_name"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.custInfo objectForKey:@"customerId"] forKey:@"customer_id"]];
    
    // CARD TYPE
    if ([self.cardTypeImage isEqualToString:@"amex"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"Amex" forKey:@"card_type"]];
    } else if ([self.cardTypeImage isEqualToString:@"visa"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"Visa" forKey:@"card_type"]];
    } else if ([self.cardTypeImage isEqualToString:@"mastercard"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"MasterCard" forKey:@"card_type"]];
    } else if ([self.cardTypeImage isEqualToString:@"discover"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"Discover" forKey:@"card_type"]];
    }
    
    if (self.useSwipe.isOn) {
        // SWIPE ON
        // CARD INFO
        NSArray *details = [self.track1value componentsSeparatedByString:@"^"];
        
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[[details objectAtIndex:0] substringFromIndex:2] forKey:@"card_number"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[details objectAtIndex:1] forKey:@"card_holder_name"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[[[details objectAtIndex:2] substringToIndex:4] substringFromIndex:2] forKey:@"card_expire_month"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"20%@",[[details objectAtIndex:2] substringToIndex:2]] forKey:@"card_expire_year"]];
        
        // CARD TRACK DATA
        if ([self.track2value length] < 16) {
            self.track2value = [NSString stringWithFormat:@"%@=%@",[[details objectAtIndex:0] substringFromIndex:2], [details objectAtIndex:2]];
        }
        
        NSString *trackData = [NSString stringWithFormat:@"%@;%@", self.track1value, self.track2value];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:trackData forKey:@"card_track_data"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.track1value forKey:@"card_track_data1"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.track2value forKey:@"card_track_data2"]];
        
        // CVV
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"" forKey:@"card_cvv"]];
    } else {
        // SWIPE OFF
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.cardNumber.text forKey:@"card_number"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.cardName.text forKey:@"card_holder_name"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.expireMonth.text forKey:@"card_expire_month"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"20%@", self.expireYear.text] forKey:@"card_expire_year"]];
        
        // CARD TRACK DATA
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"" forKey:@"card_track_data"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"" forKey:@"card_track_data1"]];
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"" forKey:@"card_track_data2"]];
        
        // CVV
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.cvc.text forKey:@"card_cvv"]];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/addCreditFromiPhoneApp.html"];
    //NSString *path = [NSString stringWithFormat:@"/api/swipeSale.html"];
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:parDic];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int result = [[JSON objectForKey:@"result"] intValue];
                                                                                            //NSLog(@"Result: %d", result);
                                                                                            [SVProgressHUD dismiss];
                                                                                            //NSLog(@"Dissmiss");
                                                                                            
                                                                                            if (result == 1) {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    [self createActionSheet:@"Success"];
                                                                                                });
                                                                                            } else {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    [self createActionSheet:@"Failure"];
                                                                                                });
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            //NSLog(@"Request: %@", JSON);
                                                                                            //NSLog(@"Error: %@", error);
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self createActionSheet:@"Failure"];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

//-------END: DO PROCESS TRANSACTION --------------


- (void)createActionSheet:(NSString *)status
{
    if ([status isEqualToString:@"Success"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Thank you! Your order has been successfully completed."
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [actionSheet showInView:super.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This order has been declined by the Credit Card Gateway, please double check the information submitted."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Use New Card"
                                                   destructiveButtonTitle:@"Leave It"
                                                        otherButtonTitles:@"Resubmit", nil];
        [actionSheet showInView:super.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        // USE NEW CARD
        [self resetValues];
        
    } else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // DASHBOARD
        
        if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
            //NSLog(@"Failed to open db - Checkout");
        } else {
            //NSLog(@"DB openned. - Checkout");
        }
        
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        
        SEL updateCustomerSel = @selector(updateCustomerInformation);
        [self performSelectorInBackground:updateCustomerSel withObject:self];

    } else {
        // RESUBMIT
        [self chargeTheCard:self];
    }
}

//---------- START UPDATE THE CUSTOMER

- (void)updateCustomerInformation
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/singleCustomer/%@/%@", [PWCGlobal getTheGlobal].coachRowId, [self.custInfo objectForKey:@"customerId"]];
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *customerArray = [JSON objectForKey:@"customers"];
                                                                                                [self updateCustomerData:customerArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                            NSArray *vc = [self.navigationController viewControllers];
                                                                                            PWCiPhoneScheduleCustomerDetailViewController *vcn = [vc objectAtIndex:([vc count]-3)];
                                                                                            
                                                                                            NSMutableArray *keysArray = [[NSMutableArray alloc] init];
                                                                                            NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
                                                                                            for (NSDictionary *d in [PWCGlobal getTheGlobal].customers) {
                                                                                                [keysArray addObjectsFromArray:[d allKeys]];
                                                                                                [valuesArray addObjectsFromArray:[d allValues]];
                                                                                            }
                                                                                            
                                                                                            int index = [keysArray indexOfObject:[[[self.custInfo objectForKey:@"firstName"] substringToIndex:1] uppercaseString]];
                                                                                            //NSLog(@"%@", valuesArray);
                                                                                            
                                                                                            for (NSDictionary *d in [valuesArray objectAtIndex:index]) {
                                                                                                NSLog(@"%@", d);
                                                                                                if ([[d objectForKey:@"customerId"] isEqualToString:[self.custInfo objectForKey:@"customerId"]]) {
                                                                                                    // MATCHED
                                                                                                    vcn.custInfo = d;
                                                                                                    NSLog(@"UPDATED CUST INFO");
                                                                                                    break;
                                                                                                }
                                                                                            }

                                                                                            [self.navigationController popToViewController:[vc objectAtIndex:([vc count]-3)] animated:YES];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                     
                                                                                            NSArray *vc = [self.navigationController viewControllers];
                                                                                            
                                                                                            
                                                                                            [self.navigationController popToViewController:[vc objectAtIndex:([vc count]-3)] animated:YES];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)updateCustomerData:(NSArray *)customers
{
    NSDictionary *d = [customers objectAtIndex:0];
    if ([self updateCustomer:d]) {
        NSLog(@"Customer Updated!");
    } else {
        NSLog(@"Not updated!");
    }
}

- (BOOL)updateCustomer:(NSDictionary *)customer
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE customers SET balance = '%@' WHERE customerId = '%@'",
                           [customer objectForKey:@"balance"],
                           [customer objectForKey:@"customer_id"]];
    
    const char *update_stmt = [updateSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, update_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}

//---------- END UPDATE CUSTOMER

- (void)alertView:(const UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (alertView == prompt_doConnection)
    {
        //selected option to start the connection task at the reader attachment prompt
        if (1 == buttonIndex) {
            [uniReader startUniMag:TRUE];
            //self.swipeButton.enabled = YES;
        }
    }
    else if (alertView == prompt_connecting)
    {
        //selected cancel connection at the connecting prompt.
        // This aborts the connect task
        if (0 == buttonIndex)
            [uniReader cancelTask];
    }
    else if (alertView == prompt_waitingForSwipe)
    {
        //selected cancel swipe at the swipe waiting prompt.
        // This aborts the swipe task
        if (0 == buttonIndex)
            [uniReader cancelTask];
    }
    else if (alertView == prompt_noCardData)
    {
        if (1 == buttonIndex) {
            [self startSwiping:self];
        }
    }
    
}

//-----------------------------------------------------------------------------
#pragma mark - uniMag SDK activation/deactivation -
//-----------------------------------------------------------------------------

-(void) umsdk_registerObservers:(BOOL) reg {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //list of notifications and their corresponding selector
    const struct {__unsafe_unretained NSString *n; SEL s;} noteAndSel[] = {
        //
        {uniMagAttachmentNotification       , @selector(umDevice_attachment:)},
        {uniMagDetachmentNotification       , @selector(umDevice_detachment:)},
        //
        {uniMagInsufficientPowerNotification, @selector(umConnection_lowVolume:)},
        {uniMagPoweringNotification         , @selector(umConnection_starting:)},
        {uniMagTimeoutNotification          , @selector(umConnection_timeout:)},
        {uniMagDidConnectNotification       , @selector(umConnection_connected:)},
        {uniMagDidDisconnectNotification    , @selector(umConnection_disconnected:)},
        //
        {uniMagSwipeNotification            , @selector(umSwipe_starting:)},
        {uniMagTimeoutSwipeNotification     , @selector(umSwipe_timeout:)},
        {uniMagDataProcessingNotification   , @selector(umDataProcessing:)},
        {uniMagInvalidSwipeNotification     , @selector(umSwipe_invalid:)},
        {uniMagDidReceiveDataNotification   , @selector(umSwipe_receivedSwipe:)},
        //
        {uniMagSystemMessageNotification    , @selector(umSystemMessage:)},
        
        {nil, nil},
    };
    
    //register or unregister
    for (int i=0; noteAndSel[i].s != nil ;i++) {
        if (reg)
            [nc addObserver:self selector:noteAndSel[i].s name:noteAndSel[i].n object:nil];
        else
            [nc removeObserver:self name:noteAndSel[i].n object:nil];
    }
}

-(void) umsdk_activate {
    
    //register observers for all uniMag notifications
	[self umsdk_registerObservers:TRUE];
    
    
	//enable info level NSLogs inside SDK
    // Here we turn on before initializing SDK object so the act of initializing is logged
    [uniMag enableLogging:TRUE];
    
    //initialize the SDK by creating a uniMag class object
    uniReader = [[uniMag alloc] init];
    
    /*
     //set SDK to perform the connect task automatically when headset is attached
     [uniReader setAutoConnect:TRUE];
     */
    
    //set swipe timeout to infinite. By default, swipe task will timeout after 20 seconds
	[uniReader setSwipeTimeoutDuration:0];
    
    //make SDK maximize the volume automatically during connection
    [uniReader setAutoAdjustVolume:TRUE];
    
    //By default, the diagnostic wave file logged by the SDK is stored under the temp directory
    // Here it is set to be under the Documents folder in the app sandbox so the log can be accessed
    // through iTunes file sharing. See UIFileSharingEnabled in iOS doc.
    [uniReader setWavePath: [NSHomeDirectory() stringByAppendingPathComponent: @"/Documents/audio.caf"]];
}

-(void) umsdk_deactivate {
    //it is the responsibility of SDK client to unregister itself as notification observer
    [self umsdk_registerObservers:FALSE];
}

#pragma mark attachment

//called when uniMag is physically attached
- (void)umDevice_attachment:(NSNotification *)notification {
    [self dismissAllAlertViews];
	//self.connectedImage.image = [UIImage imageNamed:@"green"];
    [prompt_doConnection show];
}

//called when uniMag is physically detached
- (void)umDevice_detachment:(NSNotification *)notification {
    [self dismissAllAlertViews];
    //self.connectedImage.image = [UIImage imageNamed:@"red"];
}

#pragma mark connection task

//called when attempting to start the connection task but iDevice's headphone playback volume is too low
- (void)umConnection_lowVolume:(NSNotification *)notification {
    [self dismissAllAlertViews];
    
    UIAlertView *volumeBad = [[UIAlertView alloc]
                              initWithTitle:@"uniMag"
                              message:@"Volume too low. Please maximize volume then re-attach uniMag."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [volumeBad show];
}

//called when successfully starting the connection task
- (void)umConnection_starting:(NSNotification *)notification {
	[prompt_connecting show];
}

//called when SDK failed to handshake with reader in time. ie, the connection task has timed out
- (void)umConnection_timeout:(NSNotification *)notification {
    [self dismissAllAlertViews];
	
	UIAlertView *connectionFailed = [[UIAlertView alloc]
                                     initWithTitle:@"uniMag"
                                     message:@"Connecting with uniMag timed out. Please try again."
                                     delegate:self
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil];
	[connectionFailed show];
}

//called when the connection task is successful, SDK's connection state changes to true
- (void)umConnection_connected:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    [self setConnectedLabelState:TRUE];
}

//called when SDK's connection state changes to false. This happens when reader becomes
// physically detached or when a disconnect API is called
- (void)umConnection_disconnected:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    [self setConnectedLabelState:FALSE];
}

#pragma mark Swipe Task

//called when the swipe task is successfullystarting, meaning the SDK starts to
// wait for a swipe to be made
- (void)umSwipe_starting:(NSNotification *)notification
{
    [prompt_waitingForSwipe show];
}

// "swipe timeout interval".
- (void)umSwipe_timeout:(NSNotification *)notification {
    [self dismissAllAlertViews];
	
	UIAlertView *swipeTimeout = [[UIAlertView alloc]
                                 initWithTitle:@"uniMag"
                                 message:@"Waiting for swipe timed out. Please try again."
                                 delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
	[swipeTimeout show];
}

//called when the SDK has read something from the uniMag device
// (eg a swipe, a response to a command) and is in the process of decoding it
// Use this to provide an early feedback on the UI
- (void)umDataProcessing:(NSNotification *)notification {
}

//called when SDK failed to read a valid card swipe
- (void)umSwipe_invalid:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    
    UIAlertView *invalidSwipe = [[UIAlertView alloc] initWithTitle:@"uniMag"
                                                           message:@"Failed to read a valid Swipe. Please try again."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [invalidSwipe show];
}

//called when SDK received a swipe successfully
- (void)umSwipe_receivedSwipe:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    
    NSData *data = [notification object];
    [self processCardData:data];
}

#pragma mark - other ui chores -

- (void)dismissAllAlertViews
{
    [prompt_doConnection dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_connecting dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_waitingForSwipe dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_noCardData dismissWithClickedButtonIndex:-1 animated:FALSE];
}

- (void)setConnectedLabelState:(BOOL)isConnected
{
    if (self.useSwipe.isOn) {
        if (isConnected) {
            self.swipeButton.enabled = YES;
        } else {
            self.swipeButton.enabled = NO;
        }
    } else {
        self.swipeButton.enabled = NO;
    }
}

- (void)processCardData:(NSData *)theData
{
    NSString *data = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    
    if ([data length] < 20) {
        NSLog(@"No card data");
        [prompt_noCardData show];
    } else {
        NSArray *tracks = [data componentsSeparatedByString:@";"];
        self.track1value = [tracks objectAtIndex:0];
        self.track2value = [tracks objectAtIndex:1];
    
        NSLog(@"Track 1 Value: %@", self.track1value);
        NSArray *details = [data componentsSeparatedByString:@"^"];
        NSLog(@"Card info: %@", data);
    
        if ([self.track2value length] < 16) {
            self.track2value = [NSString stringWithFormat:@"%@=%@",[[details objectAtIndex:0] substringFromIndex:2], [details objectAtIndex:2]];
        }
    
        if ([details count] > 2) {
            NSString *cardNo = [[details objectAtIndex:0] substringFromIndex:2];
            NSString *name = [details objectAtIndex:1];
            NSString *expiry = [[details objectAtIndex:2] substringToIndex:4];
            NSLog(@"Card No = %@", cardNo);
            NSLog(@"Name = %@", name);
            NSLog(@"Expiry = %@", expiry);
        
            self.cCardNumber = [self formatCardNumber:cardNo];
            self.cardHolderName = name;
            self.cardExpireDate = [self formatExpiryDate:expiry];
        
            NSString *firstDigit = [cardNo substringToIndex:1];
            NSLog(@"First Digit: %@", firstDigit);
        
            if ([firstDigit isEqualToString:@"3"]) {
                // AMEX
                self.cardTypeImage = @"amex";
            } else if ([firstDigit isEqualToString:@"4"]) {
                // VISA
                self.cardTypeImage = @"visa";
            } else if ([firstDigit isEqualToString:@"5"]) {
                // MasterCard
                self.cardTypeImage = @"mastercard";
            } else if ([firstDigit isEqualToString:@"6"]) {
                // Discover
                self.cardTypeImage = @"discover";
            }
            NSLog(@"imageName: %@", self.cardTypeImage);
            [self updateDisplay];
            self.chargeCard.enabled = YES;
        } else {
            NSLog(@"No card data");
            [prompt_noCardData show];
        }
    }
}

- (NSString *)formatCardNumber:(NSString *)creditCardNumber
{
    NSString *str = [NSString stringWithFormat:@"************%@", [creditCardNumber substringFromIndex:12]];
    NSLog(@"Formatted Card No: %@", str);
    return str;
}

- (NSString *)formatExpiryDate:(NSString *)expiry
{
    NSArray *arr = [[NSArray alloc] initWithObjects:[expiry substringToIndex:2], [expiry substringFromIndex:2], nil];
    NSString *str = [NSString stringWithFormat:@"%@/%@", [arr objectAtIndex:1], [arr objectAtIndex:0]];
    NSLog(@"Formatted date: %@", str);
    return str;
}


@end
