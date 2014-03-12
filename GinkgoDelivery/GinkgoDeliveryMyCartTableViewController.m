//
//  GinkgoDeliveryMyCartTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 29/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryMyCartTableViewController.h"
#import "GinkgoDeliveryOrderCell.h"

@interface GinkgoDeliveryMyCartTableViewController ()

@end

@implementation GinkgoDeliveryMyCartTableViewController

@synthesize method;
@synthesize methodLabel;
@synthesize myOrderTableView;
@synthesize deliveryFee = _deliveryFee;
@synthesize taxRate = _taxRate;
@synthesize totalFee;
@synthesize orders = _orders;

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

-(NSArray *)orders {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if([self.method isEqualToString:@"Lunch"]) {
        _orders = [defaults objectForKey:@"LunchOrder"];
    }
    else if([self.method isEqualToString:@"Delivery"]) {
        _orders = [defaults objectForKey:@"DeliveryOrder"];
    }
    else if([self.method isEqualToString:@"PickUp"]) {
        _orders = [defaults objectForKey:@"PickUpOrder"];
    }
    return _orders;
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
    [self.methodLabel setText:[NSString stringWithFormat:@"Delivery Method: %@", self.method]];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [self.orders count];
    else
        return 4;
}

-(IBAction)valueChanges:(id)sender {
    UITableViewCell * cell = (GinkgoDeliveryOrderCell *)[[[sender superview] superview] superview];
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    UIStepper * button = (UIStepper*) sender;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int) button.value];
    NSMutableArray * newOrder = [self.orders mutableCopy];
    NSNumber * updatedvalue = [[NSNumber alloc] initWithDouble:button.value];
    NSMutableDictionary * updateOrder = [[newOrder objectAtIndex:index.row] mutableCopy];
    [updateOrder setObject:updatedvalue forKey:@"Quantity"];
    [newOrder replaceObjectAtIndex:index.row withObject:updateOrder];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if([self.method isEqualToString:@"Lunch"])
       [defaults setObject:newOrder forKey:@"LunchOrder"];
    else if([self.method isEqualToString:@"Delivery"])
        [defaults setObject:newOrder forKey:@"DeliveryOrder"];
    else if([self.method isEqualToString:@"PickUp"])
        [defaults setObject:newOrder forKey:@"PickUpOrder"];
    [defaults synchronize];
    [self.tableView reloadData];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Orders";
    else if(section == 1)
        return @"Price";
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OrderCellIdentifier = @"OrderCell";
    static NSString *MoneyCellIdentifier = @"MoneyCell";
    
    UITableViewCell *cell;
    if(indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
        if ( cell == nil ) {
            cell = [[GinkgoDeliveryOrderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:OrderCellIdentifier];
            UIStepper * stepper = [[UIStepper alloc] initWithFrame:CGRectMake(113, 7, 94, 29)];
            [cell addSubview:stepper];
        }
        NSMutableDictionary * currentCellOrder = [self.orders objectAtIndex:indexPath.row];
        cell.textLabel.text = [currentCellOrder objectForKey:@"Name"];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[currentCellOrder objectForKey:@"Quantity" ] intValue]];
        UIStepper * step = (UIStepper *)[cell viewWithTag:10];
        step.minimumValue = 1;
        step.stepValue = 1;
        step.value = [cell.detailTextLabel.text doubleValue];
        [step addTarget:self action:@selector(valueChanges:) forControlEvents:UIControlEventValueChanged];
    }
    else if(indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:MoneyCellIdentifier forIndexPath:indexPath];
        if ( cell == nil ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyCellIdentifier];
        }
        NSNumber * total = [[NSNumber alloc] initWithDouble:0];
        if([self.method isEqualToString:@"Lunch"]) {
            for(NSMutableDictionary * each in self.orders) {
                total = [[NSNumber alloc] initWithDouble:([total doubleValue] + ([[each objectForKey:@"Quantity"] doubleValue] * 6.0))];
            }
        }
        else {
            for(NSMutableDictionary * each in self.orders) {
                total = [[NSNumber alloc] initWithDouble:([total doubleValue] + ([[each objectForKey:@"Quantity"] doubleValue] * [[each objectForKey:@"Price"] doubleValue]))];
            }
        }
        self.totalFee = total;
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Subtotal";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [self.totalFee doubleValue]];
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Tax";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [self.totalFee doubleValue] * [self.taxRate doubleValue]];
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Delivery Fee";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [self.deliveryFee doubleValue]];
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", ([self.totalFee doubleValue] * (1 + [self.taxRate doubleValue]) + [self.deliveryFee doubleValue])];
        }
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0) {
        NSMutableArray * updatedOrder = [self.orders mutableCopy];
        [updatedOrder removeObjectAtIndex:indexPath.row];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if([self.method isEqualToString:@"Lunch"])
           [defaults setObject:updatedOrder forKey:@"LunchOrder"];
        else if([self.method isEqualToString:@"Delivery"])
            [defaults setObject:updatedOrder forKey:@"DeliveryOrder"];
        else if([self.method isEqualToString:@"PickUp"])
            [defaults setObject:updatedOrder forKey:@"PickUpOrder"];
        [defaults synchronize];
        [tableView reloadData];
    }
}

