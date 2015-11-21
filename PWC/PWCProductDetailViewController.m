//
//  PWCProductDetailViewController.m
//  PWC
//
//  Created by JianJinHu on 8/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PWCAppDelegate.h"
#import "PWCGlobal.h"
#import "ASIHTTPRequest.h"
#import "PWCCRMGlobal.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "DataManager.h"

@interface PWCProductDetailViewController ()

@end

@implementation PWCProductDetailViewController
@synthesize m_strSelectedValue;
@synthesize m_strSelectedQBProduct;
@synthesize m_dicContent;
@synthesize m_bEditFlag;

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) initMember
{
    m_rectAddButton = m_btnAdd.frame;
    m_rectCustomView = m_viewCustomRate.frame;
    
    //Category.
    m_arrProductCategory = [[NSMutableArray alloc] init];
    
    //QuickBooks Product
    m_arrQuickBooks = [[NSMutableArray alloc] init];
    [m_arrQuickBooks addObject: @"Sales Tax Item, COMPTAX"];
    [m_arrQuickBooks addObject: @"Discount Itemm, DISC"];
    [m_arrQuickBooks addObject: @"Group Item(groups several inv), GRP"];
    [m_arrQuickBooks addObject: @"Inventory Part Item, INVENTORY"];
    [m_arrQuickBooks addObject: @"Other Charge Item, OTHC"];
    [m_arrQuickBooks addObject: @"Non-inventory Part Item, PART"];
    [m_arrQuickBooks addObject: @"Payment Item, PMT"];
    [m_arrQuickBooks addObject: @"Service Item, SERV"];
    [m_arrQuickBooks addObject: @"Sales Tax Group Item, STAX"];
    [m_arrQuickBooks addObject: @"Subtotal Item, SUBT"];
    
    //Charge Sale.
    m_arrChargeSale = [[NSMutableArray alloc] init];
    [m_arrChargeSale addObject: @"No"];
    [m_arrChargeSale addObject: @"Yes"];
    [m_arrChargeSale addObject: @"Yes-Custom Rate"];
    m_lblChargeSales.text = [m_arrChargeSale objectAtIndex: 0];
    m_viewCustomRate.hidden = YES;
    m_btnAdd.frame = CGRectMake(m_rectAddButton.origin.x, m_rectCustomView.origin.y, m_rectAddButton.size.width, m_rectAddButton.size.height);

    [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, 1150)];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(hideKeyboard)];
    [gesture setNumberOfTapsRequired: 1];
    [m_scrollView addGestureRecognizer: gesture];
    
    m_bAcceptFlag = NO;
    m_bFreeFlag = NO;
    m_bPortalFlag = NO;
    m_bStoreFlag = NO;
    
    if(self.m_bEditFlag)
    {
        NSLog(@"m_dic = %@", self.m_dicContent);
        m_txtProductName.text = [self.m_dicContent objectForKey: @"name"];
        m_txtProductCode.text = [self.m_dicContent objectForKey: @"product_code"];
        m_lblQuickBooks.text = [self.m_dicContent objectForKey: @"qb_product_type"];
        m_txtProductDescription.text = [self.m_dicContent objectForKey: @"short_desc"];
        m_txtLongDescription.text = [self.m_dicContent objectForKey: @"long_desc"];
        m_bStoreFlag = [[self.m_dicContent objectForKey: @"is_store_product"] boolValue];
        m_bPortalFlag = [[self.m_dicContent objectForKey: @"is_portal_product"] boolValue];
        m_txtStandard.text = [self.m_dicContent objectForKey: @"price"];
        m_txtPrivate.text = [self.m_dicContent objectForKey: @"product_price_private"];
        m_txtWholesale.text = [self.m_dicContent objectForKey: @"product_price_wholeseller"];
        m_txtDistributor.text = [self.m_dicContent objectForKey: @"product_price_distributor"];
        m_bFreeFlag = [[self.m_dicContent objectForKey: @"is_free"] boolValue];
        m_bAcceptFlag = [[self.m_dicContent objectForKey: @"is_payable_later"] boolValue];
        m_nChargeSalesTax = [[self.m_dicContent objectForKey: @"enable_sales_price"] intValue];
        m_txtStateTaxRate.text = [self.m_dicContent objectForKey: @"state_tax_rate"];
        m_txtCountryTaxRate.text = [self.m_dicContent objectForKey: @"country_tax_rate"];
        
    }
    else
    {
        
    }
    
    NSArray* arrCategory = [[DataManager sharedScoreManager] getAllProductCategory];
    if(arrCategory == nil || [arrCategory count] <= 0)
    {
        [self getCategoryList];
    }
    else
    {
        [m_arrProductCategory removeAllObjects];
        for(int i = 0; i < [arrCategory count]; i++)
        {
            NSDictionary* dicRecord = [arrCategory objectAtIndex: i];
            [m_arrProductCategory addObject: dicRecord];
        }
    }
    
    [self updateCheckButtons];
}

