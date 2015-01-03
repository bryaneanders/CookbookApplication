//
//  XNODetailsTableViewController.m
//  Cookbook_Final
//
//  Created by Bryan Anders on 12/3/14.
//  Copyright (c) 2014 EWU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XNODetailsTableViewController.h"
#import "XNOAppDelegate.h"

@interface XNODetailsTableViewController ()
- (IBAction)chooseImageButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)saveChanges:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *chooseImageButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButon;
@property (strong, nonatomic) IBOutlet UIButton *backButton;


@property (strong, nonatomic) UIImagePickerController *pickerController;
@end

@implementation XNODetailsTableViewController

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
    
    XNOAppDelegate *appDelegate = (XNOAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    _context = appDelegate.managedObjectContext;
    
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _ingredientsTextView.layer.borderWidth = 0.5;
    _ingredientsTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _ingredientsTextView.layer.cornerRadius = 10;
    _ingredientsTextView.clipsToBounds = YES;
    
    _instructionsTextView.layer.borderWidth = 0.5;
    _instructionsTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _instructionsTextView.layer.cornerRadius = 10;
    _instructionsTextView.clipsToBounds = YES;
    
    if(_recipe != nil) {
        [self setDisabled];
        _nameTextField.text = _recipe.name;
        _ingredientsTextView.text = _recipe.ingredients;
        _instructionsTextView.text = _recipe.instructions;
        _recipeImage.image = [UIImage imageWithData:_recipe.image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reinitFields
{
    _nameTextField.text = @"";
    _ingredientsTextView.text = @"";
    _instructionsTextView.text = @"";
    _recipeImage.image = [UIImage imageNamed:@"defaultImage"];
    _recipe = nil;
    _editButton.enabled = FALSE;
}

- (void)setEnabled
{
    _canEdit = TRUE;
    _saveButon.enabled = TRUE;
    _editButton.enabled = FALSE;
    _chooseImageButton.enabled = TRUE;
    _nameTextField.enabled = TRUE;
    _ingredientsTextView.editable = TRUE;
    _instructionsTextView.editable = TRUE;
    
}

- (void)setDisabled
{
    _canEdit = FALSE;
    _saveButon.enabled = FALSE;
    _editButton.enabled = TRUE;
    _chooseImageButton.enabled = FALSE;
    _nameTextField.enabled = FALSE;
    _ingredientsTextView.editable = FALSE;
    _instructionsTextView.editable = FALSE;
}

#pragma mark Image Picker Controller Methods
- (IBAction)chooseImageButton:(id)sender {
    [self presentViewController:_pickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _recipeImage.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)saveChanges:(id)sender
{
    if([_nameTextField.text isEqualToString:@""] ||
       [_ingredientsTextView.text isEqualToString:@""] ||
       [_instructionsTextView.text isEqualToString:@""]
       )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields" message:@"Name, Ingredients and Instructions Are Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    NSError *error;
    Recipe *recipe;
    if(_isExistingRecipe) {
        recipe = [self.fetchController objectAtIndexPath:_currentlyEditing];
    } else {
        recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:_context];   
    }
    
    recipe.name = _nameTextField.text;
    recipe.ingredients = _ingredientsTextView.text;
    recipe.instructions = _instructionsTextView.text;
    recipe.image = UIImageJPEGRepresentation(_recipeImage.image, 0.0);
    recipe.category = _category;
    
    if(!_isExistingRecipe) {
        [_category addRecipiesObject:recipe];
    }
    
    if(![_context save:&error]){
        NSLog(@"Add/Update did not succeed: %@", error);
    }
    
    [self reinitFields];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)backButton:(id)sender {
    [self reinitFields];
    [self setEnabled];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)editButtonInteraction:(id)sender
{
    [self setEnabled];
}
@end
