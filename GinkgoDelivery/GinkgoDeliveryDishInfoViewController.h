//
//  GinkgoDeliveryDishInfoViewController.h
//  GinkgoDelivery
//
//  Created by Zihao Wang on 27/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GinkgoDeliveryDishInfoViewController : UIViewController

@property (nonatomic) NSString * method;
@property (nonatomic) double price;
@property (nonatomic) PFObject * dish;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (nonatomic) PFQuery * query;
@property (weak, nonatomic) IBOutlet UIStepper *quanStep;
@property (weak, nonatomic) IBOutlet UILabel *quanLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
