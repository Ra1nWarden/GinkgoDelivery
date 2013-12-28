//
//  GinkgoDeliveryCustomerInfoViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 26/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryCustomerInfoViewController.h"
#import "GinkgoDeliveryConfirmationViewController.h"

@interface GinkgoDeliveryCustomerInfoViewController ()

@end

@implementation GinkgoDeliveryCustomerInfoViewController

@synthesize phoneNoField = _phoneNoField;
@synthesize nameField = _nameField;
@synthesize lunchPickup = _lunchPickup;
@synthesize lunchView;
@synthesize pickUpLabel;
@synthesize addressField;
@synthesize method;

- (NSArray *)lunchPickup {
    if(!_lunchPickup) {
        PFQuery * query = [PFQuery queryWithClassName:@"PickUpPoint"];
        _lunchPickup = [query findObjects];
    }
    return _lunchPickup;
}

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
    [self.pickUpLabel setHidden:YES];
    [self.addressField setHidden:YES];
    self.phoneNoField.delegate = self;
    self.nameField.delegate = self;
    self.addressField.delegate = self;
    CGRect framRect = self.addressField.frame;
    framRect.size.height = 5;
    self.addressField.frame = framRect;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * savedName = [defaults objectForKey:@"Name"];
    if(savedName)
        [self.nameField setText:savedName];
    NSString * savedNumber = [defaults objectForKey:@"PhoneNo"];
    if(savedName)
        [self.phoneNoField setText:savedNumber];
    NSString * savedAddress = [defaults objectForKey:@"Address"];
    if(savedAddress)
        [self.addressField setText:savedAddress];
    self.lunchView.delegate = self;
    self.lunchView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.lunchPickup count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.lunchPickup objectAtIndex:row] valueForKey:@"place"];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString * address = [[self.lunchPickup objectAtIndex:row] valueForKey:@"place"];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:address forKey:@"Address"];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:@"Name"];
    NSString * phoneNo = [defaults objectForKey:@"PhoneNo"];
    NSString * address = [defaults objectForKey:@"Address"];
    if(textField.tag == 1) {
        name = textField.text;
        if([name length] == 0)
            name = nil;
        [defaults setObject:name forKey:@"Name"];
        [self.phoneNoField becomeFirstResponder];
    }
    if(textField.tag == 2) {
        phoneNo = textField.text;
        if([phoneNo length] == 0)
            phoneNo = nil;
        [defaults setObject:phoneNo forKey:@"PhoneNo"];
        [textField resignFirstResponder];
    }
    if(textField.tag == 3) {
        address = textField.text;
        if([address length] == 0)
            address = nil;
        [defaults setObject:address forKey:@"Address"];
    }
    [defaults synchronize];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl * segControl = (UISegmentedControl *) sender;
    NSInteger selection = [segControl selectedSegmentIndex];
    if(selection == 2) {
        [self.addressField setHidden:YES];
        [self.pickUpLabel setHidden:YES];
        [self.lunchView setHidden:NO];
    }
    if(selection == 1) {
        [self.addressField setHidden:NO];
        [self.pickUpLabel setHidden:YES];
        [self.lunchView setHidden:YES];
    }
    if(selection == 0) {
        [self.addressField setHidden:YES];
        [self.pickUpLabel setHidden:NO];
        [self.lunchView setHidden:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToMenu"]) {
        [segue.destinationViewController setMethod:self.method];
    }
}
- (IBAction)submitInfo:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:@"Name"];
    NSString * phoneNo = [defaults objectForKey:@"PhoneNo"];
    NSString * address = [defaults objectForKey:@"Address"];
    NSInteger methodNo = [self.segControl selectedSegmentIndex];
    if(methodNo == 0)
        self.method = @"PickUp";
    else if(methodNo == 1)
        self.method = @"Delivery";
    else if(methodNo == 2)
        self.method = @"Lunch";
    if(name && phoneNo && address)
        [self performSegueWithIdentifier:@"goToMenu" sender:sender];
    else if((methodNo == 0) && (name && phoneNo))
        [self performSegueWithIdentifier:@"goToMenu" sender:sender];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid info" message:@"Please enter all information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
