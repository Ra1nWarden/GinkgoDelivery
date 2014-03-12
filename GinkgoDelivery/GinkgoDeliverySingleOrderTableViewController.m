//
//  GinkgoDeliverySingleOrderTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 30/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliverySingleOrderTableViewController.h"

@interface GinkgoDeliverySingleOrderTableViewController ()

@end

@implementation GinkgoDeliverySingleOrderTableViewController

@synthesize orderObject;
@synthesize viewTitle;
@synthesize myOrderTableView;
@synthesize taxRate = _taxRate;
@synthesize deliveryFee = _deliveryFee;
@synthesize orderList = _orderList;

- (NSNumber *)taxRate {
    if(! _taxRate) {
        PFQuery * query = [PFQuery queryWithClassName:@"Constants"];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        [query getObjectInBackgroundWithId:@"UfniNTx7pk" block:^(PFObject * object, NSError * error) {
            if(! error) {
                _taxRate = [object valueForKey:@"value"];
                [self.myOrderTableView reloadData];
            }
            else {
                [self alertNoNetwork];
            }
        }];
        _taxRate = [[NSNumber alloc] initWithDouble:0.04];
    }
    return _taxRate;
}

- (NSNumber *)deliveryFee {
    if(! _deliveryFee) {
        PFQuery * query = [PFQuery queryWithClassName:@"Constants"];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        [query getObjectInBackgroundWithId:@"MYhBpVMyEs" block:^(PFObject * object, NSError * error) {
            if(! error) {
                _deliveryFee = [object valueForKey:@"value"];
                [self.myOrderTableView reloadData];
            }
            else {
                [self alertNoNetwork];
            }
        }];
        _deliveryFee = [[NSNumber alloc] initWithDouble:0];
    }
    return _deliveryFee;
}

- (NSArray *)orderList {
    if(! _orderList) {
        _orderList = (NSArray *) [self.orderObject valueForKey:@"order"];
    }
    return _orderList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    self.title = self.viewTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [self.orderList count];
    }
    else if(section == 1) {
        return 4;
    }
    else if(section == 2) {
        NSString * method = [self.orderObject valueForKey:@"method"];
        if([method isEqualToString:@"PickUp"]) {
            return 2;
        }
        else
            return 3;
    }
    else if (section == 3) {
        return 1;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Orders";
    else if(section == 1)
        return @"Price";
    else if(section == 2) {
        NSString * method = [self.orderObject valueForKey:@"method"];
        if([method isEqualToString:@"PickUp"])
            return @"Your Information";
        else
            return @"Deliver to";
    }
    else if (section == 3) {
        return @"Live Updates";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SingleOrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    if(indexPath.section == 0) {
        NSDictionary * currentDish = [[self.orderObject valueForKey:@"order"] objectAtIndex:indexPath.row];
        cell.textLabel.text = [currentDish objectForKey:@"Name"];
        cell.detailTextLabel.text = [[currentDish objectForKey:@"Quantity"] stringValue];
    }
    else if(indexPath.section == 1) {
        NSNumber * salePrice = [self.orderObject valueForKey:@"salePrice"];
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Subtotal";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [salePrice doubleValue]];
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Tax";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [salePrice doubleValue] * [self.taxRate doubleValue]];
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Delivery Fee";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [self.deliveryFee doubleValue]];
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", ([salePrice doubleValue] * (1 + [self.taxRate doubleValue]) + [self.deliveryFee doubleValue])];
        }
    }
    else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [self.orderObject valueForKey:@"name"];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Phone Number";
            cell.detailTextLabel.text = [self.orderObject valueForKey:@"phoneNo"];
        }
        else {
            NSString * method = [self.orderObject valueForKey:@"method"];
            if([method isEqualToString:@"Lunch"]) {
                if(indexPath.row == 2) {
                    cell.textLabel.text = @"Address";
                    cell.detailTextLabel.text = [self.orderObject valueForKey:@"address"];
                }
            }
            else if([method isEqualToString:@"Delivery"]) {
                cell.textLabel.text = @"Address";
                cell.detailTextLabel.text = [self.orderObject valueForKey:@"address"];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            }
        }
    }
    else if (indexPath.section == 3) {
        cell.textLabel.text = @"Order Status";
        cell.detailTextLabel.text = [self.orderObject valueForKey:@"status"];
    }
    return cell;
}

- (void)alertNoNetwork {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"You appear offline. Please check network connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
