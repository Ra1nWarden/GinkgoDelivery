//
//  GinkgoDeliveryOrderInfoViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryOrderInfoViewController.h"

@interface GinkgoDeliveryOrderInfoViewController ()
@end

@implementation GinkgoDeliveryOrderInfoViewController

@synthesize orderNumber = _orderNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    PFQuery * query = [PFQuery queryWithClassName:@"Order"];
    NSArray * array = [query findObjects];
    NSString * dishName = [[NSString alloc] init];
    NSString * pickUp = [[NSString alloc] init];
    for(PFObject * each in array) {
        if([[each valueForKey:@"orderNo"] isEqualToNumber:self.orderNumber]) {
            dishName = [each valueForKey:@"dish"];
            pickUp = [each valueForKey:@"pickup"];
            break;
        }
    }
    UILabel * orderlabel = (UILabel *) [self.view viewWithTag: 1];
    orderlabel.text = [self.orderNumber stringValue];
    UILabel * dishlabel = (UILabel *) [self.view viewWithTag: 2];
    dishlabel.text = dishName;
    UILabel * placelabel = (UILabel *) [self.view viewWithTag: 3];
    placelabel.text = pickUp;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
