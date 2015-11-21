//
//  PWCiPhoneCRMNewLeadViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMNewLeadViewController.h"
#import "PWCGlobal.h"
#import "PWCNewLead.h"
#import "PWCiPhoneCRMSalesPathViewController.h"
#import "PWCAppDelegate.h"

@interface PWCiPhoneCRMNewLeadViewController ()

@end

@implementation PWCiPhoneCRMNewLeadViewController

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
}

//==============================================================================================================
-(void) initMember
{
    m_arrCountry = [[NSMutableArray alloc] init];
    m_arrTitle = [[NSMutableArray alloc] init];
    m_arrStates = [[NSMutableArray alloc] init];
    m_arrBalance = [[NSMutableArray alloc] init];
    
    [m_arrBalance addObject: @"0.00"];
    [m_arrBalance addObject: @"0.25"];
    [m_arrBalance addObject: @"0.50"];
    [m_arrBalance addObject: @"0.75"];    
    
    [self initCountry];
    [self initTitle];
    [self initStates];
    
    m_nTopIndex = 0;
    m_nBCountryIndex = -1;
    m_nHCountryIndex = -1;
    m_nGSelectionCountryIndex = -1;
    m_nBSelectionCountryIndex = -1;
    m_nHSelectionCountryIndex = -1;
    m_nBStateSelectionIndex = -1;
    m_nHStateSelectionIndex = -1;
    m_nTitleSelectionIndex = -1;
    
    m_newLead = [PWCNewLead newLead];
    m_swCustomerEnable.onText = @"Yes";
    m_swCustomerEnable.offText = @"No";
    [m_swCustomerEnable addTarget: self action: @selector(actionBalance) forControlEvents: UIControlEventValueChanged];
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(actionTap)];
    [tap1 setNumberOfTapsRequired: 1];
    [m_scrollView addGestureRecognizer: tap1];
    
    
    m_txtBalance.text = @"0";
    m_btnBalance.titleLabel.text = @"0.00";
    
    [self updateTopBar];
    [self updateStates];
}

//==============================================================================================================
-(void) actionTap
{
    [self hideKeyboard];
}

//==============================================================================================================
-(void) actionBalance
{
    if(m_swCustomerEnable.on)
    {
        m_txtBalance.enabled = YES;
        m_btnBalance.enabled = YES;
    }
    else
    {
        m_txtBalance.enabled = NO;
        m_btnBalance.enabled = NO;
    }
}

