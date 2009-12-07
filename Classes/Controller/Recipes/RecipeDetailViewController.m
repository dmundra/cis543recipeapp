//
//  RecipeDetailViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeDetailViewController.h"
#import "PickerSheetViewController.h"
#import "RecipeNameCategoryAndSourceEditorViewController.h"
#import "DescriptionEditorViewController.h"
#import "AddIngredientViewController.h"
#import "AddToShoppingCartViewController.h"
#import "InstructionsEditorViewController.h"
#import "PreparationMethod.h"
#import "PreppedIngredient.h"
#import "Recipe.h"
#import "RecipeImage.h"
#import "RecipeItem.h"
#import "Ingredient.h"
#import "Unit.h"


enum {
	RecipeDetailSectionInfo,
	RecipeDetailSectionAddIngredientsButton,
	RecipeDetailSectionIngredients,
	RecipeDetailSectionInstructions,
	RecipeDetailSectionCount
};

enum {
	InfoRowNameCategoryAndSource,
	InfoRowDescription,
	InfoRowCount,
	InfoRowServingSize,
	InfoRowPreparationTime,
};

enum {
	InstructionsRowInstructions,
	InstructionsRowCount
};

enum {
	ActionButtonIndexRemove,
	ActionButtonIndexTakePicture,
	ActionButtonIndexChoosePicture
};


@interface RecipeDetailViewController (/*Private*/)
- (void)_addIngredient;

- (NSInteger)_modifySectionIndex:(NSInteger)anIndex;

- (void)_updateRecipeImageNameCategoryAndSourceCell;
- (void)_updateRecipeDescriptionCell;
- (void)_updateRecipeInstructionsCell;

- (void)_updateVisibleCellsForEditMode;
@end


@implementation RecipeDetailViewController
#pragma mark Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		// Buttons for normal mode
		editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
		doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
		
		// Buttons for new recipe mode
		cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
		saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
		
		newRecipe = nil;
		resetForNewRecipe = YES;
	}
	
	return self;
}


#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	if(resetForNewRecipe) {
		if(recipe == nil) {
			if(newRecipe == nil) {
				newRecipe = [[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext] retain];
			}
			
			self.navigationItem.title = @"New Recipe";
			self.navigationItem.leftBarButtonItem = cancelButton;
			self.navigationItem.rightBarButtonItem = saveButton;
			recipeDetailTable.editing = YES;
		}
		else {
			recipeDetailTable.editing = NO;
			self.navigationItem.title = recipe.name;
			self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = editButton;
		}
		
		resetForNewRecipe = NO;
	}

	[self _updateRecipeImageNameCategoryAndSourceCell];
	[self _updateRecipeDescriptionCell];
	[self _updateRecipeInstructionsCell];

	[recipeDetailTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	self.recipeNameCategoryAndSourceEditorViewController.managedObjectContext = self.managedObjectContext;
	self.descriptionEditorViewController.managedObjectContext = self.managedObjectContext;
	self.addIngredientViewController.managedObjectContext = self.managedObjectContext;
	self.addToShoppingCartViewController.managedObjectContext = self.managedObjectContext;
	self.instructionsEditorViewController.managedObjectContext = self.managedObjectContext;
	
	servingsPickerSheetViewController = [[PickerSheetViewController alloc] init];
	servingsPickerSheetViewController.delegate = self;
	servingsPickerSheetViewController.pickerView.dataSource = self;
	servingsPickerSheetViewController.pickerView.delegate = self;
	
	prepTimePickerSheetViewController = [[PickerSheetViewController alloc] init];
	prepTimePickerSheetViewController.delegate = self;
	prepTimePickerSheetViewController.pickerView.dataSource = self;
	prepTimePickerSheetViewController.pickerView.delegate = self;
}


