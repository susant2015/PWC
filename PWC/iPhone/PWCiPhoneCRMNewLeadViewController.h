//
//  PWCiPhoneCRMNewLeadViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCNewLead.h"
#import "DCRoundSwitch.h"

@interface PWCiPhoneCRMNewLeadViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIButton*              m_btnGeneral;
    IBOutlet UIButton*              m_btnBusiness;
    IBOutlet UIButton*              m_btnHome;
    IBOutlet UIScrollView*          m_scrollView;
    IBOutlet UIButton*              m_btnContinue;
    
    
    IBOutlet UIView*                m_viewGeneral;
    IBOutlet UIButton*              m_btnGCountry;
    IBOutlet UIButton*              m_btnGTitle;
    IBOutlet UITextField*           m_txtGFirstName;
    IBOutlet UITextField*           m_txtGLastName;
    IBOutlet UITextField*           m_txtGPhone;
    IBOutlet UITextField*           m_txtGMobile;
    IBOutlet UITextField*           m_txtGEmail;

    IBOutlet UIView*                m_viewBusiness;
    IBOutlet UIButton*              m_btnBCountry;
    IBOutlet UITextField*           m_txtBCompanyName;
    IBOutlet UITextField*           m_txtBJobTitle;
    IBOutlet UITextField*           m_txtBCompanyPhone;
    IBOutlet UITextField*           m_txtBAddress;
    IBOutlet UITextField*           m_txtBCity;
    IBOutlet UITextField*           m_txtBZip;
    IBOutlet UIButton*              m_btnBState;
    IBOutlet UITextField*           m_txtBState;
    IBOutlet UITextField*           m_txtBFax;
    IBOutlet UITextField*           m_txtBWebsite;

    IBOutlet UIView*                m_viewHome;
    IBOutlet UIButton*              m_btnHCountry;
    IBOutlet UITextField*           m_txtHHomePhone;
    IBOutlet UITextField*           m_txtHAddress;
    IBOutlet UITextField*           m_txtHCity;
    IBOutlet UITextField*           m_txtHZip;
    IBOutlet UIButton*              m_btnHState;
    IBOutlet UITextField*           m_txtHState;
    
    IBOutlet UIView*                m_viewInput;
    IBOutlet UIPickerView*          m_picker;
    
    IBOutlet UIView*                m_viewAddCustomer;
    IBOutlet DCRoundSwitch*         m_swCustomerEnable;
    IBOutlet UITextField*           m_txtBalance;
    IBOutlet UIButton*              m_btnBalance;
    
    IBOutlet UIImageView*           m_imgHover;
    
    float                           m_fScrollHeight;
    int                             m_nSelCountryIndex;
    int                             m_nPickerType;

    int                             m_nTopIndex;
    
    int                             m_nStateIndex;
    int                             m_nBCountryIndex;
    int                             m_nHCountryIndex;
    int                             m_nGSelectionCountryIndex;
    int                             m_nBSelectionCountryIndex;
    int                             m_nHSelectionCountryIndex;
    
    int                             m_nTitleSelectionIndex;
    int                             m_nBStateSelectionIndex;
    int                             m_nHStateSelectionIndex;
    
    float                           m_fBalanceOffset;
    
    NSMutableArray*                 m_arrCountry;
    NSMutableArray*                 m_arrTitle;
    NSMutableArray*                 m_arrStates;
    NSMutableArray*                 m_arrBalance;
    
    PWCNewLead*                     m_newLead;
}

@end
