//
//  PWCGlobal.m
//  PWC
//
//  Created by Samiul Hoque on 2/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCGlobal.h"

@implementation PWCGlobal

@synthesize isAuthenticated = _isAuthenticated;

@synthesize deviceToken = _deviceToken;
@synthesize notificationType = _notificationType;
@synthesize notificationParam = _notificationParam;

// ORDER PUSH DATA
@synthesize pushOrderData = _pushOrderData;
@synthesize pushOrderTotal = _pushOrderTotal;

@synthesize account_id = _account_id;
@synthesize status = _status;
@synthesize merchantId = _merchantId;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize company = _company;
@synthesize email = _email;
@synthesize packageId = _packageId;
@synthesize subscriptionType = _subscriptionType;
@synthesize hashKey = _hashKey;
@synthesize userHash = _userHash;
@synthesize userType = _userType;
@synthesize coachRowId = _coachRowId;
@synthesize userLevel = _userLevel;

@synthesize errorCode = _errorCode;
@synthesize errorText = _errorText;

@synthesize applicationApiKey = _applicationApiKey;
@synthesize loginUrl = _loginUrl;

@synthesize currencySymbol = _currencySymbol;
@synthesize currencyText = _currencyText;

// Notification Numbers
@synthesize ordersToday = _ordersToday;
@synthesize orders7Days = _orders7Days;

@synthesize temp1Orders = _temp1Orders;
@synthesize temp7Orders = _temp7Orders;

// Dashboard Notification Numbers
@synthesize dashboardNotifications = _dashboardNotifications;

// Default Tax rate
@synthesize defaultTaxRate = _defaultTaxRate;

// List of products
@synthesize products = _products;

// List of Customers
@synthesize customers = _customers;

// List of Services
@synthesize services = _services;

// List of Funnels for Services
@synthesize funnels = _funnels;

// List of Tags for Services
@synthesize tags = _tags;

//Email Profile.
@synthesize m_gSelectedProfile;
@synthesize m_gSelectedFrom;
@synthesize m_gSelectedReplyTo;
@synthesize m_gSelectedSubject;
@synthesize m_gSelectedSignature;
@synthesize m_gSelectedContentID;
@synthesize m_gSelectedProfileID;
@synthesize m_gSelectedSMSContentID;
@synthesize m_gSelectedSMSSignature;
@synthesize m_gSelectedSMSSubject;

//Roles Users.
@synthesize m_gSelectedPrimaryID;
@synthesize m_gSelectedTechnicalID;
@synthesize m_gSelectedSupportID;
@synthesize m_gSelectedAssignedID;
@synthesize m_gSelectedCustomerID;
@synthesize m_gSelectedTaskID;

@synthesize m_gSelectedPrimaryName;
@synthesize m_gSelectedTechnicalName;
@synthesize m_gSelectedSupportName;
@synthesize m_gSelectedAssignedName;
@synthesize m_gSelectedCustomerName;
@synthesize m_gSelectedTaskName;

@synthesize m_gUpdatedTaskStatus;
@synthesize m_gUpdatedReasiggnedUserId;
@synthesize m_gUpdatedRescheduleFromDate;
@synthesize m_gUpdatedRescheduleToDate;
@synthesize m_gUpdatedReasiggnedUserName;

@synthesize m_gSelectedSprintID;

@synthesize m_gSelectedPriority;
@synthesize m_gPMAddTaskSelectedAssignedTo;

@synthesize m_gCRMViewController;
@synthesize m_gPMTaskDetailController;
@synthesize m_gPMTaskListController;

static PWCGlobal* _getTheGlobal = nil;

+(PWCGlobal*)getTheGlobal
{
    @synchronized([PWCGlobal class])
    {
        if (!_getTheGlobal) {
            _getTheGlobal = [[self alloc] init];
        }
        return _getTheGlobal;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCGlobal class])
    {
        NSAssert(_getTheGlobal == nil, @"Attempted to allocate a second instance of a singleton.");
        _getTheGlobal = [super alloc];
        return _getTheGlobal;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        
        m_gSelectedProfile = @"";
        
        // initialize stuff here
        self.applicationApiKey = @"A3NdT43yDiH4hGzXy89her38aAfGd458=";
        self.loginUrl = @"https://www.secureinfossl.com/api/authenticateiPhoneApp.html";
        self.dashboardNotifications = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0",
                                       @"0", @"0", @"0", @"0", nil];
        //self.currencySymbol = @"$";
        //self.currencyText = @"Dollar";
        self.defaultTaxRate = nil;
        self.coachRowId = @"0";
    }
    return self;
}

-(NSString *)errorMessage
{
    NSArray *errCodes = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:1001],
                         [NSNumber numberWithInt:1002],
                         [NSNumber numberWithInt:1007],
                         [NSNumber numberWithInt:1008],
                         [NSNumber numberWithInt:1009],
                         [NSNumber numberWithInt:1010],
                         [NSNumber numberWithInt:1015],
                         [NSNumber numberWithInt:1016],
                         [NSNumber numberWithInt:1017],
                         [NSNumber numberWithInt:2004],
                         nil];
    NSUInteger index = [errCodes indexOfObject:[NSNumber numberWithInt:self.errorCode]];
    NSString *r = nil;
    if (index != NSNotFound) {
        r = [NSString stringWithFormat:@"%d: %@", self.errorCode, self.errorText];
    }
    else {
        r = @"Error in network connection. Please try later.";
    }
    
    //NSString *r = [NSString stringWithFormat:@"%d: %@", self.errorCode, self.errorText];
    return r;
}

- (void)copyDatabaseIfNeeded
{
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pwcdb4.sqlite3"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (NSString *)getDBPath
{
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"pwcdb4.sqlite3"];
}

@end
