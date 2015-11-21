//
//  PWCNewLead.h
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCNewLead : NSObject
{
    NSString*       general_country;
    NSString*       general_title;
    NSString*       general_first_name;
    NSString*       general_last_name;
    NSString*       general_phone;
    NSString*       general_mobile;
    NSString*       general_email;
    
    //Business
    NSString*       business_country;
    NSString*       business_company_name;
    NSString*       business_job_title;
    NSString*       business_company_phone;
    NSString*       business_address;
    NSString*       business_city;
    NSString*       business_zip;
    NSString*       business_state;
    NSString*       business_fax;
    NSString*       business_website;
    
    //Home
    NSString*       home_country;
    NSString*       home_phone;
    NSString*       home_address;
    NSString*       home_city;
    NSString*       home_zip;
    NSString*       home_state;
    
    //
    NSString*       isportalcustomer;
    NSString*       unitint;
    NSString*       unitdec;
    
    NSMutableArray* salespaths;
    NSMutableArray* tags;
    
    NSString*   primary_role_id;
    NSString*   secondary_role_id;
    NSString*   support_role_id;
    NSString*   assignedto_role_id;
}

@property (retain, nonatomic) NSString *general_country;
@property (retain, nonatomic) NSString *general_title;
@property (retain, nonatomic) NSString *general_first_name;
@property (retain, nonatomic) NSString *general_last_name;
@property (retain, nonatomic) NSString *general_phone;
@property (retain, nonatomic) NSString *general_mobile;
@property (retain, nonatomic) NSString *general_email;

@property (retain, nonatomic) NSString *business_country;
@property (retain, nonatomic) NSString *business_company_name;
@property (retain, nonatomic) NSString *business_job_title;
@property (retain, nonatomic) NSString *business_company_phone;
@property (retain, nonatomic) NSString *business_address;
@property (retain, nonatomic) NSString *business_city;
@property (retain, nonatomic) NSString *business_zip;
@property (retain, nonatomic) NSString *business_state;
@property (retain, nonatomic) NSString *business_fax;
@property (retain, nonatomic) NSString *business_website;

@property (retain, nonatomic) NSString *home_country;
@property (retain, nonatomic) NSString *home_phone;
@property (retain, nonatomic) NSString *home_address;
@property (retain, nonatomic) NSString *home_city;
@property (retain, nonatomic) NSString *home_zip;
@property (retain, nonatomic) NSString *home_state;

@property (retain, nonatomic) NSString *isportalcustomer;
@property (retain, nonatomic) NSString *unitint;
@property (retain, nonatomic) NSString *unitdec;

@property (retain, nonatomic) NSMutableArray *salespaths;
@property (retain, nonatomic) NSMutableArray *tags;
@property (retain, nonatomic) NSString *primary_role_id;
@property (retain, nonatomic) NSString *secondary_role_id;
@property (retain, nonatomic) NSString *support_role_id;
@property (retain, nonatomic) NSString *assignedto_role_id;

+(PWCNewLead *)newLead;

@end
