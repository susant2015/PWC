//
//  PWCGlobal.h
//  PWC
//
//  Created by Samiul Hoque on 2/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCGlobal : NSObject {
    // STATUS
    BOOL _isAuthenticated;
    
    // PUSH
    NSString *_deviceToken;
    NSString *_notificationType;
    NSString *_notificationParam;
    
    // ORDER PUSH DATA
    NSArray *_pushOrderData;
    NSString *_pushOrderTotal;
    
    // IF STATUS 1 - LoggedIn
    NSString *_account_id;
    NSString *_status;
    NSString *_merchantId;
    NSString *_firstName;
    NSString *_lastName;
    NSString *_company;
    NSString *_email;
    int _packageId;
    int _subscriptionType;
    NSString *_hashKey;
    NSString *_userHash;
    NSString *_userType;
    NSString *_coachRowId;
    NSString *_userLevel;
    
    // IF STATUS 0 - Not Logged In
    int _errorCode;
    NSString *_errorText;
    
    // Application Data
    NSString *_applicationApiKey;
    NSString *_loginUrl;
    
    // Currency Settings
    NSString *_currencySymbol;
    NSString *_currencyText;
    
    // Notification Numbers
    NSString *_ordersToday;
    NSString *_orders7Days;
    
    NSArray *_temp1Orders;
    NSArray *_temp7Orders;
    
    // Dashboard Notification Numbers
    NSMutableArray *_dashboardNotifications;
    
    // DefaultTaxRate
    NSString *_defaultTaxRate;
    
    // List of Products
    NSArray *_products;
    
    // List of Customers
    NSArray *_customers;
    
    // List of Services
    NSArray *_services;
    
    // List of Funnels for Services
    NSArray *_funnels;
    
    // List of Tags for Services
    NSArray *_tags;
    
    //Email Profile.
    NSString* m_gSelectedProfile;

}

@property (nonatomic, assign) BOOL isAuthenticated;

// Used for push notification
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *notificationType;
@property (nonatomic, retain) NSString *notificationParam;

// ORDER PUSH DATA
@property (nonatomic, retain) NSArray *pushOrderData;
@property (nonatomic, retain) NSString *pushOrderTotal;

@property (nonatomic, retain) NSString* account_id;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *merchantId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, assign) int packageId;
@property (nonatomic, assign) int subscriptionType;
@property (nonatomic, retain) NSString *hashKey;
@property (nonatomic, retain) NSString *userHash;
@property (nonatomic, retain) NSString *userType;
@property (nonatomic, retain) NSString *coachRowId;
@property (nonatomic, retain) NSString *userLevel;

@property (nonatomic, assign) int errorCode;
@property (nonatomic, retain) NSString *errorText;

@property (nonatomic, retain) NSString *applicationApiKey;
@property (nonatomic, retain) NSString *loginUrl;

@property (nonatomic, retain) NSString *currencySymbol;
@property (nonatomic, retain) NSString *currencyText;

// Notification Numbers
@property (nonatomic, retain) NSString *ordersToday;
@property (nonatomic, retain) NSString *orders7Days;

@property (nonatomic, retain) NSArray *temp1Orders;
@property (nonatomic, retain) NSArray *temp7Orders;

// Dashboard Notification Numbers
@property (nonatomic, retain) NSMutableArray *dashboardNotifications;

// DefaultTaxRate
@property (nonatomic, retain) NSString *defaultTaxRate;

// List of Products
@property (nonatomic, retain) NSArray *products;

// List of Customers
@property (nonatomic, retain) NSArray *customers;

// List of Services
@property (nonatomic, retain) NSArray *services;

// List of Funnels for Services
@property (nonatomic, retain) NSArray *funnels;

// List of Tags for Services
@property (nonatomic, retain) NSArray *tags;

//Email Profile.
@property(nonatomic, retain) NSString* m_gSelectedProfileID;
@property(nonatomic, retain) NSString* m_gSelectedProfile;
@property(nonatomic, retain) NSString* m_gSelectedFrom;
@property(nonatomic, retain) NSString* m_gSelectedReplyTo;
@property(nonatomic, retain) NSString* m_gSelectedSubject;
@property(nonatomic, retain) NSString* m_gSelectedSignature;
@property(nonatomic, retain) NSString* m_gSelectedContentID;
@property(nonatomic, retain) NSString* m_gSelectedSMSSubject;
@property(nonatomic, retain) NSString* m_gSelectedSMSSignature;
@property(nonatomic, retain) NSString* m_gSelectedSMSContentID;
@property(nonatomic, assign) int       m_gSelectedAdminID;

//Task Update.
@property(nonatomic, retain) NSString* m_gUpdatedTaskStatus;
@property(nonatomic, retain) NSString* m_gUpdatedReasiggnedUserId;
@property(nonatomic, retain) NSString* m_gUpdatedReasiggnedUserName;
@property(nonatomic, retain) NSString* m_gUpdatedRescheduleFromDate;
@property(nonatomic, retain) NSString* m_gUpdatedRescheduleToDate;


//Roles ID
@property(nonatomic, assign) int       m_gSelectedPrimaryID;
@property(nonatomic, assign) int       m_gSelectedTechnicalID;
@property(nonatomic, assign) int       m_gSelectedSupportID;
@property(nonatomic, assign) int       m_gSelectedAssignedID;
@property(nonatomic, assign) int       m_gSelectedCustomerID;
@property(nonatomic, assign) int       m_gSelectedTaskID;

@property(nonatomic, retain) NSString* m_gSelectedPrimaryName;
@property(nonatomic, retain) NSString* m_gSelectedTechnicalName;
@property(nonatomic, retain) NSString* m_gSelectedSupportName;
@property(nonatomic, retain) NSString* m_gSelectedAssignedName;
@property(nonatomic, retain) NSString* m_gSelectedCustomerName;
@property(nonatomic, retain) NSString* m_gSelectedTaskName;

//Project Management Sprint.
@property(nonatomic, retain) NSString* m_gSelectedSprintID;

//Project Management Add Task
@property(nonatomic, retain) NSString* m_gSelectedPriority;
@property(nonatomic, retain) NSString* m_gPMAddTaskSelectedAssignedTo;


//Back
@property(nonatomic, retain) id        m_gCRMViewController;
@property(nonatomic, retain) id        m_gPMTaskListController;
@property(nonatomic, retain) id        m_gPMTaskDetailController;

+(PWCGlobal*)getTheGlobal;
-(NSString *)errorMessage;
-(NSString *)getDBPath;
- (void) copyDatabaseIfNeeded;

@end
