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
@synthesize deliveryFee;
@synthesize totalFee;
@synthesize orders = _orders;

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
    self.deliveryFee = [[NSNumber alloc]initWithDouble:0.0];
    
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
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[currentCellOrder objectForKey:@"Quantity" ] integerValue]];
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
                NSLog(@"Price! %.2f",[total doubleValue]);
            }
        }
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Subtotal";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [total doubleValue]];
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Tax";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [total doubleValue] * 0.04];
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Delivery Fee";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", [self.deliveryFee doubleValue]];
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", ([total doubleValue] * 1.04 + [self.deliveryFee doubleValue])];
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/







@end
