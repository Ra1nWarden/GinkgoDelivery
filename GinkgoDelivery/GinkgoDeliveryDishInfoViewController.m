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
@synthesize quanStep;
@synthesize quanLabel;
@synthesize method;
@synthesize price;


- (PFQuery *)query {
    if(!_query) {
        _query = [PFQuery queryWithClassName:@"Image"];
        _query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    }
    return _query;
}

- (void)displayDishImage {
    NSString * imgID = [self.dish valueForKey:@"imageID"];
    [self.query getObjectInBackgroundWithId:imgID block:^(PFObject * object, NSError * error) {
        if(! error) {
            PFFile * imgFile = [object valueForKey:@"picture"];
            [imgFile getDataInBackgroundWithBlock: ^(NSData * data, NSError * error) {
                if(! error)
                    self.imageView.image = [UIImage imageWithData:data];
                [self.imageView setNeedsDisplay];
            }];
        }
        else {
            [self alertNoNetwork];
        }
    }];
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
    [self displayDishImage];
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
- (IBAction)addCart:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * count = [[NSNumber alloc] initWithDouble:self.quanStep.value];
    NSMutableArray * currentOrder;
    if([self.method isEqualToString:@"Lunch"]) {
        currentOrder = [[defaults objectForKey:@"LunchOrder"] mutableCopy];
        if(!currentOrder)
            currentOrder = [[NSMutableArray alloc] init];
        [self addObjectId:self.dish withCount:count intoArray:currentOrder];
        [defaults setObject:currentOrder forKey:@"LunchOrder"];
        [defaults synchronize];
       
    }
    else if([self.method isEqualToString:@"PickUp"]) {
        currentOrder = [[defaults objectForKey:@"PickUpOrder"] mutableCopy];
        if(!currentOrder)
            currentOrder = [[NSMutableArray alloc] init];
        [self addObjectId:self.dish withCount:count intoArray:currentOrder];
        [defaults setObject:currentOrder forKey:@"PickUpOrder"];
        [defaults synchronize];
    }
    else if([self.method isEqualToString:@"Delivery"]) {
        currentOrder = [[defaults objectForKey:@"DeliveryOrder"] mutableCopy];
        if(!currentOrder)
            currentOrder = [[NSMutableArray alloc] init];
        [self addObjectId:self.dish withCount:count intoArray:currentOrder];
        [defaults setObject:currentOrder forKey:@"DeliveryOrder"];
        [defaults synchronize];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Dish added to cart!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addObjectId:(PFObject*)object withCount:(NSNumber*)objectCount intoArray:(NSMutableArray*)myOrder {
    BOOL contains = NO;
    int containedIndex = -1;
    NSMutableDictionary * replacedEntry = [[NSMutableDictionary alloc] init];
    for(NSDictionary * each in myOrder) {
        if([[each objectForKey:@"Name"] isEqualToString:[object valueForKey:@"Name"]]) {
            contains = YES;
            NSNumber * finalCount = [[NSNumber alloc] initWithInt:([[each objectForKey:@"Quantity"] intValue] + [objectCount intValue])];
            replacedEntry = [each mutableCopy];
            [replacedEntry setObject:finalCount forKey:@"Quantity"];
            containedIndex = [myOrder indexOfObject:each];
            break;
        }
    }
    if(contains)
       [myOrder replaceObjectAtIndex:containedIndex withObject:replacedEntry];
    else {
        NSMutableDictionary * newOrder = [[NSMutableDictionary alloc] init];
        [newOrder setObject:[self.dish valueForKey:@"Name"] forKey:@"Name"];
        [newOrder setObject:[self.dish valueForKey:@"NameChs"] forKey:@"NameChs"];
        [newOrder setObject:[self.dish valueForKey:@"objectId"] forKey:@"ObjectId"];
        [newOrder setObject:[self.dish valueForKey:@"Price"] forKey:@"Price"];
        [newOrder setObject:objectCount forKey:@"Quantity"];
        [myOrder addObject:newOrder];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertNoNetwork {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"You appear offline. Please check network connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
