//
//  GinkgoDeliverySingleOrderTableViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 30/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliverySingleOrderTableViewController : UITableViewController

@property (nonatomic) PFObject * orderObject;
@property (nonatomic) NSString * viewTitle;
@property (nonatomic) NSArray * orderList;

@end
