//
//  PWCNewLead.m
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCNewLead.h"

@implementation PWCNewLead
@synthesize general_country;
@synthesize general_title;
@synthesize general_first_name;
@synthesize general_last_name;
@synthesize general_phone;
@synthesize general_mobile;
@synthesize general_email;

@synthesize business_country;
@synthesize business_company_name;
@synthesize business_job_title;
@synthesize business_company_phone;
@synthesize business_address;
@synthesize business_city;
@synthesize business_zip;
@synthesize business_state;
@synthesize business_fax;
@synthesize business_website;

@synthesize home_country;
@synthesize home_phone;
@synthesize home_address;
@synthesize home_city;
@synthesize home_zip;
@synthesize home_state;

@synthesize isportalcustomer;
@synthesize unitint;
@synthesize unitdec;

@synthesize salespaths;
@synthesize tags;
@synthesize primary_role_id;
@synthesize secondary_role_id;
@synthesize support_role_id;
@synthesize assignedto_role_id;

static PWCNewLead* _newLead = nil;

//==============================================================================================================
+(PWCNewLead *)newLead
{
    @synchronized([PWCNewLead class])
    {
        if (!_newLead) {
            _newLead = [[self alloc] init];
        }
        return _newLead;
    }
    return nil;
}

//==============================================================================================================
+(id)alloc  
{
    @synchronized([PWCNewLead class])
    {
        NSAssert(_newLead == nil, @"Attempted to allocate a second instance of a singleton.");
        _newLead = [super alloc];
        return _newLead;
    }
    return nil;
}

//==============================================================================================================
-(id)init
{
    self = [super init];
    if (self != nil)
    {
        // initialize stuff here
        self.general_country = @"";
        self.general_title = @"";
        self.general_first_name = @"";
        self.general_last_name = @"";
        self.general_phone = @"";
        self.general_mobile = @"";
        self.general_email = @"";
        
        self.business_country = @"";
        self.business_company_name = @"";
        self.business_job_title = @"";
        self.business_company_phone = @"";
        self.business_address = @"";
        self.business_city = @"";
        self.business_zip = @"";
        self.business_state = @"";
        self.business_fax = @"";
        self.business_website = @"";        
        
        self.isportalcustomer = @"";
        self.unitint = @"";
        self.unitdec = @"";
        
        self.salespaths = [[NSMutableArray alloc] init];
        self.tags = [[NSMutableArray alloc] init];
        
        self.primary_role_id = @"";
        self.secondary_role_id = @"";
        self.support_role_id = @"";
        self.assignedto_role_id = @"";
    }
    return self;
}


@end