//==============================================================================================================
-(IBAction) getCategoryList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@getAccess/%@/categorylist/%@", SERVER_PRODUCT_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"category list = %@", strURL);
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSURL *url = [NSURL URLWithString: strURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

//==============================================================================================================
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
    // Use when fetching text data
    NSString* strResponse = [request responseString];
    NSDictionary* dic = [strResponse JSONValue];
    
    NSLog(@"Category list = %@", dic);
    
    [m_arrProductCategory removeAllObjects];
    [[DataManager sharedScoreManager] deleteAllProductCategory];
    
    NSArray* arrCategory = [dic objectForKey: @"categorylist"];
    for (int i = 0; i < [arrCategory count]; i++)
    {
        NSDictionary* dicRecord = [arrCategory objectAtIndex: i];
        
        NSString* name = [dicRecord objectForKey: @"name"];
        NSString* value = [dicRecord objectForKey: @"value"];
        
        [[DataManager sharedScoreManager] insertProductCategory: name value: value];
        [m_arrProductCategory addObject: dicRecord];
    }
    
    [m_picker reloadAllComponents];
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
}

//=================================================================================================================================
-(void) updateCheckButtons
{
    if(m_bStoreFlag)
    {
        [m_imgStoresProduct setImage: [UIImage imageNamed: @"btn_check.png"]];
    }
    else
    {
        [m_imgStoresProduct setImage: [UIImage imageNamed: @"btn_uncheck.png"]];
    }
    
    if(m_bPortalFlag)
    {
        [m_imgPortalProduct setImage: [UIImage imageNamed: @"btn_check.png"]];
    }
    else
    {
        [m_imgPortalProduct setImage: [UIImage imageNamed: @"btn_uncheck.png"]];
    }
    
    if(m_bFreeFlag)
    {
        [m_imgFreeProduct setImage: [UIImage imageNamed: @"btn_check.png"]];
    }
    else
    {
        [m_imgFreeProduct setImage: [UIImage imageNamed: @"btn_uncheck.png"]];
    }

    if(m_bAcceptFlag)
    {
        [m_imgAcceptPayLater setImage: [UIImage imageNamed: @"btn_check.png"]];
    }
    else
    {
        [m_imgAcceptPayLater setImage: [UIImage imageNamed: @"btn_uncheck.png"]];
    }
    
    if(m_nChargeSalesTax == 1)
    {
        m_viewCustomRate.hidden = NO;
        m_btnAdd.frame = m_rectAddButton;
    }
    else
    {
        m_viewCustomRate.hidden = YES;
        m_btnAdd.frame = CGRectMake(m_rectAddButton.origin.x, m_rectCustomView.origin.y, m_rectAddButton.size.width, m_rectAddButton.size.height);
    }
}

#pragma mark -
#pragma mark Picker Delegate.

//=================================================================================================================================
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//=================================================================================================================================
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(m_nPickerType == 0)
    {
        return [m_arrProductCategory count];
    }
    else if(m_nPickerType == 1)
    {
        return [m_arrQuickBooks count];
    }
    else if(m_nPickerType == 2)
    {
        return [m_arrChargeSale count];
    }
    
    return 0;
}

//=================================================================================================================================
- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont: [UIFont boldSystemFontOfSize: 20]];
    
    NSString* str;
    if(m_nPickerType == 0)
    {
        NSDictionary* dicRecord = [m_arrProductCategory objectAtIndex: row];
        str = [dicRecord objectForKey: @"name"];
    }
    else if(m_nPickerType == 1)
    {
        NSString* strRecord = [m_arrQuickBooks objectAtIndex: row];
        NSArray* arrTemp = [strRecord componentsSeparatedByString: @", "];
        str = [arrTemp objectAtIndex: 0];
    }
    else if(m_nPickerType == 2)
    {
        str = [m_arrChargeSale objectAtIndex: row];
    }
    
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;;
    return label;
}

