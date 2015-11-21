//
//  PWCOrders.m
//  PWC
//
//  Created by Samiul Hoque on 2/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCOrders.h"

@implementation PWCOrders

@synthesize uniqueId = _uniqueId;
@synthesize orderRowId = _orderRowId;
@synthesize orderId = _orderId;
@synthesize orderChargeStatus = _orderChargeStatus;
@synthesize orderStatus = _orderStatus;
@synthesize orderDate = _orderDate;
@synthesize product = _product;
@synthesize orderAmount = _orderAmount;
@synthesize customer = _customer;
@synthesize affiliate = _affiliate;
@synthesize orderReadStatus = _orderReadStatus;
@synthesize orderDetails = _orderDetails;
@synthesize orderTypes = _orderTypes;

- (id)initWithUniqueId:(int)uniqueId
            orderRowId:(NSString *)orderRowId
               orderId:(NSString *)orderId
     orderChargeStatus:(NSString *)orderChargeStatus
           orderStatus:(NSString *)orderStatus
             orderDate:(NSString *)orderDate
               product:(NSString *)product
           orderAmount:(NSString *)orderAmount
              customer:(NSString *)customer
             affiliate:(NSString *)affiliate
       orderReadStatus:(NSString *)orderReadStatus
          orderDetails:(NSString *)orderDetails
            orderTypes:(NSString *)orderTypes
{
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.orderRowId = orderRowId;
        self.orderId = orderId;
        self.orderChargeStatus = orderChargeStatus;
        self.orderStatus = orderStatus;
        self.orderDate = orderDate;
        self.product = product;
        self.orderAmount = orderAmount;
        self.customer = customer;
        self.affiliate = affiliate;
        self.orderReadStatus = orderReadStatus;
        self.orderDetails = orderDetails;
        self.orderTypes = orderTypes;
    }
    
    return self;
}

@end