//==============================================================================================================
-(void) initCountry
{
    [m_arrCountry addObject: @"USA"];
    [m_arrCountry addObject: @"Australia"];
    [m_arrCountry addObject: @"Canada"];
    [m_arrCountry addObject: @"United Kingdom"];
    [m_arrCountry addObject: @"-----------------------------------"];
    [m_arrCountry addObject: @"Afghanistan"];
    [m_arrCountry addObject: @"Albania"];
    [m_arrCountry addObject: @"Algeria"];
    [m_arrCountry addObject: @"Amundsen-Scott"];
    [m_arrCountry addObject: @"Andorra"];
    [m_arrCountry addObject: @"Angola"];
    [m_arrCountry addObject: @"Anguilla"];
    [m_arrCountry addObject: @"Antigua/Barbuda"];
    [m_arrCountry addObject: @"Arctic Ocean"];
    [m_arrCountry addObject: @"Argentina"];
    [m_arrCountry addObject: @"Armenia"];
    [m_arrCountry addObject: @"Aruba"];
    [m_arrCountry addObject: @"Austria"];
    [m_arrCountry addObject: @"Atlantic Ocean(North)"];
    [m_arrCountry addObject: @"Atlantic Ocean(South)"];
    [m_arrCountry addObject: @"Azerbaijan"];
    [m_arrCountry addObject: @"Bahamas"];
    [m_arrCountry addObject: @"Bahrain"];
    [m_arrCountry addObject: @"Bangladesh"];
    [m_arrCountry addObject: @"Barbados"];
    [m_arrCountry addObject: @"Belarus"];
    [m_arrCountry addObject: @"Belgium"];
    [m_arrCountry addObject: @"Belize"];
    [m_arrCountry addObject: @"Benin"];
    [m_arrCountry addObject: @"Bermuda"];
    [m_arrCountry addObject: @"Bhutan"];
    [m_arrCountry addObject: @"Bolivia"];
    [m_arrCountry addObject: @"Bosnia-Herzegovina"];
    [m_arrCountry addObject: @"Botswana"];
    [m_arrCountry addObject: @"Brazil"];
    [m_arrCountry addObject: @"Brunei"];
    [m_arrCountry addObject: @"Bulgaria"];
    [m_arrCountry addObject: @"Burkina Faso"];
    [m_arrCountry addObject: @"Burma(Myanmar)"];
    [m_arrCountry addObject: @"Burundi"];
    [m_arrCountry addObject: @"Cambodia"];
    [m_arrCountry addObject: @"Cameroon"];
    [m_arrCountry addObject: @"Cape Verde"];
    [m_arrCountry addObject: @"Caribbean Sea"];
    [m_arrCountry addObject: @"Central African Republic"];
    [m_arrCountry addObject: @"Chad"];
    [m_arrCountry addObject: @"Chile"];
    [m_arrCountry addObject: @"China"];
    [m_arrCountry addObject: @"Colombia"];
    [m_arrCountry addObject: @"Comoros"];
    [m_arrCountry addObject: @"Congo, Dem."];
    [m_arrCountry addObject: @"Congo, Rep."];
    [m_arrCountry addObject: @"Costa Rica"];
    [m_arrCountry addObject: @"Cozumel"];
    [m_arrCountry addObject: @"Croatia"];
    [m_arrCountry addObject: @"Cuba"];
    [m_arrCountry addObject: @"Crprus"];
    [m_arrCountry addObject: @"Czech Republic"];
    [m_arrCountry addObject: @"Denmark"];
    [m_arrCountry addObject: @"Djibouti"];
    [m_arrCountry addObject: @"Dominica"];
    [m_arrCountry addObject: @"Dominican"];
    [m_arrCountry addObject: @"East Timor"];
    [m_arrCountry addObject: @"Ecuador"];
    [m_arrCountry addObject: @"Egypt"];
    [m_arrCountry addObject: @"El Salvador"];
    [m_arrCountry addObject: @"Equatorial Guinea"];
    [m_arrCountry addObject: @"Eritrea"];
    [m_arrCountry addObject: @"Estonia"];
    [m_arrCountry addObject: @"Ethiopia"];
    [m_arrCountry addObject: @"Finland"];
    [m_arrCountry addObject: @"France"];
    [m_arrCountry addObject: @"Gabon"];
    [m_arrCountry addObject: @"Gambia"];
    [m_arrCountry addObject: @"Georgia"];
    [m_arrCountry addObject: @"Germany"];
    [m_arrCountry addObject: @"Ghana"];
    [m_arrCountry addObject: @"Greece"];
    [m_arrCountry addObject: @"Greek Isles"];
    [m_arrCountry addObject: @"Greenland"];
    [m_arrCountry addObject: @"Grenada"];
    [m_arrCountry addObject: @"Guadeloupe"];
    [m_arrCountry addObject: @"Guatemala"];
    [m_arrCountry addObject: @"Guinea"];
    [m_arrCountry addObject: @"Guinea-Bissau"];
    [m_arrCountry addObject: @"Guyana"];
    [m_arrCountry addObject: @"Haiti"];
    [m_arrCountry addObject: @"Honduras"];
    [m_arrCountry addObject: @"Hungary"];
    [m_arrCountry addObject: @"Iceland"];
    [m_arrCountry addObject: @"India"];
    [m_arrCountry addObject: @"India Ocean"];
    [m_arrCountry addObject: @"Indonesia"];
    [m_arrCountry addObject: @"Iran"];
    [m_arrCountry addObject: @"Iraq"];
    [m_arrCountry addObject: @"Ireland"];
    [m_arrCountry addObject: @"Israel"];
    [m_arrCountry addObject: @"Italy"];
    [m_arrCountry addObject: @"Jamaica"];
    [m_arrCountry addObject: @"Japan"];
    [m_arrCountry addObject: @"Jordan"];
    [m_arrCountry addObject: @"Kazakhstan"];
    [m_arrCountry addObject: @"Keyna"];
    [m_arrCountry addObject: @"Korea(north)"];
    [m_arrCountry addObject: @"Korea(south)"];
    [m_arrCountry addObject: @"Kuwait"];
    [m_arrCountry addObject: @"Kyrgyzstan"];
    [m_arrCountry addObject: @"Laos"];
    [m_arrCountry addObject: @"Latvia"];
    [m_arrCountry addObject: @"Lebanon"];
    [m_arrCountry addObject: @"Lesotho"];
    [m_arrCountry addObject: @"Liberia"];
    [m_arrCountry addObject: @"Libya"];
    [m_arrCountry addObject: @"Liechtenstein"];
    [m_arrCountry addObject: @"Lithuania"];
    [m_arrCountry addObject: @"Luxembourg"];
    [m_arrCountry addObject: @"Macedonia"];
    [m_arrCountry addObject: @"Madagascar"];
    [m_arrCountry addObject: @"Malawi"];
    [m_arrCountry addObject: @"Malaysia"];
    [m_arrCountry addObject: @"Maldives"];
    [m_arrCountry addObject: @"Mali"];
    [m_arrCountry addObject: @"Malta"];
    [m_arrCountry addObject: @"Martinique"];
    [m_arrCountry addObject: @"Mauritania"];
    [m_arrCountry addObject: @"Mauritius"];
    [m_arrCountry addObject: @"Mediterranean Sea"];
    [m_arrCountry addObject: @"Mexico"];
    [m_arrCountry addObject: @"Moldova"];
    [m_arrCountry addObject: @"Monaco"];
    [m_arrCountry addObject: @"Mongolia"];
    [m_arrCountry addObject: @"Montserrat"];
    [m_arrCountry addObject: @"Morocco"];
    [m_arrCountry addObject: @"Mozambique"];
    [m_arrCountry addObject: @"Namibia"];
    [m_arrCountry addObject: @"Nepal"];
    [m_arrCountry addObject: @"Netherlands"];
    [m_arrCountry addObject: @"Netherlands Antilles"];
    [m_arrCountry addObject: @"New Zealand"];
    [m_arrCountry addObject: @"Nicaragua"];
    [m_arrCountry addObject: @"Niger"];
    [m_arrCountry addObject: @"Nigeria"];
    [m_arrCountry addObject: @"Norway"];
    [m_arrCountry addObject: @"Oceania"];
    [m_arrCountry addObject: @"Oman"];
    [m_arrCountry addObject: @"Pacfic Ocean(North)"];
    [m_arrCountry addObject: @"Pacfic Ocean(South)"];
    [m_arrCountry addObject: @"Pakistan"];
    [m_arrCountry addObject: @"Panama"];
    [m_arrCountry addObject: @"Paraguay"];
    [m_arrCountry addObject: @"Peru"];
    [m_arrCountry addObject: @"Philippines"];
    [m_arrCountry addObject: @"Poland"];
    [m_arrCountry addObject: @"Portugal"];
    [m_arrCountry addObject: @"Puerto Rico"];
    [m_arrCountry addObject: @"Qatar"];
    [m_arrCountry addObject: @"Romania"];
    [m_arrCountry addObject: @"Russian Federation"];
    [m_arrCountry addObject: @"Rwanda"];
    [m_arrCountry addObject: @"San Andres"];
    [m_arrCountry addObject: @"San Marino"];
    [m_arrCountry addObject: @"Sao Tome/Principle"];
    [m_arrCountry addObject: @"Saudi Arabia"];
    [m_arrCountry addObject: @"Senegal"];
    [m_arrCountry addObject: @"Serbia/Montenegro(Yugoslavia)"];
    [m_arrCountry addObject: @"Seychelles"];
    [m_arrCountry addObject: @"Sierra Leone"];
    [m_arrCountry addObject: @"Singapore"];
    [m_arrCountry addObject: @"Slovakia"];
    [m_arrCountry addObject: @"Somalia"];
    [m_arrCountry addObject: @"South Africa"];
    [m_arrCountry addObject: @"Spain"];
    [m_arrCountry addObject: @"Sri Lanka"];
    [m_arrCountry addObject: @"St Vincent/Grenadines"];
    [m_arrCountry addObject: @"St. Barts"];
    [m_arrCountry addObject: @"St. Kitts/Nevis"];
    [m_arrCountry addObject: @"St. Lucia"];
    [m_arrCountry addObject: @"St. Martin/Sint Maarten"];
    [m_arrCountry addObject: @"Sudan"];
    [m_arrCountry addObject: @"Suriname"];
    [m_arrCountry addObject: @"Swaziland"];
    [m_arrCountry addObject: @"Sweden"];
    [m_arrCountry addObject: @"Switzerland"];
    [m_arrCountry addObject: @"Syria"];
    [m_arrCountry addObject: @"Taiwan"];
    [m_arrCountry addObject: @"Tajikistan"];
    [m_arrCountry addObject: @"Tanzania"];
    [m_arrCountry addObject: @"Thailand"];
    [m_arrCountry addObject: @"Togo"];
    [m_arrCountry addObject: @"Trinidad/Tobago"];
    [m_arrCountry addObject: @"Tunisia"];
    [m_arrCountry addObject: @"Turkey"];
    [m_arrCountry addObject: @"Turkmenistan"];
    [m_arrCountry addObject: @"Turks/Caicos"];
    [m_arrCountry addObject: @"Uganda"];
    [m_arrCountry addObject: @"Ukraine"];
    [m_arrCountry addObject: @"United Arab Emirates"];
    [m_arrCountry addObject: @"Uruguay"];
    [m_arrCountry addObject: @"Uzbekistan"];
    [m_arrCountry addObject: @"Vatican City"];
    [m_arrCountry addObject: @"Venezuela"];
    [m_arrCountry addObject: @"Vietnam"];
    [m_arrCountry addObject: @"Yemen"];
    [m_arrCountry addObject: @"Zambia"];
    [m_arrCountry addObject: @"Zimbabwe"];    
}

