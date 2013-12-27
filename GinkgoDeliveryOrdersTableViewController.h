//
//  GinkgoDeliveryOrdersTableViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryOrdersTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property(nonatomic, readonly) PFQuery * query;
@property(nonatomic, readonly) NSArray * products;
@property (strong, nonatomic) NSMutableDictionary * filteredResults;
@property(nonatomic) NSMutableDictionary * categories;
@property (weak, nonatomic) IBOutlet UISearchBar *dishSearch;
@property (nonatomic) UISearchDisplayController * searchDisplayController;
@property (nonatomic) NSString * method;

@end
