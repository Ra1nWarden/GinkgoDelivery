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
@property (nonatomic) NSNumber * taxRate;
@property (nonatomic) NSNumber * deliveryFee;
@property (strong, nonatomic) IBOutlet UITableView *myOrderTableView;

@end