//==============================================================================================================
-(void) initTitle
{
    [m_arrTitle addObject: @"Mr"];
    [m_arrTitle addObject: @"Mrs"];
    [m_arrTitle addObject: @"Ms"];
    [m_arrTitle addObject: @"Miss"];
    [m_arrTitle addObject: @"Master"];
    [m_arrTitle addObject: @"Rev(Reverend)"];
    [m_arrTitle addObject: @"Fr(Father)"];
    [m_arrTitle addObject: @"Dr(Doctor)"];
    [m_arrTitle addObject: @"Atty(Attorney)"];
    [m_arrTitle addObject: @"Prof(Professor)"];
    [m_arrTitle addObject: @"Hon(Honorable)"];
    [m_arrTitle addObject: @"Pres(President)"];
    [m_arrTitle addObject: @"Gov(Governor)"];
    [m_arrTitle addObject: @"Coach"];
    [m_arrTitle addObject: @"Ofc(Officer)"];    
}

//==============================================================================================================
-(void) initStates
{
    NSArray* arrUSA = [NSArray arrayWithObjects: @"Alabama",
                       @"Alaska",
                       @"Arizona",
                       @"Arkansas",
                       @"California",
                       @"Colorado",
                       @"Connecticut",
                       @"Delaware",
                       @"Florida",
                       @"Georgia",
                       @"Hawaii",
                       @"Idaho",
                       @"Illinois",
                       @"Indiana",
                       @"Iowa",
                       @"Kansas",
                       @"Kentucky",
                       @"Louisiana",
                       @"Maine",
                       @"Maryland",
                       @"Massachusets",
                       @"Michigan",
                       @"Minnesota",
                       @"Mississippi",
                       @"Missouri",
                       @"Montana",
                       @"Nebraska",
                       @"Nevada",
                       @"New Hampshire",
                       @"New Jersey",
                       @"New Mexico",
                       @"New York",
                       @"North Carolina",
                       @"North Dakota",
                       @"Ohio",
                       @"Oklahoma",
                       @"Oregon",
                       @"Pennsylvania",
                       @"Rhode island",
                       @"South Carolina",
                       @"South Dakota",
                       @"Tennessee",
                       @"Texas",
                       @"Utah",
                       @"Vermont",
                       @"Virginia",
                       @"Washington",
                       @"Washington DC",
                       @"West Virginia",
                       @"Wisconsin",
                       @"Wyoming",
                       nil];
    
    NSArray* arrAustralia = [NSArray arrayWithObjects: @"Ashmore and Cartier Islands",
                         @"Australlian Antarctic Territory",
                         @"Australlian Capital Territory",
                         @"Christmas Island",
                         @"Cocos(Keeling) Islands",
                         @"Coral Sea Islands Territory",
                         @"Heard Island and McDonland Islands",
                         @"Jervis Bay Territory",
                         @"New South Wales",
                         @"Norfolk Island",
                         @"Northern Territory",
                         @"Queensland Queensland",
                         @"South Australia",
                         @"Tasmania",
                         @"Victoria",
                         @"Western Australia",                         
                         nil];
    
    NSArray* arrCanada = [NSArray arrayWithObjects: @"Alberta",
                         @"British Columbia",
                         @"Manitoba",
                         @"New Brunswick",
                         @"Newfoundland",
                         @"Northwest Territory",
                         @"Nova Scotia",
                         @"Nunavut",
                         @"Ontario",
                         @"Prince Edward Island",
                         @"Quebec",
                         @"Saskatchewan",
                         @"Yukon",
                         nil];
    
    NSArray* arrUK = [NSArray arrayWithObjects: @"Bedfordshire",
                      @"Berkshire",
                      @"Buckinghamshire",
                      @"Cambridgeshire",
                      @"Cheshire",
                      @"Cornwall",
                      @"Cumbria",
                      @"Derbyshire",
                      @"Devon",
                      @"Dorset",
                      @"Durham",
                      @"East Riding",
                      @"East Sussex",
                      @"East Yorkshire",
                      @"Essex",
                      @"Gloucestershire",
                      @"Greater London",
                      @"Hampshire",
                      @"Hertfordshire",
                      @"Huntingdoshire",
                      @"Kent",
                      @"Lancashire",
                      @"Leicestershire",
                      @"Lincolnshire",
                      @"Merseyside",
                      @"Middlesex",
                      @"Norfolk",
                      @"Northamptonshire",
                      @"Northumberland",
                      @"Norttinghamshire",
                      @"Oxfordshire",
                      @"Rutland",
                      @"Shropshire",
                      @"Somerset",
                      @"South Yorkshire",
                      @"Staffordshire",
                      @"Suffolk",
                      @"Surrey",
                      @"Tyne and Wear",
                      @"Warwickshire",
                      @"West Midlands",
                      @"West Sussex",
                      @"West Yorkshire",
                      @"Wilkshire",
                      @"Worcestershire",                      
                      nil];
    
    [m_arrStates addObject: arrUSA];
    [m_arrStates addObject: arrAustralia];
    [m_arrStates addObject: arrCanada];
    [m_arrStates addObject: arrUK];
}

