//
//  GinkgoDeliveryOrdersTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryOrdersTableViewController.h"
#import "GinkgoDeliveryPickUpPointTableViewController.h"

@interface GinkgoDeliveryOrdersTableViewController () 

@end

@implementation GinkgoDeliveryOrdersTableViewController

@synthesize query = _query;
@synthesize products = _products;
@synthesize categories = _categories;


- (PFQuery *)query {
    if(! _query)
        _query = [PFQuery queryWithClassName:@"_Product"];
    return _query;
}

- (NSArray *)products{
    if(! _products)
        _products = [self.query findObjects];
    return _products;
}

- (NSMutableDictionary *)categories{
    if(! _categories) {
        _categories = [NSMutableDictionary new];
        for(PFObject * each in self.products) {
            NSString * currentcategory = [each valueForKey:@"subtitle"];
            NSMutableArray * currentlist = [_categories objectForKey:currentcategory];
            if(! currentlist) {
                currentlist = [NSMutableArray array];
            }
            [currentlist addObject:each];
            [_categories setObject:currentlist forKey:currentcategory];
        }
    }
    return _categories;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.categories count];
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.categories allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * currentCategory = [self tableView:tableView titleForHeaderInSection:section];
    return [[self.categories valueForKey:currentCategory] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Dish";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString * currentCategory = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    PFObject * dish = [[self.categories objectForKey:currentCategory] objectAtIndex:indexPath.row];
    NSString * dishName = [dish valueForKey:@"title"];
    cell.textLabel.text = dishName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Dish to Pickup Point"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedRowIndex];

        [segue.destinationViewController setDish: cell.textLabel.text];
    }
}


@end