- (IBAction)submitOrder:(id)sender {

    PFObject * newOrder = [PFObject objectWithClassName:@"Order"];
    NSUserDefaults * defauls = [NSUserDefaults standardUserDefaults];
    
    newOrder[@"name"] = [defauls objectForKey:@"Name"];
    newOrder[@"phoneNo"] = [defauls objectForKey:@"PhoneNo"];
    newOrder[@"method"] = self.method;
    newOrder[@"status"] = @"Pending";
    newOrder[@"salePrice"] = self.totalFee;
    if([self.method isEqualToString:@"Delivery"]) {
        NSDictionary * detailAddress = [defauls objectForKey:@"Address"];
        NSMutableString * address = [[detailAddress objectForKey:@"address"] mutableCopy];
        [address appendString:@", apt/suite "];
        [address appendString:[detailAddress objectForKey:@"apt"]];
        [address appendString:@"\n"];
        [address appendString:[detailAddress objectForKey:@"city"]];
        [address appendString:@", "];
        [address appendString:[detailAddress objectForKey:@"state"]];
        newOrder[@"address"] = address;
    }
    else if([self.method isEqualToString:@"Lunch"])
        newOrder[@"address"] = [defauls objectForKey:@"LunchAddress"];
    else if([self.method isEqualToString:@"PickUp"])
        newOrder[@"address"] = @"N/A";
    NSString * specilIns = [defauls objectForKey:@"specialIns"];
    if(!specilIns)
        specilIns = @"none";
    newOrder[@"specialIns"] = specilIns;
    newOrder[@"order"] = self.orders;
    PFQuery * query = [PFQuery queryWithClassName:@"Order"];
    
    [query countObjectsInBackgroundWithBlock:^(int storedCount, NSError * error) {
        if (! error) {
            storedCount++;
            newOrder[@"orderNo"] = [NSNumber numberWithInt:storedCount];
            [newOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
                if(succeeded && ! error) {
                    if([self.method isEqualToString:@"Lunch"])
                        [defauls removeObjectForKey:@"LunchOrder"];
                    else if([self.method isEqualToString:@"Delivery"])
                        [defauls removeObjectForKey:@"DeliveryOrder"];
                    else if([self.method isEqualToString:@"PickUp"])
                        [defauls removeObjectForKey:@"PickUpOrder"];
                    [defauls synchronize];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for(PFObject * each in objects) {
                            if([[each objectForKey:@"orderNo"] isEqualToNumber:[NSNumber numberWithInt:storedCount]]) {
                                
                                NSString * objectId = [each valueForKey:@"objectId"];
                                NSMutableArray * localOrder = [[defauls objectForKey:@"localOrder"] mutableCopy];
                                if(!localOrder)
                                    localOrder = [[NSMutableArray alloc] init];
                                [localOrder addObject:objectId];
                                [defauls setObject:localOrder forKey:@"localOrder"];
                                [defauls synchronize];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submitted!" message:[NSString stringWithFormat:@"Your order number is %d. \n Verification code is %@", storedCount, objectId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [alert show];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                break;
                            }
                        }
                    }];
                }
                else {
                    [self alertNoNetwork];
                }
            }];
        }
        else {
            [self alertNoNetwork];
        }
    }];
    }

- (void)alertNoNetwork {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"You appear offline. Please check network connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
