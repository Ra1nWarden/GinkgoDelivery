//
//  GinkgoDeliveryOrdersTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 23/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryOrdersTableViewController.h"
#import "GinkgoDeliveryDishInfoViewController.h"

@interface GinkgoDeliveryOrdersTableViewController () 

@end

@implementation GinkgoDeliveryOrdersTableViewController

@synthesize query = _query;
@synthesize products = _products;
@synthesize categories = _categories;
@synthesize dishSearch = _dishSearch;
@synthesize filteredResults = _filteredResults;
@synthesize searchDisplayController;
@synthesize method;


- (PFQuery *)query {
    if(! _query)
        _query = [PFQuery queryWithClassName:@"Menu"];
    return _query;
}

- (NSArray *)products{
    if(! _products) {
        _products = [self.query findObjects];
    }
    return _products;
}

- (NSMutableDictionary *)categories{
    if(!_categories) {
        _categories = [NSMutableDictionary new];
        for(PFObject * each in self.products) {
            NSString * currentcategory = [each valueForKey:@"Category"];
            NSMutableArray * currentlist = [_categories objectForKey:currentcategory];
            if(! currentlist) {
                currentlist = [NSMutableArray array];
            }
            if([self.method isEqualToString:@"Lunch"]) {
                if([[each valueForKey:@"Lunch"] boolValue]) {
                   [currentlist addObject:each];
                }
            }
            else {
                [currentlist addObject:each];
             }
            if([currentlist count] != 0)
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
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.dishSearch contentsController:self];
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;

    self.dishSearch.delegate = self;
    [self.dishSearch sizeToFit];
    self.filteredResults = [NSMutableDictionary dictionaryWithCapacity:[self.categories count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) matchObject: (PFObject *) compare withSearchText: (NSString *) searchText {
    NSString * engName = [compare valueForKey:@"Name"];
    NSString * chName = [compare valueForKey:@"NameChs"];
    NSString * descrip = [compare valueForKey:@"Description"];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    return ([pred evaluateWithObject:engName] || [pred evaluateWithObject:chName] || [pred evaluateWithObject:descrip]);
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self.filteredResults removeAllObjects];
    for(NSString * eachCat in [self.categories allKeys]) {
        NSArray * allItems = [self.categories objectForKey:eachCat];
        for(PFObject * eachDish in allItems) {
            if([self matchObject:eachDish withSearchText:searchString]) {
                NSMutableArray * updatedArray = [self.filteredResults objectForKey:eachCat];
                if(!updatedArray)
                    updatedArray = [[NSMutableArray alloc] init];
                [updatedArray addObject:eachDish];
                [self.filteredResults setObject:updatedArray forKey:eachCat];
            }
        }
    }
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredResults count];
    }
    else
        return [self.categories count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [[self.filteredResults allKeys] objectAtIndex:section];
    }
    else
        return [[self.categories allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * currentCategory = [self tableView:tableView titleForHeaderInSection:section];
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [[self.filteredResults objectForKey:currentCategory] count];
    }
    else
        return [[self.categories objectForKey:currentCategory] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSString * currentCategory = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    PFObject * dish;
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        dish = [[self.filteredResults objectForKey:currentCategory] objectAtIndex:indexPath.row];
    }
    else
        dish = [[self.categories objectForKey:currentCategory] objectAtIndex:indexPath.row];
    NSString * dishName = [dish valueForKey:@"Name"];
    cell.textLabel.text = dishName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    NSNumberFormatter * fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMinimumFractionDigits:2];
    [fmt setRoundingMode:NSNumberFormatterRoundUp];
    NSMutableString * price = [[NSMutableString alloc] initWithString:@"$ "];
    if(![self.method isEqualToString:@"Lunch"])
        [price appendString:[fmt stringFromNumber:[dish valueForKey:@"Price"]]];
    else
        [price appendString:@"6.00"];
    cell.detailTextLabel.text = price;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"dishInfo" sender:tableView];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"dishInfo"]) {
        NSIndexPath * indexPath = [sender indexPathForSelectedRow];
        NSString * categoryName = [self tableView:sender titleForHeaderInSection:indexPath.section];
        PFObject * selectedObject;
        if(sender == self.searchDisplayController.searchResultsTableView)
            selectedObject = [[self.filteredResults objectForKey:categoryName] objectAtIndex:indexPath.row];
        else
            selectedObject = [[self.categories objectForKey:categoryName] objectAtIndex:indexPath.row];
        [segue.destinationViewController setMethod:self.method];
        [segue.destinationViewController setDish: selectedObject];
    }
    if([segue.identifier isEqualToString:@"showCart"]) {
        [segue.destinationViewController setMethod:self.method];
    }
}


@end
