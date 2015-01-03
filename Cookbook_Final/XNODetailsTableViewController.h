//
//  XNODetailsTableViewController.h
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#include <CoreData/CoreData.h>
#include "Recipe.h"
#include "RecipeCategory.h"
#include "XNOCategoryTableViewController.h"

@interface XNODetailsTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (strong, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) RecipeCategory *category;
@property (strong, nonatomic) Recipe *recipe;
@property (nonatomic) BOOL canEdit;
@property (nonatomic) BOOL isExistingRecipe;
@property (retain, nonatomic) NSManagedObjectContext *context;
@property (retain, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) NSIndexPath *currentlyEditing;

-(void)reinitFields;
-(void)setDisabled;
-(void)setEnabled;
- (IBAction)editButtonInteraction:(id)sender;

@end
