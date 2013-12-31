//
//  GinkgoDeliveryOrderCell.m
//  GinkgoDelivery
//
//  Created by Zihao Wang on 29/12/13.
//  Copyright (c) 2013 Zihao Wang. All rights reserved.
//

#import "GinkgoDeliveryOrderCell.h"

@implementation GinkgoDeliveryOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];  //The default implementation of the layoutSubviews
    
    self.textLabel.frame = CGRectMake(15, 11, 180, 21);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    CGRect detailTextLabelFrame = CGRectMake(280, 11, 40, 21);
    self.detailTextLabel.frame = detailTextLabelFrame;
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    
    [self sizeToFit];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
