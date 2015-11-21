//
//  PWCOrders.h
//  PWC
//
//  Created by Samiul Hoque on 2/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCOrders : NSObject {
    int _uniqueId;
    NSString *_orderRowId;
    NSString *_orderId;
    NSString *_orderChargeStatus;
    NSString *_orderStatus;
    NSString *_orderDate;
    NSString *_product;
    NSString *_orderAmount;
    NSString *_customer;
    NSString *_affiliate;
    NSString *_orderReadStatus;
    NSString *_orderDetails;
    NSString *_orderTypes;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *orderRowId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderChargeStatus;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *orderDate;
@property (nonatomic, copy) NSString *product;
@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *customer;
@property (nonatomic, copy) NSString *affiliate;
@property (nonatomic, copy) NSString *orderReadStatus;
@property (nonatomic, copy) NSString *orderDetails;
@property (nonatomic, copy) NSString *orderTypes;

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
            orderTypes:(NSString *)orderTypes;

@end
