//
//  XNOCategoryTableViewController.m
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XNOCategoryTableViewController.h"
#import "XNODetailsTableViewController.h"
#import "XNOAppDelegate.h"
#import "XNOHeaderTableViewCell.h"
#import "RecipeCategory.h"

@interface XNOCategoryTableViewController ()

@property (strong, nonatomic) NSIndexPath *currentlyEditing;
- (IBAction)aboutButton:(id)sender;


@end

@implementation XNOCategoryTableViewController

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
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    NSInteger realNumberOfSections = [self.fetchController.sections count];
    
    if(section < realNumberOfSections) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    } else {
        count = 0;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Recipe *recipe = [self.fetchController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = recipe.name;
    cell.imageView.image = [UIImage imageWithData:recipe.image];
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return (CGFloat) 44.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XNOHeaderTableViewCell *headerView = (XNOHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    
    headerView.textLabel.text = _headerString;
    headerView.textLabel.textAlignment = NSTextAlignmentCenter;
    headerView.textLabel.font = [headerView.textLabel.font fontWithSize:20];
    
    headerView.categoryTableView = self;
    
    return headerView;
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Recipe *objectToDelete = [_fetchController objectAtIndexPath:indexPath];
        [_context deleteObject:objectToDelete];
        
        NSError *error;
        if(![_context save:&error]){
            NSLog(@"Error: %@", error);
        }
        
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView numberOfRowsInSection:0] <= 1) {
        return NO;
    }
       
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentlyEditing = indexPath;
    
    [self performSegueWithIdentifier:@"categoryToDetailsSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"categoryToDetailsSegue"])
    {
        XNODetailsTableViewController *detailsView = [segue destinationViewController];
        
        Recipe *recipeToEdit = [self.fetchController objectAtIndexPath:self.currentlyEditing];
        
        detailsView.canEdit = FALSE;
        detailsView.category = recipeToEdit.category;
        detailsView.recipe = recipeToEdit;
        detailsView.currentlyEditing = _currentlyEditing;
        detailsView.isExistingRecipe = TRUE;
        
        detailsView.fetchController = [self fetchController];
    }
    else if([[segue identifier] isEqualToString:@"categoryToDetailsAddSegue"])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecipeCategory"];
        request.predicate = [NSPredicate predicateWithFormat:@"header LIKE %@", _headerString];
        
        NSError *error;
        NSArray *results = [_context executeFetchRequest:request error:&error];
        
        XNODetailsTableViewController *detailsController = (XNODetailsTableViewController*)[segue destinationViewController];
        
        detailsController.category = (RecipeCategory*)[results objectAtIndex:0];
        detailsController.isExistingRecipe = FALSE;
        detailsController.canEdit = TRUE;
        detailsController.fetchController = [self fetchController];
        
        [detailsController reinitFields];
        [detailsController setEnabled];
    }
}

#pragma mark - Fetch Controller
-(NSFetchedResultsController*)fetchController
{
    if(!_fetchController) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:_context];
        [request setEntity:entityDesc];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.header" ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
        [request setFetchBatchSize:20];
        
        _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_context sectionNameKeyPath:@"category.header" cacheName:nil];
        
        _fetchController.delegate = self;
    
        NSError *error;
        if(![self.fetchController performFetch:&error]) {
            NSLog(@"Error geting fetch controller: %@", error);
        }
    }
    
    return _fetchController;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (IBAction)aboutButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Category Information" message:@"The last row in a recipe section cannot be deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return;
}
@end