//==============================================================================================================
-(void) updateStates
{
    if(m_nBCountryIndex == -1)
    {
        m_btnBState.hidden = YES;
        m_txtBState.hidden = NO;
    }
    else
    {
        m_btnBState.hidden = NO;
        m_txtBState.hidden = YES;
    }
    
    if(m_nHCountryIndex == -1)
    {
        m_btnHState.hidden = YES;
        m_txtHState.hidden = NO;
    }
    else
    {
        m_btnHState.hidden = NO;
        m_txtHState.hidden = YES;
    }
}

//==============================================================================================================
-(void) updateTopBar
{
    m_viewGeneral.hidden = YES;
    m_viewBusiness.hidden = YES;
    m_viewHome.hidden = YES;
    
    [m_btnGeneral setTitleColor: [UIColor colorWithRed: 51.0f/255.0f green: 51.0f/255.0f blue: 51.0f/255.0f alpha: 1.0f] forState: UIControlStateNormal];
    [m_btnBusiness setTitleColor: [UIColor colorWithRed: 51.0f/255.0f green: 51.0f/255.0f blue: 51.0f/255.0f alpha: 1.0f] forState: UIControlStateNormal];
    [m_btnHome setTitleColor: [UIColor colorWithRed: 51.0f/255.0f green: 51.0f/255.0f blue: 51.0f/255.0f alpha: 1.0f] forState: UIControlStateNormal];
    
    float fy = 0;
    switch (m_nTopIndex)
    {
        case 0:
            m_imgHover.frame = m_btnGeneral.frame;
            [m_btnGeneral setTitleColor: [UIColor colorWithRed: 218.0f/255.0 green: 218.0f/255.0f blue:218.0f/255.0f alpha: 1.0f] forState: UIControlStateNormal];
            m_viewGeneral.hidden = NO;
            fy = 455;
            break;

        case 1:
            m_imgHover.frame = m_btnBusiness.frame;
            [m_btnBusiness setTitleColor: [UIColor colorWithRed: 218.0f/255.0 green: 218.0f/255.0f blue:218.0f/255.0f alpha: 1.0f] forState: UIControlStateNormal];
            m_viewBusiness.hidden = NO;
            fy = 620;
            break;

        case 2:
            m_imgHover.frame = m_btnHome.frame;
            [m_btnHome setTitleColor: [UIColor colorWithRed: 218.0f/255.0 green: 218.0f/255.0f blue:218.0f/255.0f alpha: 1.0f] forState: UIControlStateNormal];
            m_viewHome.hidden = NO;
            fy = 410;
            break;

        default:
            break;
    }

    m_fBalanceOffset = fy;
    m_viewAddCustomer.frame = CGRectMake(m_viewAddCustomer.frame.origin.x, fy, m_viewAddCustomer.frame.size.width, m_viewAddCustomer.frame.size.height);
    m_btnContinue.frame = CGRectMake(m_btnContinue.frame.origin.x, m_viewAddCustomer.frame.origin.y + m_viewAddCustomer.frame.size.height + 10, m_btnContinue.frame.size.width, m_btnContinue.frame.size.height);
    [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, m_btnContinue.frame.origin.y + m_btnContinue.frame.size.height + 130)];
}