//=================================================================================================================================
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* str;
    if(m_nPickerType == 0)
    {
        NSDictionary* dicRecord = [m_arrProductCategory objectAtIndex: row];
        str = [dicRecord objectForKey: @"name"];
    }
    else if(m_nPickerType == 1)
    {
        NSString* strRecord = [m_arrQuickBooks objectAtIndex: row];
        NSArray* arrTemp = [strRecord componentsSeparatedByString: @", "];
        str = [arrTemp objectAtIndex: 0];
    }
    else if(m_nPickerType == 2)
    {
        str = [m_arrChargeSale objectAtIndex: row];
    }
    return str;
}

//=================================================================================================================================
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(m_nPickerType == 0)
    {
        NSDictionary* dicRecord = [m_arrProductCategory objectAtIndex: row];
        NSString* str = [dicRecord objectForKey: @"name"];
        self.m_strSelectedValue = [dicRecord objectForKey: @"value"];
        m_lblCategory.text = str;
    }
    else if(m_nPickerType == 1)
    {
        NSString* str = [m_arrQuickBooks objectAtIndex: row];
        NSArray* arr = [str componentsSeparatedByString: @", "];
        self.m_strSelectedQBProduct = [arr objectAtIndex: 1];
        m_lblQuickBooks.text = str;
    }
    else if(m_nPickerType == 2)
    {
        NSString* str = [m_arrChargeSale objectAtIndex: row];
        m_lblChargeSales.text = str;
        
        if(row == 2)
        {
            m_nChargeSalesTax = 1;
            m_viewCustomRate.hidden = NO;
            m_btnAdd.frame = m_rectAddButton;
        }
        else
        {
            m_nChargeSalesTax = 0;
            m_viewCustomRate.hidden = YES;
            m_btnAdd.frame = CGRectMake(m_rectAddButton.origin.x, m_rectCustomView.origin.y, m_rectAddButton.size.width, m_rectAddButton.size.height);
        }
    }
}

#pragma mark -
#pragma mark TextField Delegate.

//===============================================================================================================================
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//===============================================================================================================================
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_fScrollHeight = m_scrollView.contentSize.height;
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 50);
    [m_scrollView setContentOffset:CGPointMake(0, 50 * textField.tag) animated: YES];
}

//===============================================================================================================================
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return  TRUE;
}

//===============================================================================================================================
-(void) hideKeyboard
{
    [m_txtCountryTaxRate resignFirstResponder];
    [m_txtDistributor resignFirstResponder];
    [m_txtLongDescription resignFirstResponder];
    [m_txtPrivate resignFirstResponder];
    [m_txtProductCode resignFirstResponder];
    [m_txtProductDescription resignFirstResponder];
    [m_txtProductName resignFirstResponder];
    [m_txtStandard resignFirstResponder];
    [m_txtStateTaxRate resignFirstResponder];
    [m_txtWholesale resignFirstResponder];
}

//===============================================================================================================================
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
}


#pragma mark - 
#pragma mark UITextField Delegate.

//==============================================================================================================
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    m_fScrollHeight = m_scrollView.contentSize.height;
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 50);
    [m_scrollView setContentOffset:CGPointMake(0, 50 * textView.tag) animated: YES];
}

//==============================================================================================================
-(void)textViewDidEndEditing:(UITextView *)textView
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionCategory:(id)sender
{
    [self hideKeyboard];
    m_nPickerType = 0;
    m_viewInput.hidden = NO;
    [m_picker reloadAllComponents];
}

//==============================================================================================================
-(IBAction) actionQuickBook:(id)sender
{
    [self hideKeyboard];
    m_nPickerType = 1;
    m_viewInput.hidden = NO;
    [m_picker reloadAllComponents];    
}

//==============================================================================================================
-(IBAction) actionCharge:(id)sender
{
    [self hideKeyboard];    
    m_nPickerType = 2;
    m_viewInput.hidden = NO;
    [m_picker reloadAllComponents];
}

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    m_viewInput.hidden = YES;
}

//==============================================================================================================
-(IBAction) actionCheckButton:(UIButton*)sender
{
    int nIndex = sender.tag;
    switch (nIndex)
    {
        case 0:
            m_bStoreFlag = !m_bStoreFlag;
            break;

        case 1:
            m_bPortalFlag = !m_bPortalFlag;
            break;

        case 2:
            m_bFreeFlag = !m_bFreeFlag;
            break;

        case 3:
            m_bAcceptFlag = !m_bAcceptFlag;
            break;

        default:
            break;
    }
    
    [self updateCheckButtons];
}

