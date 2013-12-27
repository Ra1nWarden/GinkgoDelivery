//
//  GinkgoDeliveryOrderInfoViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryOrderInfoViewController : UIViewController
@property NSNumber * orderNumber;
@property IBOutlet UILabel * dishLabel;
@property IBOutlet UILabel * orderNumberLabel;
@property IBOutlet UILabel * placeLabel;

@end