//==============================================================================================================
- (void)hideKeyboard
{
    [m_txtBalance resignFirstResponder];
    [m_txtGFirstName resignFirstResponder];
    [m_txtGLastName resignFirstResponder];
    [m_txtGPhone resignFirstResponder];
    [m_txtGMobile resignFirstResponder];
    [m_txtGEmail resignFirstResponder];
    
    [m_txtBCompanyName resignFirstResponder];
    [m_txtBJobTitle resignFirstResponder];
    [m_txtBCompanyPhone resignFirstResponder];
    [m_txtBAddress resignFirstResponder];
    [m_txtBCity resignFirstResponder];
    [m_txtBZip resignFirstResponder];
    [m_txtBFax resignFirstResponder];
    [m_txtBWebsite resignFirstResponder];
    
    [m_txtHHomePhone resignFirstResponder];
    [m_txtHAddress resignFirstResponder];
    [m_txtHCity resignFirstResponder];
    [m_txtHZip resignFirstResponder];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    m_viewInput.hidden = YES;
}

//==============================================================================================================
-(IBAction) actionCountry: (UIButton*) btn
{
    [self hideKeyboard];
    m_nPickerType = 0;
    m_nSelCountryIndex = btn.tag;
    m_viewInput.hidden = NO;
    [m_picker reloadAllComponents];
    [m_picker selectRow: 0 inComponent: 0 animated: YES];
    [self selectPicker: 0];
}

