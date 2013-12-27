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
@synthesize orderNumberLabel = _orderNumberLabel;
@synthesize dishLabel = _dishLabel;
@synthesize placeLabel = _placeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
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
    self.orderNumberLabel.text = [self.orderNumber stringValue];
    self.orderNumberLabel.adjustsFontSizeToFitWidth = YES;
    self.dishLabel.text = dishName;
    self.dishLabel.adjustsFontSizeToFitWidth = YES;
    self.placeLabel.text = pickUp;
    self.placeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
