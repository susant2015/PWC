//
//  PWCProductDetailViewController.h
//  PWC
//
//  Created by JianJinHu on 8/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCProductDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView*              m_scrollView;
    
    //General Info.
    IBOutlet UITextField*               m_txtProductName;
    IBOutlet UITextField*               m_txtProductCode;
    IBOutlet UILabel*                   m_lblCategory;
    IBOutlet UILabel*                   m_lblQuickBooks;
    IBOutlet UITextView*                m_txtProductDescription;
    IBOutlet UITextView*                m_txtLongDescription;
    IBOutlet UIButton*                  m_btnStoresProduct;
    IBOutlet UIImageView*               m_imgStoresProduct;
    IBOutlet UIButton*                  m_btnPortalProduct;
    IBOutlet UIImageView*               m_imgPortalProduct;
    IBOutlet UITextField*               m_txtStandard;
    IBOutlet UITextField*               m_txtPrivate;
    IBOutlet UITextField*               m_txtWholesale;
    IBOutlet UITextField*               m_txtDistributor;
    IBOutlet UIButton*                  m_btnFreeProduct;
    IBOutlet UIImageView*               m_imgFreeProduct;
    IBOutlet UIButton*                  m_btnAcceptPayLater;
    IBOutlet UIImageView*               m_imgAcceptPayLater;
    IBOutlet UIButton*                  m_btnChargeSales;
    IBOutlet UILabel*                   m_lblChargeSales;
    IBOutlet UITextField*               m_txtStateTaxRate;
    IBOutlet UITextField*               m_txtCountryTaxRate;
    IBOutlet UIView*                    m_viewCustomRate;
    IBOutlet UIButton*                  m_btnAdd;
    
    IBOutlet UIView*                    m_viewInput;
    IBOutlet UIPickerView*              m_picker;
    
    NSMutableArray*                     m_arrProductCategory;
    NSMutableArray*                     m_arrQuickBooks;
    NSMutableArray*                     m_arrChargeSale;
    
    int                                 m_nPickerType;
    int                                 m_nChargeSalesTax;
    
    float                               m_fScrollHeight;
    
    BOOL                                m_bStoreFlag;
    BOOL                                m_bPortalFlag;
    BOOL                                m_bFreeFlag;
    BOOL                                m_bAcceptFlag;
    
    CGRect                              m_rectCustomView;
    CGRect                              m_rectAddButton;
}

@property(nonatomic, retain) NSString*      m_strSelectedValue;
@property(nonatomic, retain) NSString*      m_strSelectedQBProduct;
@property(nonatomic, retain) NSDictionary*  m_dicContent;
@property(nonatomic, assign) BOOL           m_bEditFlag;
@end
