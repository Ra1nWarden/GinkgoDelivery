//
//  GinkgoDeliveryConfirmationViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryConfirmationViewController.h"
#import "GinkgoDeliveryHomeViewController.h"

@interface GinkgoDeliveryConfirmationViewController ()

@end

@implementation GinkgoDeliveryConfirmationViewController

@synthesize dish = _dish;
@synthesize pickuppoint = _pickuppoint;
@synthesize phoneNo = _phoneNo;
@synthesize name = _name;


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

	// Do any additional setup after loading the view.
    UILabel * dishlabel = (UILabel *)[self.view viewWithTag:1];
    dishlabel.text = self.dish;
    dishlabel.adjustsFontSizeToFitWidth = YES;
    UILabel * placelabel = (UILabel *)[self.view viewWithTag:2];
    placelabel.text = self.pickuppoint;
    placelabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Submit"]) {
        PFQuery * query = [PFQuery queryWithClassName:@"Order"];
        int order = (int) [[query findObjects] count];
        order++;
        NSNumber * neworder = [[NSNumber alloc] initWithInt:order];
        PFObject * myOrder = [PFObject objectWithClassName:@"Order"];
    
        myOrder[@"dish"] = self.dish;
        NSLog(@"dish Saved!");
        myOrder[@"pickup"] = self.pickuppoint;
        NSLog(@"pickup Saved!");
        myOrder[@"orderNo"] = neworder;
        NSLog(@"orderNo Saved!");
        myOrder[@"name"] = self.name;
        NSLog(@"name Saved!");
        myOrder[@"phoneNo"] = self.phoneNo;
        NSLog(@"phoneNo Saved!");
        [myOrder saveInBackground];
        
        
        query = [PFQuery queryWithClassName:@"_Product"];
        NSArray * products = [query findObjects];
        for(PFObject * each in products) {
            if([[each valueForKey:@"title"] isEqualToString:self.dish]) {
                [each incrementKey:@"order"];
                [each saveInBackground];
                break;
            }
        }
        
        // Store the data locally
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * array = [[defaults arrayForKey:@"localOrder"] mutableCopy];
        if(!array)
            array = [NSMutableArray array];
        query = [PFQuery queryWithClassName:@"Order"];
        NSArray * allOrders = [query findObjects];
        NSString * currentOrderId = [[NSString alloc] init];
        for(PFObject * each in allOrders) {

            if([[each valueForKey:@"orderNo"] isEqualToNumber:neworder]) {
                currentOrderId = [each valueForKey:@"objectId"];
                break;
            }
        }
        [array  addObject:currentOrderId];
        [defaults setObject:array forKey:@"localOrder"];
        [defaults synchronize];
    }
}


@end
