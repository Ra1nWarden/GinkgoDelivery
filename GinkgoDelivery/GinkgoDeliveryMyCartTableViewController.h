//
//  GinkgoDeliveryMyCartTableViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 29/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryMyCartTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSString * method;
@property (nonatomic) NSArray * orders;
@property (nonatomic) NSNumber * deliveryFee;
@property (nonatomic) NSNumber * taxRate;
@property (nonatomic) NSNumber * totalFee;
@property (strong, nonatomic) IBOutlet UITableView *myOrderTableView;

@property (weak, nonatomic) IBOutlet UILabel *methodLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;

@end
