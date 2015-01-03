//
//  XNOViewController.m
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import "XNOViewController.h"
#import "Recipe.h"
#import "RecipeCategory.h"

@interface XNOViewController ()
- (IBAction)addRecipeAction:(id)sender;

@property (strong, nonatomic) RecipeCategory *category;

@end

@implementation XNOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _appDelegate = (XNOAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addRecipeAction:(id)sender {
    
    NSString *category;
    if([sender tag] == 1) {
        category = @"Appetizers";
    } else if([sender tag] == 2) {
        category = @"Baked Goods";
    } else if([sender tag] == 3) {
        category = @"Beverages";
    } else if([sender tag] == 4) {
        category = @"Desserts";
    } else if([sender tag] == 5) {
        category = @"Entrées";
    } else if([sender tag] == 6) {
        category = @"Salads";
    } else {
        category = @"Soups";
    }
    
     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecipeCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"header LIKE %@", category];
    
    NSError *error;
    NSArray *results = [_appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if([results count] == 0) {
        NSLog(@"No header %@", category);
    }
    
    _category = (RecipeCategory*)[results objectAtIndex:0];

    [self performSegueWithIdentifier:@"addToDetailsSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"addToDetailsSegue"]) {
        XNODetailsTableViewController *detailsController = (XNODetailsTableViewController*)[segue destinationViewController];
        
        detailsController.category = _category;
        detailsController.isExistingRecipe = FALSE;
        detailsController.canEdit = TRUE;
        
        [detailsController reinitFields];
        [detailsController setEnabled];
    }
}


@end
