//
//  Recipe.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/4/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecipeCategory;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) RecipeCategory *category;

@end
