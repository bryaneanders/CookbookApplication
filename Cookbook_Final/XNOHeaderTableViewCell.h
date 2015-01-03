//
//  XNOHeaderTableViewCell.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/8/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNOCategoryTableViewController.h"

@interface XNOHeaderTableViewCell : UITableViewCell
- (IBAction)backButton:(id)sender;

@property (strong, nonatomic) XNOCategoryTableViewController *categoryTableView;
@end