//==============================================================================================================
-(IBAction) actionUpdate:(id)sender
{
    NSString* merchantid = [PWCGlobal getTheGlobal].merchantId;
    NSString* productname = m_txtProductName.text;
    NSString* sku = m_txtProductCode.text;
    NSString* category_id = self.m_strSelectedValue;;
    NSString* qb_product_type = self.m_strSelectedQBProduct;
    NSString* product_description_short = m_txtProductDescription.text;
    NSString* product_description_long = m_txtLongDescription.text;
    
    NSString* is_store_product;
    if(m_bStoreFlag)
        is_store_product = @"1";
    else
        is_store_product = @"0";

    NSString* is_portal_product;
    if(m_bPortalFlag)
        is_portal_product = @"1";
    else
        is_portal_product = @"0";

    NSString* is_free_product;
    if(m_bFreeFlag)
        is_free_product = @"1";
    else
        is_free_product = @"0";

    NSString* is_pay_later;
    if(m_bAcceptFlag)
        is_pay_later = @"1";
    else
        is_pay_later = @"0";

    NSString* price_standard = m_txtStandard.text;
    NSString* price_private = m_txtPrivate.text;
    NSString* price_wholesale = m_txtWholesale.text;
    NSString* price_distributor = m_txtDistributor.text;
    
    NSString* have_sales_tax = m_lblChargeSales.text;
    if([have_sales_tax isEqual: @"Yes-Custom Rate"])
    {
        have_sales_tax = @"CustomRate";
    }
    
    NSString* state_tax_rate = m_txtStateTaxRate.text;
    NSString* country_tax_rate = m_txtCountryTaxRate.text;
    
    if(productname == nil || [productname length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Product Name"];
        return;
    }
    
    
    if(m_nChargeSalesTax == 1)
    {
        int nStateTaxRate = [state_tax_rate intValue];
        int nCountryTaxRate = [country_tax_rate intValue];
        
        if(nStateTaxRate <= 0)
        {
            [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Valid State Tax Rate Which Should Be Greater Then Zero."];
            return;
        }
        
        if(nCountryTaxRate <= 0)
        {
            [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Valid Country Tax Rate Which Should Be Greater Then Zero."];
            return;
        }
    }
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [NSString stringWithFormat: @"%@addProductFromMobile", SERVER_PRODUCT_POST_URL];
    NSLog(@"post URL = %@", strURL);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT]; 
    if(self.m_bEditFlag)
    {
        [request setPostValue: [self.m_dicContent objectForKey: @"pid"] forKey: @"pid"];
    }
    
    [request setPostValue: merchantid forKey: @"merchantid"];
    [request setPostValue: productname forKey: @"productname"];
    [request setPostValue: sku forKey: @"sku"];
    [request setPostValue: category_id forKey: @"category_id"];
    [request setPostValue: qb_product_type forKey: @"qb_product_type"];
    [request setPostValue: product_description_short forKey: @"product_description_short"];
    [request setPostValue: product_description_long forKey: @"product_description_long"];
    [request setPostValue: is_store_product forKey: @"is_store_product"];
    [request setPostValue: is_portal_product forKey: @"is_portal_product"];
    [request setPostValue: is_free_product forKey: @"is_free_product"];
    [request setPostValue: is_pay_later forKey: @"is_pay_later"];
    [request setPostValue: price_standard forKey: @"price_standard"];
    [request setPostValue: price_private forKey: @"price_private"];
    [request setPostValue: price_wholesale forKey: @"price_wholesale"];
    [request setPostValue: price_distributor forKey: @"price_distributor"];
    [request setPostValue: have_sales_tax forKey: @"have_sales_tax"];
    [request setPostValue: state_tax_rate forKey: @"state_tax_rate"];
    [request setPostValue: country_tax_rate forKey: @"country_tax_rate"];
    NSLog(@"m_nChargeSalesTax = %d", m_nChargeSalesTax);
    [request setPostValue: [NSString stringWithFormat: @"%d", m_nChargeSalesTax] forKey: @"sales_tax_custome"];
    
    [request setDidFinishSelector: @selector(finishedAddProduct:)];
    [request setDidFailSelector: @selector(failedLogin:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedAddProduct: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dic = [strResponse JSONValue];
    if([[dic objectForKey: @"message"] isEqual: @"Successfully Done"])
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

//==============================================================================================================
-(void) failedLogin: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
@end
