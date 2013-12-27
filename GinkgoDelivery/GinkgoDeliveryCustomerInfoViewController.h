//
//  GinkgoDeliveryCustomerInfoViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 26/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryCustomerInfoViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic) IBOutlet UITextField * nameField;
@property (nonatomic) IBOutlet UITextField * phoneNoField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIPickerView *lunchView;
@property (weak, nonatomic) IBOutlet UILabel *pickUpLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (nonatomic) NSArray * lunchPickup;
@property (nonatomic) NSString * method;

@end
