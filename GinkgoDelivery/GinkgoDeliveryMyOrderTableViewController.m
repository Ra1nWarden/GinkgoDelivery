//
//  GinkgoDeliveryMyOrderTableViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 30/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryMyOrderTableViewController.h"

@interface GinkgoDeliveryMyOrderTableViewController ()

@end

@implementation GinkgoDeliveryMyOrderTableViewController

@synthesize confirmedOrders = _confirmedOrders;

-(NSArray *)confirmedOrders {
    if(!_confirmedOrders) {
        NSMutableArray * tempConfirmedOrders = [[NSMutableArray alloc] init];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * storedOrders = [defaults objectForKey:@"localOrder"];
        NSLog(@"local order size is %d", [storedOrders count]);
        NSMutableArray * updatedLocalOrder = [[NSMutableArray alloc] init];
        if(!storedOrders)
            storedOrders = [[NSMutableArray alloc] init];
        PFQuery * query = [PFQuery queryWithClassName:@"Order"];
        for(NSString * eachId in storedOrders) {
            NSLog(@"printing id %@", eachId);
            PFObject * eachOnlineOrder = [query getObjectWithId:eachId];
            if(eachOnlineOrder) {
                NSLog(@"not nil~");
                [tempConfirmedOrders addObject:eachOnlineOrder];
                [updatedLocalOrder addObject:eachId];
            }
        }
        NSLog(@"retrieved object count is %d", [tempConfirmedOrders count]);
        [defaults setObject:updatedLocalOrder forKey:@"localOrder"];
        [defaults synchronize];
        _confirmedOrders = tempConfirmedOrders;
    }
    return _confirmedOrders;
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.confirmedOrders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocalOrderListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LocalOrderListCell"];
    
    PFObject * currentOrder = [self.confirmedOrders objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@'s %@ order",[currentOrder valueForKey:@"name"], [currentOrder valueForKey:@"method"]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString * dateInString = [dateFormatter stringFromDate:[currentOrder valueForKey:@"createdAt"]];
    cell.detailTextLabel.text = dateInString;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
