//
//  GinkgoDeliveryPickUpPointTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryPickUpPointTableViewController.h"
#import "GinkgoDeliveryConfirmationViewController.h"
#import "GinkgoDeliveryOrdersTableViewController.h"

@interface GinkgoDeliveryPickUpPointTableViewController ()

@end

@implementation GinkgoDeliveryPickUpPointTableViewController
@synthesize dish = _dish;
@synthesize query = _query;
@synthesize places = _places;

- (PFQuery *)query{
    if(! _query)
        _query = [PFQuery queryWithClassName:@"PickUpPoint"];
    return _query;
}

- (NSArray *)places{
    if(! _places)
        _places = [self.query findObjects];
    return _places;
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
    return [self.query countObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Places";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text = [[self.places objectAtIndex:indexPath.row] valueForKey:@"place"];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Pickup Point to Customer Info"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedRowIndex];
        [segue.destinationViewController setPickuppoint: cell.textLabel.text];
        [segue.destinationViewController setDish: self.dish];
    }

}



@end
