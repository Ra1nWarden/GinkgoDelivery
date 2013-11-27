//
//  GinkgoDeliveryCustomerInfoViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 26/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryCustomerInfoViewController : UIViewController <UITextFieldDelegate>
@property NSString * pickuppoint;
@property NSString * dish;
@property (nonatomic) UITextField * nameField;
@property (nonatomic) UITextField * phoneNoField;

@end