//==============================================================================================================
-(IBAction) actionTitle:(id)sender
{
    [self hideKeyboard];
    m_nPickerType = 1;
    m_viewInput.hidden = NO;    
    [m_picker reloadAllComponents];
    [m_picker selectRow: 0 inComponent: 0 animated: YES];
    [self selectPicker: 0];    
}

//==============================================================================================================
-(IBAction) actionBalance:(id)sender
{
    [self hideKeyboard];
    m_nPickerType = 3;
    m_viewInput.hidden = NO;
    [m_picker reloadAllComponents];
    [m_picker selectRow: 0 inComponent: 0 animated: YES];
    [self selectPicker: 0];
}

//===============================================================================================================================
-(IBAction) actionState:(UIButton*)sender
{
    [self hideKeyboard];
    m_nStateIndex = sender.tag;
    m_nPickerType = 2;
    [m_picker reloadAllComponents];
    [m_picker selectRow: 0 inComponent: 0 animated: YES];
    [self selectPicker: 0];    
    m_viewInput.hidden = NO;
}

//===============================================================================================================================
-(IBAction) actionTop:(UIButton*)sender
{
    m_nTopIndex = sender.tag;
    [self updateTopBar];
}

//==============================================================================================================
-(IBAction) actionContinue:(id)sender
{
    if(m_nGSelectionCountryIndex != -1)
    {
        m_newLead.general_country = m_btnGCountry.titleLabel.text;
    }
    if(m_nTitleSelectionIndex != -1)
    {
        m_newLead.general_title = m_btnGTitle.titleLabel.text;
    }
    
    /*
    NSString* strGFirstName = m_txtGFirstName.text;
    NSString* strGLastName = m_txtGLastName.text;
    NSString* strGPhone = m_txtGPhone.text;
    NSString* strGMobile = m_txtGMobile.text;
    NSString* strGEmail = m_txtGEmail.text;
    
    if(strGFirstName == nil || [strGFirstName length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Valid First Name"];
        return;
    }

    if(strGLastName == nil || [strGLastName length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Valid Last Name"];
        return;
    }
    
    if((strGPhone == nil || [strGPhone length] <= 0) && (strGMobile == nil || [strGMobile length] <= 0) && (strGEmail == nil || [strGEmail length] <= 0))
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Valid Phone, Mobile or Email"];
        return;
    }
    */
    
    NSString* strGEmail = m_txtGEmail.text;
    if([strGEmail rangeOfString: @"@"].location == NSNotFound || [strGEmail rangeOfString: @"."].location == NSNotFound)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Provide Valid Email"];
        return;
    }
    
    m_newLead.general_first_name = m_txtGFirstName.text;
    m_newLead.general_last_name = m_txtGLastName.text;
    m_newLead.general_phone = m_txtGPhone.text;
    m_newLead.general_mobile = m_txtGMobile.text;
    m_newLead.general_email = m_txtGEmail.text;

    //Business
    if(m_nBSelectionCountryIndex != -1)
    {
        m_newLead.business_country = m_btnBCountry.titleLabel.text;
    }
    m_newLead.business_company_name = m_txtBCompanyName.text;
    m_newLead.business_job_title = m_txtBJobTitle.text;
    m_newLead.business_company_phone = m_txtBCompanyPhone.text;
    m_newLead.business_address = m_txtBAddress.text;
    m_newLead.business_city = m_txtBCity.text;
    m_newLead.business_zip = m_txtBZip.text;
    if(m_nBCountryIndex >= 0)
    {
        m_newLead.business_state = m_btnBState.titleLabel.text;
    }
    else
    {
        m_newLead.business_state = m_txtBState.text;
    }

    m_newLead.business_fax = m_txtBFax.text;
    m_newLead.business_website = m_txtBWebsite.text;
    m_newLead.business_company_name = m_txtBCompanyName.text;

    //Home
   if(m_nHSelectionCountryIndex != -1)
    {
        m_newLead.home_country = m_btnHCountry.titleLabel.text;
    }
    m_newLead.home_phone = m_txtHHomePhone.text;
    m_newLead.home_address = m_txtHAddress.text;
    m_newLead.home_city = m_txtHCity.text;
    m_newLead.home_zip = m_txtHZip.text;
    if(m_nHCountryIndex >= 0)
    {
        m_newLead.home_state = m_btnHState.titleLabel.text;
    }
    else
    {
        m_newLead.home_state = m_txtHState.text;
    }
    
    if(m_swCustomerEnable.on)
    {
        m_newLead.isportalcustomer = @"1";
        m_newLead.unitint = m_txtBalance.text;
        m_newLead.unitdec = [m_btnBalance.titleLabel.text substringFromIndex: 1];
    }
    else
    {
        m_newLead.isportalcustomer = @"0";
        m_newLead.unitint = @"0";
        m_newLead.unitdec = @".00";
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle: nil];
    PWCiPhoneCRMSalesPathViewController* nextView = (PWCiPhoneCRMSalesPathViewController*)[storyboard instantiateViewControllerWithIdentifier: @"crm_sales_path"];
    nextView.m_newLead = m_newLead;
    [self.navigationController pushViewController: nextView animated: YES];
    
}



