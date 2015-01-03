//
//  XNOHeaderTableViewCell.m
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/8/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import "XNOHeaderTableViewCell.h"

@implementation XNOHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)backButton:(id)sender {
    [self.categoryTableView dismissViewControllerAnimated:YES completion:NULL];
}
@end
