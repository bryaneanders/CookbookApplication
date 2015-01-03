//
//  XNOCookbookMenuTableViewController.m
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//


#import "XNOCookbookMenuTableViewController.h"
#import "XNOCategoryTableViewController.h"
#import "XNOAppDelegate.h"
#import "XNODefaultData.h"
#import "RecipeCategory.h"

@interface XNOCookbookMenuTableViewController ()

-(void)addCategoriesToDataModel;

@property (strong, nonatomic) NSString *selectedHeader;

@end

#define NUM_CATEGORIES 7

@implementation XNOCookbookMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    XNOAppDelegate *appDelegate = (XNOAppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate initializeCoreDataStack];
    
    _context = appDelegate.managedObjectContext;
    
    NSArray *results = [self getCategoryResults];
    
    if([results count] < 1) {
        [self addCategoriesToDataModel];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addCategoriesToDataModel
{
    NSError *error;
    RecipeCategory *recipeCategory;
    Recipe *recipe;
    for(int i = 0; i < NUM_CATEGORIES; i++) {
        recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:_context];
        recipeCategory = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeCategory" inManagedObjectContext:_context];
        if(i == 0) {
            recipe.name = [XNODefaultData appetizerName];
            recipe.ingredients = [XNODefaultData appetizerIngredients];
            recipe.instructions = [XNODefaultData appeitzerInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Appetizers"], 0.0);
            recipeCategory.header = @"Appetizers";
            recipeCategory.image =  UIImageJPEGRepresentation([UIImage imageNamed:@"Appetizers"], 0.0);
            recipeCategory.desc = @"Dishes to start your meal with";
        } else if(i == 1) {
            recipe.name = [XNODefaultData bakedGoodsName];
            recipe.ingredients = [XNODefaultData bakedGoodsIngredients];
            recipe.instructions = [XNODefaultData bakedGoodsInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"BakedGoods"], 0.0);
            recipeCategory.header = @"Baked Goods";
            recipeCategory.image = UIImageJPEGRepresentation([UIImage imageNamed:@"BakedGoods"], 0.0);
            recipeCategory.desc = @"Fresh from the oven";
        } else if(i == 2) {
            recipe.name = [XNODefaultData beverageName];
            recipe.ingredients = [XNODefaultData beverageIngredients];
            recipe.instructions = [XNODefaultData beverageInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Beverages"], 0.0);
            recipeCategory.header = @"Beverages";
            recipeCategory.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Beverages"], 0.0);
            recipeCategory.desc = @"Drinks to quench your thirst";
        } else if(i == 3) {
            recipe.name = [XNODefaultData dessertName];
            recipe.ingredients = [XNODefaultData dessertIngredients];
            recipe.instructions = [XNODefaultData dessertInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Desserts"], 0.0);
            recipeCategory.header = @"Desserts";
            recipeCategory.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Desserts"], 0.0);
            recipeCategory.desc = @"Sweet ways to end a meal";
        } else if(i == 4) {
            recipe.name = [XNODefaultData entreeName];
            recipe.ingredients = [XNODefaultData entreeIngredients];
            recipe.instructions = [XNODefaultData entreeInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Entrees"], 0.0);
            recipeCategory.header = @"Entrées";
            recipeCategory.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Entrees"], 0.0);
            recipeCategory.desc = @"The Main Course";
        } else if(i == 5) {
            recipe.name = [XNODefaultData saladName];
            recipe.ingredients = [XNODefaultData saladIngredients];
            recipe.instructions = [XNODefaultData saladInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Salads"], 0.0);
            recipeCategory.header = @"Salads";
            recipeCategory.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Salads"], 0.0);
            recipeCategory.desc = @"Tasty Greens";
        } else if(i == 6) {
            recipe.name = [XNODefaultData soupName];
            recipe.ingredients = [XNODefaultData soupIngredients];
            recipe.instructions = [XNODefaultData soupInstructions];
            recipe.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Soups"], 0.0);
            recipeCategory.header = @"Soups";
            recipeCategory.image = UIImageJPEGRepresentation([UIImage imageNamed:@"Soups"], 0.0);
            recipeCategory.desc = @"Throw something in the pot.";
        }
        recipe.category = recipeCategory;
        [recipeCategory addRecipiesObject:recipe];
        
    }
    if(![_context save:&error])
    {
        NSLog(@"Could not save: %@", error);
    }
    
}

-(NSArray*)getCategoryResults
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"RecipeCategory" inManagedObjectContext:_context]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"header" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    return [_context executeFetchRequest:request error:&error];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *results = [self getCategoryResults];
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    RecipeCategory *category = (RecipeCategory*)[self getCategoryResults][indexPath.row];
    
    cell.textLabel.text = category.header;
    cell.imageView.image = [UIImage imageWithData:category.image];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(5,0 , cell.frame.size.width-10,0.5)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:seperatorView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *results = [self getCategoryResults];
    
    if(indexPath.row < [results count]) {
        return YES;
    }
    
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *results = [self getCategoryResults];
    
    RecipeCategory *category = (RecipeCategory*)[results objectAtIndex:indexPath.row];
    self.selectedHeader = category.header;
    
    [self performSegueWithIdentifier:@"menuToCategorySegue" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"menuToCategorySegue"])
    {
        XNOCategoryTableViewController *categoryView = (XNOCategoryTableViewController*) [segue destinationViewController];

        categoryView.headerString = _selectedHeader;
        
        categoryView.context = _context;

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.header LIKE %@", _selectedHeader];
        [categoryView.fetchController.fetchRequest setPredicate:predicate];
        
        NSError *error;
        if(![categoryView.fetchController performFetch:&error]){
            NSLog(@"Failed to fetch for details view");
        }
    }
}
@end