#pragma mark -
#pragma mark UITextField Delegate.

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
    if(textField.tag == 12)
    {
        m_scrollView.contentSize = CGSizeMake(0, m_fBalanceOffset);
        [m_scrollView setContentOffset:CGPointMake(0, m_fBalanceOffset) animated: YES];
    }
    else
    {
        m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 75);
        [m_scrollView setContentOffset:CGPointMake(0, 75 * textField.tag) animated: YES];
    }
}

//===============================================================================================================================
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return  TRUE;
}

//===============================================================================================================================
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
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
        return [m_arrCountry count];
    }
    else if(m_nPickerType == 1)
    {
        return [m_arrTitle count];
    }
    else if(m_nPickerType == 2)
    {
        if(m_nStateIndex == 0)
        {
            return [[m_arrStates objectAtIndex: m_nBCountryIndex] count];
        }
        else
        {
            return [[m_arrStates objectAtIndex: m_nHCountryIndex] count];
        }
    }
    else
    {
        return [m_arrBalance count];
    }
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
        str = [m_arrCountry objectAtIndex: row];
    }
    else if(m_nPickerType == 1)
    {
        str = [m_arrTitle objectAtIndex: row];
    }
    
    else if(m_nPickerType == 2)
    {
        NSArray* arr;
        if(m_nStateIndex == 0)
        {
            arr = [m_arrStates objectAtIndex: m_nBCountryIndex];
        }
        else
        {
            arr = [m_arrStates objectAtIndex: m_nHCountryIndex];
        }

        str = [arr objectAtIndex: row];
    }
    else
    {
        str = [m_arrBalance objectAtIndex: row];
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
        str = [m_arrCountry objectAtIndex: row];
    }
    else if(m_nPickerType == 1)
    {
        str = [m_arrTitle objectAtIndex: row];
    }
    else if(m_nPickerType == 2)
    {
        NSArray* arr;
        if(m_nStateIndex == 0)
        {
            arr = [m_arrStates objectAtIndex: m_nBCountryIndex];
        }
        else
        {
            arr = [m_arrStates objectAtIndex: m_nHCountryIndex];
        }
        
        str = [arr objectAtIndex: row];
    }
    else
    {
        str = [m_arrBalance objectAtIndex: row];
    }
    return str;
}

