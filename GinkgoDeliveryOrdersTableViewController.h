//
//  GinkgoDeliveryOrdersTableViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryOrdersTableViewController : UITableViewController <UITableViewDataSource>

@property PFQuery * query;

@end
