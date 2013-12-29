//
//  GinkgoDeliveryDishInfoViewController.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 27/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryDishInfoViewController.h"

@interface GinkgoDeliveryDishInfoViewController ()

@end

@implementation GinkgoDeliveryDishInfoViewController

@synthesize dish;
@synthesize imageView;
@synthesize descriptionView;
@synthesize query = _query;
@synthesize dishImage = _dishImage;
@synthesize quanStep;
@synthesize quanLabel;
@synthesize method;
@synthesize price;


- (PFQuery *)query {
    if(!_query)
        _query = [PFQuery queryWithClassName:@"Image"];
    return _query;
}

- (PFObject *)dishImage {
    if(!_dishImage) {
        NSString * imgID = [self.dish valueForKey:@"imageID"];
        _dishImage = [self.query getObjectWithId:imgID];
    }
    return _dishImage;
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
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
	// Do any additional setup after loading the view.
    self.title = [self.dish valueForKey:@"Name"];
    PFFile * imgFile = [self.dishImage valueForKey:@"picture"];
    [imgFile getDataInBackgroundWithBlock: ^(NSData * data, NSError * error) {
        if(! error)
            self.imageView.image = [UIImage imageWithData:data];
        [self.imageView setNeedsDisplay];
    }];
    self.descriptionView.text = [self.dish valueForKey:@"Description"];
    self.quanStep.minimumValue = 1;
    self.quanStep.stepValue = 1;
    self.quanStep.value = 1;
    NSInteger quan = self.quanStep.value;
    [self.quanLabel setText:[NSString stringWithFormat:@"%d", quan]];
    [self.quanLabel setTextAlignment:NSTextAlignmentCenter];
    if([self.method isEqualToString:@"Lunch"])
        price = 6.00;
    else
        price = [[self.dish valueForKey:@"Price"] doubleValue];
    [self.priceLabel setText:[NSString stringWithFormat:@"$ %.2f", (self.price * self.quanStep.value)]];
}
- (IBAction)valueChanged:(id)sender {
    NSInteger quan = self.quanStep.value;
    [self.quanLabel setText:[NSString stringWithFormat:@"%d", quan]];
    [self.quanLabel setNeedsDisplay];
    [self.priceLabel setText:[NSString stringWithFormat:@"$ %.2f", (self.price * self.quanStep.value)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