//=================================================================================================================================
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self selectPicker: row];
}

//==============================================================================================================
-(void) selectPicker: (int) row
{
    if(m_nPickerType == 0)
    {
        if(row == 4) return;
        NSString* str = [m_arrCountry objectAtIndex: row];
        switch (m_nSelCountryIndex)
        {
            case 0:
                [m_btnGCountry setTitle: str forState: UIControlStateNormal];
                m_nGSelectionCountryIndex = row;
                break;
                
            case 1:
                [m_btnBCountry setTitle: str forState: UIControlStateNormal];
                m_nBCountryIndex = [self getCountryIndex: row];
                m_nBSelectionCountryIndex = row;
                break;
                
            case 2:
                [m_btnHCountry setTitle: str forState: UIControlStateNormal];
                m_nHCountryIndex = [self getCountryIndex: row];
                m_nHSelectionCountryIndex = row;
                break;
                
            default:
                break;
        }
        
        [self updateStates];
    }
    else if(m_nPickerType == 1)
    {
        NSString* str = [m_arrTitle objectAtIndex: row];
        m_nTitleSelectionIndex = row;
        [m_btnGTitle setTitle: str forState: UIControlStateNormal];
    }
    else if(m_nPickerType == 2)
    {
        NSArray* arr;
        if(m_nStateIndex == 0)
        {
            arr = [m_arrStates objectAtIndex: m_nBCountryIndex];
            NSString* str = [arr objectAtIndex: row];
            [m_btnBState setTitle: str forState: UIControlStateNormal];
            m_nBStateSelectionIndex = row;
        }
        else
        {
            arr = [m_arrStates objectAtIndex: m_nHCountryIndex];
            NSString* str = [arr objectAtIndex: row];
            [m_btnHState setTitle: str forState: UIControlStateNormal];
            m_nHStateSelectionIndex = row;
        }
    }
    else
    {
        NSString* str = [m_arrBalance objectAtIndex: row];
        [m_btnBalance setTitle: str forState: UIControlStateNormal];
    }
}

//==============================================================================================================
-(int)getCountryIndex: (int) nIndex
{
    if(nIndex < 4)
    {
        return nIndex;
    }
    return -1;
}

/*
//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sales_path_segue"])
    {
        PWCiPhoneCRMSalesPathViewController *nextView = segue.destinationViewController;
        nextView.m_newLead = m_newLead;                    
        BOOL bFlag = [self actionContinue: self];
        if(!bFlag)
        {
            return;
        }

    }
}
*/

//==============================================================================================================
@end
