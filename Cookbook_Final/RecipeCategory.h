//
//  RecipeCategory.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/4/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeCategory : NSManagedObject

@property (nonatomic, retain) NSString * header;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSSet *recipies;
@end

@interface RecipeCategory (CoreDataGeneratedAccessors)

- (void)addRecipiesObject:(Recipe *)value;
- (void)removeRecipiesObject:(Recipe *)value;
- (void)addRecipies:(NSSet *)values;
- (void)removeRecipies:(NSSet *)values;

@end
