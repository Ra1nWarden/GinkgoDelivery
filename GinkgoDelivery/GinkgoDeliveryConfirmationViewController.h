//
//  GinkgoDeliveryConfirmationViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryConfirmationViewController : UIViewController
@property NSString * dish;
@property NSString * pickuppoint;
@property NSString * name;
@property NSString * phoneNo;
@property IBOutlet UILabel * dishLabel;
@property IBOutlet UILabel * placeLabel;

@end