- (void)viewDidUnload {
	self.recipeDetailTable = nil;
	self.recipeImageNameCategoryAndSourceCell = nil;
	self.recipeImageView = nil;
	self.editImageButton = nil;
	self.addImageButton = nil;
	self.recipeNameLabel = nil;
	self.recipeCategoryAndSourceLabel = nil;
	self.recipeDescriptionCell = nil;
	self.descriptionTextLabel = nil;
	self.addToShoppingCartButtonCell = nil;
	self.recipeInstructionsCell = nil;
	self.instructionsLabel = nil;
	
	self.recipeNameCategoryAndSourceEditorViewController = nil;
	self.descriptionEditorViewController = nil;
	self.addIngredientViewController = nil;
	self.addToShoppingCartViewController = nil;
	self.instructionsEditorViewController = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[recipeDetailTable release];
	[recipeImageNameCategoryAndSourceCell release];
	[recipeImageView release];
	[editImageButton release];
	[addImageButton release];
	[recipeNameLabel release];
	[recipeCategoryAndSourceLabel release];
	[recipeDescriptionCell release];
	[descriptionTextLabel release];
	[addToShoppingCartButtonCell release];
	[recipeInstructionsCell release];
	[instructionsLabel release];
	
	[recipeNameCategoryAndSourceEditorViewController release];
	[descriptionEditorViewController release];
	[addIngredientViewController release];
	[addToShoppingCartViewController release];
	[instructionsEditorViewController release];
	
	[editButton release];
	[doneButton release];
	
	[cancelButton release];
	[saveButton release];
	
	[servingsPickerSheetViewController release];
	[prepTimePickerSheetViewController release];
	
	[recipe release];
	[newRecipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)edit:(id)sender {	
	[recipeDetailTable setEditing:YES animated:YES];
	
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	[recipeDetailTable beginUpdates];
	[recipeDetailTable deleteSections:[NSIndexSet indexSetWithIndex:RecipeDetailSectionAddIngredientsButton] withRowAnimation:UITableViewRowAnimationFade];
	[recipeDetailTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[sourceRecipe.recipeItems count] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
	[recipeDetailTable endUpdates];
	[recipeDetailTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	
	[self _updateVisibleCellsForEditMode];
	[self.navigationItem setRightBarButtonItem:doneButton animated:YES];
}


- (IBAction)done:(id)sender {
	[recipeDetailTable setEditing:NO animated:YES];
	
	
	if(singleEditMode) {
		singleEditMode = NO;
	}
	else {
		Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
		[recipeDetailTable beginUpdates];
		[recipeDetailTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[sourceRecipe.recipeItems count] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
		[recipeDetailTable insertSections:[NSIndexSet indexSetWithIndex:RecipeDetailSectionAddIngredientsButton] withRowAnimation:UITableViewRowAnimationFade];
		[recipeDetailTable endUpdates];

		[self _updateVisibleCellsForEditMode];
	}
	
	[self.navigationItem setRightBarButtonItem:editButton animated:YES];
}


- (IBAction)cancel:(id)sender {
	// Release the new recipe and rollback the changes to the context
	[newRecipe release];
	newRecipe = nil;
	
	resetForNewRecipe = YES;
	
	[self.managedObjectContext rollback];
	
	// Dismiss the modal view
	[self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction)save:(id)sender {
	// Save the new recipe then release it
	NSError* error;
	if(![self.managedObjectContext save:&error]) {
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
	
	[newRecipe release];
	newRecipe = nil;
	
	resetForNewRecipe = YES;
	
	// Dismiss the modal view
	[self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction)selectImage:(id)sender {
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Image" otherButtonTitles:@"Take A Picture", @"Choose A Picture", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[actionSheet release];
}


- (IBAction)addToCart:(id)sender {
	addToShoppingCartViewController.recipe = recipe;
	
	[self presentModalViewController:addToShoppingCartViewController animated:YES];
}


#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString* result = nil;
	
	NSInteger modifiedSection = [self _modifySectionIndex:section];
	if(modifiedSection == RecipeDetailSectionIngredients) {
		result = @"Ingredients:";
	}
	else if(modifiedSection == RecipeDetailSectionInstructions) {
		result = @"Instructions:";
	}
	
	return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	if(section == RecipeDetailSectionInfo) {
		if(indexPath.row == InfoRowNameCategoryAndSource) {
			result = recipeImageNameCategoryAndSourceCell;
		}
		else if(indexPath.row == InfoRowDescription) {
			result = recipeDescriptionCell;
		}
		else {
			result = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
			
			if(result == nil) {
				result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"InfoCell"] autorelease];
				result.accessoryType = UITableViewCellAccessoryNone;
				result.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		
			Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
			if(indexPath.row == InfoRowPreparationTime) {
				if([sourceRecipe.preparationTime integerValue] == kPreparationTimeNotSet) {
					result.detailTextLabel.textColor = [UIColor lightGrayColor];
				}
				else {
					result.detailTextLabel.textColor = [UIColor blackColor];
				}
				result.textLabel.text = @"prep time";
				result.detailTextLabel.text = NSStringFromPreparationTime(sourceRecipe.preparationTime);
			}
			else if(indexPath.row == InfoRowServingSize) {
				if([sourceRecipe.servingSize integerValue] == kServingSizeNotSet) {
					result.detailTextLabel.textColor = [UIColor lightGrayColor];
				}
				else {
					result.detailTextLabel.textColor = [UIColor blackColor];
				}
				result.textLabel.text = @"servings";
				result.detailTextLabel.text = NSStringFromServingSize(sourceRecipe.servingSize);
			}
		}
	}
	else if(section == RecipeDetailSectionAddIngredientsButton) {
		result = addToShoppingCartButtonCell;
	}
	else if(section == RecipeDetailSectionIngredients) {
		NSInteger ingredientIndex = indexPath.row;

		// If the table view is in editing mode, the last ingredient row will be an "Add ingredient..." row
		Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
		if(tableView.editing && !singleEditMode && ingredientIndex == [sourceRecipe.recipeItems count]) {
			result = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
			
			if(result == nil) {
				result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"] autorelease];
				result.accessoryType = UITableViewCellAccessoryNone;
				result.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			result.textLabel.text = @"Add Ingredient...";
		}
		else {
			result = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
			
			if(result == nil) {
				result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IngredientCell"] autorelease];
				result.accessoryType = UITableViewCellAccessoryNone;
				result.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			RecipeItem* recipeItem = (RecipeItem*)[recipe.sortedRecipeItems objectAtIndex:ingredientIndex];
			if(recipeItem.ingredient != nil) {
				result.textLabel.text = recipeItem.ingredient.name;
			}
			else {
				result.textLabel.text = [NSString stringWithFormat:@"%@ %@", recipeItem.preppedIngredient.preparationMethod.name, recipeItem.preppedIngredient.ingredient.name];
			}
			result.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity(recipeItem.quantity), NSStringFromUnit(recipeItem.unit)];
		}
	}
	else if(section == RecipeDetailSectionInstructions) {
		result = recipeInstructionsCell;
	}
	
	if(tableView.editing && !singleEditMode) {
		result.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	else {
		result.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return result;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger result = RecipeDetailSectionCount;
	
	if(recipe == nil || (recipe != nil && recipeDetailTable.editing && !singleEditMode)) {
		--result;
	}
	
	return result;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	
	NSInteger modifiedSection = [self _modifySectionIndex:section];
	if(modifiedSection == RecipeDetailSectionInfo) {
		result = InfoRowCount;
	}
	else if(modifiedSection == RecipeDetailSectionAddIngredientsButton) {
		result = 1;
	}
	else if(modifiedSection == RecipeDetailSectionIngredients) {
		if(recipe != nil) {
			result = [recipe.recipeItems count];
		}
		else {
			result = [newRecipe.recipeItems count];
		}

		// If in edit mode, an "Add ingredient..." row will be inserted at the top of the ingredients section
		if(tableView.editing && !singleEditMode) {
			++result;
		}
	}
	else if(modifiedSection == RecipeDetailSectionInstructions) {
		result = InstructionsRowCount;
	}
	
	return result;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	if(tableView.editing && !singleEditMode && section == RecipeDetailSectionIngredients && indexPath.row == [sourceRecipe.recipeItems count]) {
		[self _addIngredient];
	}
	else {
		RecipeItem* itemToRemove = [sourceRecipe.sortedRecipeItems objectAtIndex:indexPath.row];
		[sourceRecipe removeRecipeItemsObject:itemToRemove];
		[self.managedObjectContext deleteObject:itemToRemove];
		
		if(recipe != nil) {
			// Save the data
			NSError* error;
			if(![self.managedObjectContext save:&error]) {
				NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
				NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
				if(detailedErrors != nil && [detailedErrors count] > 0) {
					for(NSError* detailedError in detailedErrors) {
						NSLog(@"  DetailedError: %@", [detailedError userInfo]);
					}
				}
				else {
					NSLog(@"  %@", [error userInfo]);
				}
			}
		}
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


#pragma mark UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// Only indent the ingredients section
	BOOL result = NO;

	NSInteger section = [self _modifySectionIndex:indexPath.section];
	if(section == RecipeDetailSectionIngredients) {
		result = YES;
	}
	
	return result;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
	
	// Set an editing style if the section is the ingredients section
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	if(section == RecipeDetailSectionIngredients) {
		// If it is the last row and the table is in editing mode use the insert style for the "Add Ingredient..." line, otherwise use delete
		Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
		if(indexPath.row == [sourceRecipe.recipeItems count] && tableView.editing && !singleEditMode) {
			result = UITableViewCellEditingStyleInsert;
		}
		else {
			result = UITableViewCellEditingStyleDelete;
		}
	}
	
	return result;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect the selected index path
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Only allow selection in editing mode
	if(tableView.editing && !singleEditMode) {
		NSInteger section = [self _modifySectionIndex:indexPath.section];
		// Present the appropriate editor for the selected index path
		if(section == RecipeDetailSectionInfo) {
			if(indexPath.row == InfoRowNameCategoryAndSource) {
				// If we're dealing with a new recipe, the subview should not save the context
				if(recipe != nil) {
					self.recipeNameCategoryAndSourceEditorViewController.recipe = recipe;
					self.recipeNameCategoryAndSourceEditorViewController.shouldSaveChanges = YES;
				}
				else {
					self.recipeNameCategoryAndSourceEditorViewController.recipe = newRecipe;
					self.recipeNameCategoryAndSourceEditorViewController.shouldSaveChanges = NO;
				}
				
				// Push the view controller
				[((UINavigationController*)self.parentViewController) pushViewController:self.recipeNameCategoryAndSourceEditorViewController animated:YES];
			}
			else if(indexPath.row == InfoRowServingSize) {
				[servingsPickerSheetViewController showInWindow:self];
			}
			else if(indexPath.row == InfoRowPreparationTime) {
				[prepTimePickerSheetViewController showInWindow:self];
			}
			else if(indexPath.row == InfoRowDescription) {
				// If we're dealing with a new recipe, the subview should not save the context
				if(recipe != nil) {
					self.descriptionEditorViewController.recipe = recipe;
					self.descriptionEditorViewController.shouldSaveChanges = YES;
				}
				else {
					self.descriptionEditorViewController.recipe = newRecipe;
					self.descriptionEditorViewController.shouldSaveChanges = NO;
				}
				
				// Push the view controller
				[((UINavigationController*)self.parentViewController) pushViewController:self.descriptionEditorViewController animated:YES];
			}
		}
		else if(section == RecipeDetailSectionIngredients) {
			Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
			if(indexPath.row == [sourceRecipe.recipeItems count]) {
				[self _addIngredient];
			}
			else {
				// TODO: Modify Ingredient?
			}
		}
		else if(section == RecipeDetailSectionInstructions && indexPath.row == InstructionsRowInstructions) {
			// If we're dealing with a new recipe, the subview should not save the context
			if(recipe != nil) {
				self.instructionsEditorViewController.recipe = recipe;
				self.instructionsEditorViewController.shouldSaveChanges = YES;
			}
			else {
				self.instructionsEditorViewController.recipe = newRecipe;
				self.instructionsEditorViewController.shouldSaveChanges = NO;
			}
			
			// Push the view controller
			[((UINavigationController*)self.parentViewController) pushViewController:self.instructionsEditorViewController animated:YES];
		}
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat result = tableView.rowHeight;
	
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	if(section == RecipeDetailSectionInfo) {
		if(indexPath.row == InfoRowNameCategoryAndSource) {
			result = recipeImageNameCategoryAndSourceCell.frame.size.height;
		}
		else if(indexPath.row == InfoRowDescription) {
			result = recipeDescriptionCell.frame.size.height;
		}
	}
	if(section == RecipeDetailSectionInstructions && indexPath.row == InstructionsRowInstructions) {
		result = recipeInstructionsCell.frame.size.height;
	}
	
	return result;
}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationItem setRightBarButtonItem:doneButton animated:YES];
	
	singleEditMode = YES;
}


- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationItem setRightBarButtonItem:editButton animated:YES];
	
	singleEditMode = NO;
}


#pragma mark PickerSheetViewControllerDelegate
- (void)pickerSheetDidDismissWithCancel:(PickerSheetViewController*)pickerSheet {
	if(pickerSheet == servingsPickerSheetViewController) {
	}
	else if(pickerSheet == prepTimePickerSheetViewController) {
	}
}


- (void)pickerSheetDidDismissWithDone:(PickerSheetViewController*)pickerSheet {
	if(pickerSheet == servingsPickerSheetViewController) {
	}
	else if(pickerSheet == prepTimePickerSheetViewController) {
	}
}


#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	NSInteger result = 1;
	
	if(pickerView == servingsPickerSheetViewController.pickerView) {
	}
	else if(pickerView == prepTimePickerSheetViewController.pickerView) {
	}
	
	return result;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger result = 1;
	
	if(pickerView == servingsPickerSheetViewController.pickerView) {
	}
	else if(pickerView == prepTimePickerSheetViewController.pickerView) {
	}
	
	return result;
}


#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString* result = [NSString stringWithFormat:@"%d", row];
	
	if(pickerView == servingsPickerSheetViewController.pickerView) {
	}
	else if(pickerView == prepTimePickerSheetViewController.pickerView) {
	}
	
	return result;
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == ActionButtonIndexRemove) {
		Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
		if(sourceRecipe.image != nil) {
			[self.managedObjectContext deleteObject:sourceRecipe.image];
			sourceRecipe.image = nil;

			if(recipe != nil) {
				// Save the data
				NSError* error;
				if(![self.managedObjectContext save:&error]) {
					NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
					NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
					if(detailedErrors != nil && [detailedErrors count] > 0) {
						for(NSError* detailedError in detailedErrors) {
							NSLog(@"  DetailedError: %@", [detailedError userInfo]);
						}
					}
					else {
						NSLog(@"  %@", [error userInfo]);
					}
				}
			}
			
			[self _updateRecipeImageNameCategoryAndSourceCell];
		}
	}
	else if(buttonIndex == ActionButtonIndexTakePicture) {
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			imagePicker.editing = YES;
		
			[self presentModalViewController:imagePicker animated:YES];
		}
		else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Your device does not have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	else if(buttonIndex == ActionButtonIndexChoosePicture) {
		UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:imagePicker animated:YES];
	}
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);

	NSData* imageData;
	if(picker.sourceType == UIImagePickerControllerSourceTypeCamera && [info objectForKey:UIImagePickerControllerEditedImage] != nil) {
		imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.6);
	}
	else {
		imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.6);
	}
	
	if(sourceRecipe.image == nil) {
		sourceRecipe.image = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeImage" inManagedObjectContext:self.managedObjectContext];
	}
	sourceRecipe.image.data = imageData;
	
	if(recipe != nil) {
		// Save the data
		NSError* error;
		if(![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
		}
	}
	
	[self _updateRecipeImageNameCategoryAndSourceCell];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark Private
- (void)_addIngredient {
	// If we're dealing with a new recipe, the subview should not save the context
	if(recipe != nil) {
		self.addIngredientViewController.recipe = recipe;
		self.addIngredientViewController.shouldSaveChanges = YES;
	}
	else {
		self.addIngredientViewController.recipe = newRecipe;
		self.addIngredientViewController.shouldSaveChanges = NO;
	}
	
	// Push the view controller
	[((UINavigationController*)self.parentViewController) pushViewController:self.addIngredientViewController animated:YES];
}


#pragma mark Private (UI)
- (NSInteger)_modifySectionIndex:(NSInteger)anIndex {
	NSInteger result = anIndex;
	
	if(recipe == nil || (recipe != nil && recipeDetailTable.editing && !singleEditMode)) {
		if(anIndex > RecipeDetailSectionInfo) {
			++result;
		}
	}
	
	return result;
}


- (void)_updateRecipeImageNameCategoryAndSourceCell {
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	
	if(sourceRecipe.image == nil) {
		recipeImageView.image = [UIImage imageNamed:@"photoPlaceholder.png"];
		recipeImageView.backgroundColor = [UIColor whiteColor];
	}
	else {
		recipeImageView.image = [UIImage imageWithData:sourceRecipe.image.data];
		recipeImageView.backgroundColor = [UIColor blackColor];
	}
	recipeNameLabel.text = sourceRecipe.name;
	if([sourceRecipe.source length] > 0) {
		recipeCategoryAndSourceLabel.text = [NSString stringWithFormat:@"%@, %@", NSStringFromCategory(sourceRecipe.category), sourceRecipe.source];
	}
	else {
		recipeCategoryAndSourceLabel.text = NSStringFromCategory(sourceRecipe.category);
	}
	
	if(recipeDetailTable.editing) {
		recipeImageNameCategoryAndSourceCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		if(sourceRecipe.image == nil) {
			recipeImageView.hidden = YES;
			editImageButton.hidden = YES;
			addImageButton.hidden = NO;
		}
		else {
			recipeImageView.hidden = NO;
			editImageButton.hidden = NO;
			addImageButton.hidden = YES;
		}
	}
	else {
		recipeImageNameCategoryAndSourceCell.selectionStyle = UITableViewCellSelectionStyleNone;

		recipeImageView.hidden = NO;
		editImageButton.hidden = YES;
		addImageButton.hidden = YES;
	}
}


- (void)_updateRecipeDescriptionCell {
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	
	descriptionTextLabel.text = sourceRecipe.descriptionText;
	
	CGFloat height = recipeDetailTable.rowHeight;
	
	if([sourceRecipe.descriptionText length] > 0) {
		descriptionTextLabel.textColor = [UIColor blackColor];
		
		CGFloat textHeight = [sourceRecipe.descriptionText sizeWithFont:descriptionTextLabel.font constrainedToSize:CGSizeMake(descriptionTextLabel.frame.size.width, 1800.0) lineBreakMode:UILineBreakModeWordWrap].height + 20.0;
		if(textHeight > height) {
			height = textHeight;
		}
	}
	else {
		descriptionTextLabel.textColor = [UIColor lightGrayColor];
		descriptionTextLabel.text = @"No Description Set.";
	}
	
	recipeDescriptionCell.frame = CGRectMake(0.0, 0.0, 320.0, height);
}


- (void)_updateRecipeInstructionsCell {
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	
	instructionsLabel.text = sourceRecipe.instructions;
	
	CGFloat height = recipeDetailTable.rowHeight;
	
	if([sourceRecipe.instructions length] > 0) {
		instructionsLabel.textColor = [UIColor blackColor];
		
		CGFloat textHeight = [sourceRecipe.instructions sizeWithFont:instructionsLabel.font constrainedToSize:CGSizeMake(instructionsLabel.frame.size.width, 1800.0) lineBreakMode:UILineBreakModeWordWrap].height + 20.0;
		if(textHeight > height) {
			height = textHeight;
		}
	}
	else {
		instructionsLabel.textColor = [UIColor lightGrayColor];
		instructionsLabel.text = @"No Instructions Set.";
	}
	
	recipeInstructionsCell.frame = CGRectMake(0.0, 0.0, 320.0, height);
}


- (void)_updateVisibleCellsForEditMode {
	[self _updateRecipeImageNameCategoryAndSourceCell];
	
	for(UITableViewCell* cell in [recipeDetailTable visibleCells]) {
		cell.selectionStyle = (recipeDetailTable.editing ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone);
	}
}


#pragma mark Properties
@synthesize recipeDetailTable;
@synthesize recipeImageNameCategoryAndSourceCell;
@synthesize recipeImageView;
@synthesize editImageButton;
@synthesize addImageButton;
@synthesize recipeNameLabel;
@synthesize recipeCategoryAndSourceLabel;
@synthesize recipeDescriptionCell;
@synthesize descriptionTextLabel;
@synthesize addToShoppingCartButtonCell;
@synthesize recipeInstructionsCell;
@synthesize instructionsLabel;

@synthesize recipeNameCategoryAndSourceEditorViewController;
@synthesize descriptionEditorViewController;
@synthesize addIngredientViewController;
@synthesize addToShoppingCartViewController;
@synthesize instructionsEditorViewController;

@synthesize recipe;


- (void)setRecipe:(Recipe *)aRecipe {
	if(aRecipe != recipe) {
		[self willChangeValueForKey:@"recipe"];
		[aRecipe retain];
		[recipe release];
		recipe = aRecipe;
		[self didChangeValueForKey:@"recipe"];

		resetForNewRecipe = YES;
	}
}


@synthesize managedObjectContext;
@end
