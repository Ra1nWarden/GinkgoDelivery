//
//  GinkgoDeliveryMyOrderTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryMyOrderTableViewController.h"
#import "GinkgoDeliveryOrderInfoViewController.h"

@interface GinkgoDeliveryMyOrderTableViewController ()

@end

@implementation GinkgoDeliveryMyOrderTableViewController
@synthesize query = _query;
@synthesize orders = _orders;


-(PFQuery *)query {
    if(! _query) {
        _query = [PFQuery queryWithClassName:@"Order"];
    }
    return _query;
}

-(NSArray *)orders {
    if(! _orders) {
        NSMutableArray * verifiedOrder = [NSMutableArray array];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * localOrders = [[defaults arrayForKey:@"localOrder"] mutableCopy];
        NSMutableArray * newdefaultarray = [NSMutableArray array];
        NSArray * onlineOrders = [self.query findObjects];
        for(id each in localOrders) {
            BOOL found = NO;
            for(PFObject * eachOrder in onlineOrders) {
                if([[eachOrder valueForKey:@"objectId"] isEqualToString: each]) {
                    found = YES;
                    [verifiedOrder addObject:eachOrder];
                    [newdefaultarray addObject:each];
                    break;
                }
            }
        }
        [defaults setObject:newdefaultarray forKey:@"localOrder"];
        [defaults synchronize];
        _orders = [NSArray arrayWithArray:verifiedOrder];
    }
    return _orders;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyOrder";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSString * textshown = [[[self.orders objectAtIndex:indexPath.row] valueForKey:@"orderNo"] stringValue];
    cell.textLabel.text = textshown;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Order Info"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedRowIndex];
        NSNumber * orderNumer = [NSNumber numberWithInt:[cell.textLabel.text intValue]];
        [segue.destinationViewController setOrderNumber: orderNumer];
    }
}


@end
