//
//  XNOCookbookMenuTableViewController.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface XNOCookbookMenuTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *context;

-(NSArray*)getCategoryResults;

@end
