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
@synthesize lunchView = _lunchView;
@synthesize pickUpLabel = _pickUpLabel;
@synthesize addressField;
@synthesize aptNo;
@synthesize city;
@synthesize state;
@synthesize specialIns;
@synthesize deliveryFormLabel;
@synthesize method;
@synthesize deliveryForm;
@synthesize activeField;

- (UILabel *)pickUpLabel {
    if(! _pickUpLabel) {
        _pickUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 283, 280, 254)];
        [_pickUpLabel setText:@"No address is required for pick up!"];
        [_pickUpLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _pickUpLabel;
}

- (UIPickerView *)lunchView {
    if(! _lunchView) {
        _lunchView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 283, 280, 254)];
    }
    return _lunchView;
}

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
    [self registerForKeyboardNotifications];
    [self.view addSubview:self.pickUpLabel];
    [self.view addSubview:self.lunchView];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [self.deliveryForm setFrame:CGRectMake(20, 283, 280, 254)];
    [self.deliveryForm setHidden:YES];
    [self.pickUpLabel setHidden:YES];
    self.phoneNoField.delegate = self;
    self.nameField.delegate = self;
    self.addressField.delegate = self;
    self.aptNo.delegate = self;
    self.city.delegate = self;
    self.state.delegate = self;
    self.specialIns.delegate = self;
    self.specialIns.layer.borderWidth = 0.5f;
    self.specialIns.layer.borderColor = [[UIColor grayColor]CGColor];
    self.specialIns.layer.cornerRadius = 5;
    self.specialIns.clipsToBounds = YES;
    self.deliveryForm.delegate = self;
    [self.deliveryForm addSubview:self.addressField];
    [self.deliveryForm addSubview:self.aptNo];
    [self.deliveryForm addSubview:self.city];
    [self.deliveryForm addSubview:self.state];
    [self.deliveryForm addSubview:self.deliveryFormLabel];
    [self.deliveryForm addSubview:self.specialIns];
    [self.deliveryForm setContentSize:CGSizeMake(280, 254)];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"Address"]) {
        NSMutableDictionary * newUser = [[NSMutableDictionary alloc] init];
        [newUser setObject:@"Charlottesville" forKey:@"city"];
        [newUser setObject:@"VA" forKey:@"state"];
        [defaults setObject:newUser forKey:@"Address"];
        [defaults synchronize];
    }
    NSString * savedName = [defaults objectForKey:@"Name"];
    if(savedName)
        [self.nameField setText:savedName];
    NSString * savedNumber = [defaults objectForKey:@"PhoneNo"];
    if(savedName)
        [self.phoneNoField setText:savedNumber];
    NSMutableDictionary * savedAddress = [defaults objectForKey:@"Address"];
    if(savedAddress) {
        [self.addressField setText:[savedAddress objectForKey:@"address"]];
        [self.aptNo setText:[savedAddress objectForKey:@"apt"]];
        [self.city setText:[savedAddress objectForKey:@"city"]];
        [self.state setText:[savedAddress objectForKey:@"state"]];
    }
    NSString * specialInstructions = [defaults objectForKey:@"specialIns"];
    if(specialInstructions)
        [self.specialIns setText:specialInstructions];
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
    [defaults setObject:address forKey:@"LunchAddress"];
}


- (void) textFieldDidEndEditing:(UITextField *)textField {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * name = [defaults objectForKey:@"Name"];
    NSString * phoneNo = [defaults objectForKey:@"PhoneNo"];
    NSMutableDictionary * address = [[defaults objectForKey:@"Address"] mutableCopy];
    if(textField.tag == 1) {
        name = textField.text;
        if([name length] == 0)
            name = nil;
        [defaults setObject:name forKey:@"Name"];
        [defaults synchronize];
    }
    if(textField.tag == 2) {
        phoneNo = textField.text;
        if([phoneNo length] == 0)
            phoneNo = nil;
        [defaults setObject:phoneNo forKey:@"PhoneNo"];
        [defaults synchronize];
    }
    if(textField.tag == 3) {
        NSString * streetTemp = textField.text;
        if([streetTemp length] != 0)
            [address setObject:streetTemp forKey:@"address"];
        else
            [address removeObjectForKey:@"address"];
        [defaults setObject:address forKey:@"Address"];
        [defaults synchronize];
    }
    if(textField.tag == 4) {
        NSString * aptTemp = textField.text;
        if([aptTemp length] != 0)
            [address setObject:aptTemp forKey:@"apt"];
        else
            [address removeObjectForKey:@"apt"];
        [defaults setObject:address forKey:@"Address"];
        [defaults synchronize];
    }
    if(textField.tag == 5) {
        NSString * cityTemp = textField.text;
        if([cityTemp length] != 0)
            [address setObject:cityTemp forKey:@"city"];
        else
            [address removeObjectForKey:@"city"];
        [defaults setObject:address forKey:@"Address"];
        [defaults synchronize];
    }
    if(textField.tag == 6) {
        NSString * stateTemp = textField.text;
        if([stateTemp length] != 0)
            [address setObject:stateTemp forKey:@"state"];
        else
            [address removeObjectForKey:@"state"];
        [defaults setObject:address forKey:@"Address"];
        [defaults synchronize];
    }
    if(textField.tag == 7) {
        NSString * specialTemp = textField.text;
        if([specialTemp length] == 0)
            specialTemp = nil;
        [defaults setObject:specialTemp forKey:@"specialIns"];
        [defaults synchronize];
    }
    self.activeField = nil;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl * segControl = (UISegmentedControl *) sender;
    NSInteger selection = [segControl selectedSegmentIndex];
    if(selection == 2) {
        [self.deliveryForm setHidden:YES];
        [self.pickUpLabel setHidden:YES];
        [self.lunchView setHidden:NO];
    }
    if(selection == 1) {
        [self.deliveryForm setHidden:NO];
        [self.pickUpLabel setHidden:YES];
        [self.lunchView setHidden:YES];
    }
    if(selection == 0) {
        [self.deliveryForm setHidden:YES];
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
    NSInteger methodNo = [self.segControl selectedSegmentIndex];
    BOOL success = NO;
    if(name && phoneNo) {
        if(methodNo == 0) {
            success = YES;
            self.method = @"PickUp";
        }
        else if(methodNo == 2) {
            success = YES;
            self.method = @"Lunch";
        }
        else if(methodNo == 1) {
            NSMutableDictionary * address = [defaults objectForKey:@"Address"];
            if([address count] == 4) {
                success = YES;
                self.method = @"Delivery";
            }
        }
    }
    if(success)
       [self performSegueWithIdentifier:@"goToMenu" sender:sender];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid info" message:@"Please enter all information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
        
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    if([self.segControl selectedSegmentIndex] == 1) {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.deliveryForm.contentInset = contentInsets;
    self.deliveryForm.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.deliveryForm scrollRectToVisible:activeField.frame animated:YES];
    }
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if([self.segControl selectedSegmentIndex] == 1) {
        
        self.deliveryForm.contentInset = UIEdgeInsetsZero;
        self.deliveryForm.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}




@end
