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

@synthesize dish = _dish;
@synthesize pickuppoint = _pickuppoint;
@synthesize phoneNoField = _phoneNoField;
@synthesize nameField = _nameField;

-(UITextField *)nameField {
    if(!_nameField) {
        _nameField =(UITextField *)[self.view viewWithTag:1];
    }
    return _nameField;
}

-(UITextField *)phoneNoField {
    if(! _phoneNoField) {
        _phoneNoField =(UITextField *)[self.view viewWithTag:2];
    }
    return _phoneNoField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phoneNoField.delegate = self;
    self.nameField.delegate = self;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * savedName = [defaults objectForKey:@"Name"];
    if(savedName)
        [self.nameField setText:savedName];
    NSString * savedNumber = [defaults objectForKey:@"PhoneNo"];
    if(savedName)
        [self.phoneNoField setText:savedNumber];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:@"Name"];
    NSString * phoneNo = [defaults objectForKey:@"PhoneNo"];
    if(textField.tag == 1) {
        name = textField.text;
        [defaults setObject:name forKey:@"Name"];
        [self.phoneNoField becomeFirstResponder];
    }
    if(textField.tag == 2) {
        phoneNo = textField.text;
        [defaults setObject:phoneNo forKey:@"PhoneNo"];
        [textField resignFirstResponder];
    }
    [defaults synchronize];
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Customer Info to Confirmation"]) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * name = [defaults objectForKey:@"Name"];
        NSString * phoneNo = [defaults objectForKey:@"PhoneNo"];
        if(! name)
            name = [[NSString alloc] init];
        if(! phoneNo)
            phoneNo = [[NSString alloc] init];
        [segue.destinationViewController setName:name];
        [segue.destinationViewController setPhoneNo:phoneNo];
        [segue.destinationViewController setDish:self.dish];
        [segue.destinationViewController setPickuppoint:self.pickuppoint];
      
    }
}

@end
