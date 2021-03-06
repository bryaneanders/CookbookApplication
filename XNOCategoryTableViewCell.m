//
//  XNOCategoryTableViewCell.m
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/8/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import "XNOCategoryTableViewCell.h"

@implementation XNOCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , self.frame.size.width,0.5)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:seperatorView];
    
    self.imageView.frame = CGRectMake(20, 2, 40, 40);
    self.textLabel.frame = CGRectMake(70, 12, 150, 20);
}
@end
