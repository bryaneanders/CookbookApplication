//
//  XNOCategoryTableViewController.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNODetailsTableViewController.h"
#import "XNOCookbookMenuTableViewController.h"

@interface XNOCategoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSFetchedResultsController *fetchController;
@property (retain, nonatomic) NSManagedObjectContext *context;
@property (retain, nonatomic) NSString *headerString;

@end
