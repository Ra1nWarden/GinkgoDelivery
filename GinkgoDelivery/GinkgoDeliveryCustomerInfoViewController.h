//
//  GinkgoDeliveryCustomerInfoViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 26/11/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryCustomerInfoViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>
@property (nonatomic) IBOutlet UITextField * nameField;
@property (nonatomic) IBOutlet UITextField * phoneNoField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *aptNo;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFormLabel;
@property (weak, nonatomic) IBOutlet UITextField *specialIns;

@property (nonatomic) UITextField * activeField;

@property (weak, nonatomic) IBOutlet UIScrollView *deliveryForm;
@property (nonatomic) UIPickerView *lunchView;
@property (nonatomic) UILabel *pickUpLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@property (nonatomic) NSArray * lunchPickup;
@property (nonatomic) NSString * method;

@property (weak, nonatomic) IBOutlet UILabel *deliveryAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lunchFailure;
@property (nonatomic) BOOL network;

@end
