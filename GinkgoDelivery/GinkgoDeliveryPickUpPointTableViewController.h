//
//  GinkgoDeliveryPickUpPointTableViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryPickUpPointTableViewController : UITableViewController

@property NSString * dish;
@property(nonatomic, readonly) PFQuery * query;
@property(nonatomic, readonly) NSArray * places;


@end
