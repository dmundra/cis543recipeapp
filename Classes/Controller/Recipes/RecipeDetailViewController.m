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
#import "IngredientEditorViewController.h"
#import "AddToShoppingCartViewController.h"
#import "InstructionsEditorViewController.h"
#import "PreparationMethod.h"
#import "PreppedIngredient.h"
#import "Recipe.h"
#import "RecipeImage.h"
#import "RecipeItem.h"
#import "Ingredient.h"
#import "Unit.h"


// Useful enums for table dimensions
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
	AddIngredientButtonRowButton,
	AddIngredientButtonRowCount
};

enum {
	InstructionsRowInstructions,
	InstructionsRowCount
};

// Enum for Action Sheet button index
enum {
	ActionButtonIndexRemove,
	ActionButtonIndexTakePicture,
	ActionButtonIndexChoosePicture
};


// Private method declarations
@interface RecipeDetailViewController (/*Private*/)
- (void)_addIngredient;

- (NSInteger)_modifySectionIndex:(NSInteger)anIndex;

- (void)_updateRecipeImageNameCategoryAndSourceCell;
- (void)_updateRecipeDescriptionCell;
- (void)_updateRecipeInstructionsCell;

- (void)_updateVisibleCellsForEditMode;
@end


// Class Implementation
@implementation RecipeDetailViewController
#pragma mark Initialization
/**
 * Constructor called when instance is initialized from a IB file
 */
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
/**
 * Update the view before it is displayed
 */
- (void)viewWillAppear:(BOOL)animated {
	// Only reset the state of the view if a new recipe has been assigned
	if(resetForNewRecipe) {
		// If we're being shown without a recipe set, assume new recipe mode
		if(recipe == nil) {
			
			// Only create a new recipe if one does not already exist (this way we don't clear the recipe when an editor view returns to us)
			if(newRecipe == nil) {
				newRecipe = [[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext] retain];
			}
			
			// Set the navigation item for new recipe mode
			self.navigationItem.title = @"New Recipe";
			self.navigationItem.leftBarButtonItem = cancelButton;
			self.navigationItem.rightBarButtonItem = saveButton;
			recipeDetailTable.editing = YES;
		}
		else {
			// Set the navigation item for normal recipe mode
			recipeDetailTable.editing = NO;
			self.navigationItem.title = @"Recipe Detail";
			self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = editButton;
		}
		
		resetForNewRecipe = NO;
	}

	// Update the UI to reflect the current state
	[self _updateRecipeImageNameCategoryAndSourceCell];
	[self _updateRecipeDescriptionCell];
	[self _updateRecipeInstructionsCell];

	[recipeDetailTable reloadData];
}


#pragma mark View Life Cycle
/**
 * Handle the view loading from the IB file
 */
- (void)viewDidLoad {
	self.recipeNameCategoryAndSourceEditorViewController.managedObjectContext = self.managedObjectContext;
	self.descriptionEditorViewController.managedObjectContext = self.managedObjectContext;
	self.ingredientEditorViewController.managedObjectContext = self.managedObjectContext;
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


/**
 * Handle the unloading of the view; This happens when a memory warning occurs and only when the view is not visible or in a view hierarchy.  The view objects
 * will be reloaded (and viewDidLoad will be invoked again) when the view is needed.  Release all IB assigned things here, or anything created in viewDidLoad.
 */
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
	self.ingredientEditorViewController = nil;
	self.addToShoppingCartViewController = nil;
	self.instructionsEditorViewController = nil;
}


#pragma mark Memory Management
/**
 * Release all resources
 */
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
	[ingredientEditorViewController release];
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
/**
 * Handle switching from normal mode to edit mode
 */
- (IBAction)edit:(id)sender {	
	// Set the table editing
	[recipeDetailTable setEditing:YES animated:YES];
	
	// Adjust the table view to hide the add ingredients button and show the add ingredient row in the ingredients section.  The modified section isn't used
	// here because we're in between normal/edit mode.  Make sure to use the correct recipe instance.
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	[recipeDetailTable beginUpdates];
	[recipeDetailTable deleteSections:[NSIndexSet indexSetWithIndex:RecipeDetailSectionAddIngredientsButton] withRowAnimation:UITableViewRowAnimationFade];
	[recipeDetailTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[sourceRecipe.recipeItems count] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
	[recipeDetailTable endUpdates];
	[recipeDetailTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	
	// Update cells to allow selection and change the nav bar button to done
	[self _updateVisibleCellsForEditMode];
	[self.navigationItem setRightBarButtonItem:doneButton animated:YES];
}


/**
 * Handle switching from edit mode to normal mode
 */
- (IBAction)done:(id)sender {
	// Set the table to not editing
	[recipeDetailTable setEditing:NO animated:YES];
	
	// Only adjust the table structure if we're not in single edit mode.  Single edit mode indicates someone did a horizontal swipe to delete in normal mode.
	if(singleEditMode) {
		singleEditMode = NO;
	}
	else {
		// Adjust the table view to show the add ingredients button and hide the add ingredient row in the ingredients section.  The modified section isn't used
		// here because we're in between normal/edit mode.  Make sure to use the correct recipe instance.
		Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
		[recipeDetailTable beginUpdates];
		[recipeDetailTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[sourceRecipe.recipeItems count] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
		[recipeDetailTable insertSections:[NSIndexSet indexSetWithIndex:RecipeDetailSectionAddIngredientsButton] withRowAnimation:UITableViewRowAnimationFade];
		[recipeDetailTable endUpdates];

		// Update cells to allow selection 
		[self _updateVisibleCellsForEditMode];
	}
	
	// Change the nav bar button to done
	[self.navigationItem setRightBarButtonItem:editButton animated:YES];
}


/**
 * Handle the cancel button in new recipe mode
 */
- (IBAction)cancel:(id)sender {
	// Reset the view state and rollback the changes to the context
	[newRecipe release];
	newRecipe = nil;
	
	resetForNewRecipe = YES;
	
	[self.managedObjectContext rollback];
	
	// Dismiss the modal view
	[self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
}


/**
 * Handle the save button in new recipe mode
 */
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
	
	// Reset the view state
	[newRecipe release];
	newRecipe = nil;
	
	resetForNewRecipe = YES;
	
	// Dismiss the modal view
	[self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
}


/**
 * Handle the add photo button in edit mode
 */
- (IBAction)selectImage:(id)sender {
	// Create an action sheet and display it that asks what the user wants to do
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Image" otherButtonTitles:@"Take A Picture", @"Choose A Picture", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[actionSheet release];
}


/**
 * Handle add ingredients to shopping cart 
 */
- (IBAction)addToCart:(id)sender {
	if([recipe.recipeItems count] > 0) {
		// Set the add to shopping cart view recipe and present it as a modal view
		addToShoppingCartViewController.recipe = recipe;
		
		[self presentModalViewController:addToShoppingCartViewController animated:YES];
	}
	else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"No Ingredients" message:@"Please add some recipe ingredients and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}


#pragma mark UITableViewDataSource
/**
 * Provides a header string for table view sections
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString* result = nil;
	
	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger modifiedSection = [self _modifySectionIndex:section];
	// Return the appropriate header for the section
	if(modifiedSection == RecipeDetailSectionIngredients) {
		result = @"Ingredients:";
	}
	else if(modifiedSection == RecipeDetailSectionInstructions) {
		result = @"Instructions:";
	}
	
	return result;
}


/**
 * Provides a cell for table view rows
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	// Return an appropriate cell for the indexPath (section and row)
	if(section == RecipeDetailSectionInfo) {
		if(indexPath.row == InfoRowNameCategoryAndSource) {
			result = recipeImageNameCategoryAndSourceCell;
		}
		else if(indexPath.row == InfoRowDescription) {
			result = recipeDescriptionCell;
		}
		else {
			// Prep time and serving size cells are displayed using a Value2 style cell, which shows the name of the field on the left
			// and the data on the right (similar to the address book)
			result = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
			
			if(result == nil) {
				result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"InfoCell"] autorelease];
				result.accessoryType = UITableViewCellAccessoryNone;
				result.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		
			// Set the content of the cell appropriately based on the row index, make sure to use the correct recipe instance
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
		// Each ingredient is presented in a row of its own using a Subtitle style cell.  The ingredient name is presented as the main text
		// with the quantity and unit presented as a subtitle.  Additionally the row of the section is a simple cell allowing the user to tap to add
		// an ingredient when the table is in edit mode
		NSInteger ingredientIndex = indexPath.row;

		// Make sure we use the correct recipe instance
		Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
		// If the table view is in editing mode, the last ingredient row will be an "Add ingredient..." row to allow for adding a new ingredient
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
			// Create a subtitle style cell and set the ingredient data for display
			result = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
			
			if(result == nil) {
				result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IngredientCell"] autorelease];
				result.accessoryType = UITableViewCellAccessoryNone;
				result.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			RecipeItem* recipeItem = (RecipeItem*)[sourceRecipe.sortedRecipeItems objectAtIndex:ingredientIndex];
			if(recipeItem.ingredient != nil) {
				result.textLabel.text = recipeItem.ingredient.name;
			}
			else {
				result.textLabel.text = [NSString stringWithFormat:@"%@ %@", recipeItem.preppedIngredient.preparationMethod.name, recipeItem.preppedIngredient.ingredient.name];
			}
			if([recipeItem.quantity doubleValue] < 0) {
				result.detailTextLabel.text = NSStringFromQuantity(recipeItem.quantity);
			}
			else {
				result.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity(recipeItem.quantity), NSStringFromUnit(recipeItem.unit)];
			}
		}
	}
	else if(section == RecipeDetailSectionInstructions) {
		result = recipeInstructionsCell;
	}
	
	// If we're editing (and not in single edit mode) make the cells selectable, otherwise make them not selectable
	if(tableView.editing && !singleEditMode) {
		result.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	else {
		result.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return result;
}


/**
 * Returns the number of sections in the table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger result = RecipeDetailSectionCount;
	
	// If we're adding a new recipe or in edit mode for an existing recipe, we don't want to show the add ingredients button
	if(recipe == nil || (recipe != nil && recipeDetailTable.editing && !singleEditMode)) {
		--result;
	}
	
	return result;
}


/**
 * Returns the number of rows in the specified table view section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	
	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger modifiedSection = [self _modifySectionIndex:section];
	// Use the various enum constants defined above to return the correct value
	if(modifiedSection == RecipeDetailSectionInfo) {
		result = InfoRowCount;
	}
	else if(modifiedSection == RecipeDetailSectionAddIngredientsButton) {
		result = AddIngredientButtonRowCount;
	}
	else if(modifiedSection == RecipeDetailSectionIngredients) {
		// Make sure to use the correct recipe instance
		if(recipe != nil) {
			result = [recipe.recipeItems count];
		}
		else {
			result = [newRecipe.recipeItems count];
		}

		// If in edit mode, an "Add ingredient..." row will be inserted at the bottom of the ingredients section
		if(tableView.editing && !singleEditMode) {
			++result;
		}
	}
	else if(modifiedSection == RecipeDetailSectionInstructions) {
		result = InstructionsRowCount;
	}
	
	return result;
}


/**
 * Handles the user tapping on the editing style (the + or - widget to the right of a table row while in edit mode, or a confirmed swipe to delete
 * gesture when not in edit mode).
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	// Make sure to handle the correct recipe instance
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	// If the row is the last row and we're editing, add a new ingredient
	if(tableView.editing && !singleEditMode && section == RecipeDetailSectionIngredients && indexPath.row == [sourceRecipe.recipeItems count]) {
		[self _addIngredient];
	}
	else {
		// Delete the ingredient at the index specified
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
		
		// Delete the row from the table to reflect the data changes
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


#pragma mark UITableViewDelegate
/**
 * Returns whether or not a particular row should be indented while the table is in editing mode
 */
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL result = NO;

	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	// Only indent the ingredients section
	if(section == RecipeDetailSectionIngredients) {
		result = YES;
	}
	
	return result;
}


/**
 * Returns the editing style for a particular index path (the + or - while the user is in edit mode, or if a swipe to delete gesture is allowed
 * when not in edit mode)
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
	
	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	// Set an editing style if the section is the ingredients section
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


/**
 * Processes a user selecting a row in the table
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect the selected index path
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Only allow selection in editing mode
	if(tableView.editing && !singleEditMode) {
		// Get the modified section value, which will be the correct enum value based on the state of the table
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
				// If we're dealing with a new recipe, the subview should not save the context
				if(recipe != nil) {
					self.ingredientEditorViewController.recipeItem = [recipe.sortedRecipeItems objectAtIndex:indexPath.row];
					self.ingredientEditorViewController.shouldSaveChanges = YES;
				}
				else {
					self.ingredientEditorViewController.recipeItem = [newRecipe.sortedRecipeItems objectAtIndex:indexPath.row];
					self.ingredientEditorViewController.shouldSaveChanges = NO;
				}
				
				// Push the view controller
				[((UINavigationController*)self.parentViewController) pushViewController:self.ingredientEditorViewController animated:YES];
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


/**
 * Returns the height for a row in the table view
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat result = tableView.rowHeight;
	
	// Get the modified section value, which will be the correct enum value based on the state of the table
	NSInteger section = [self _modifySectionIndex:indexPath.section];
	// If the row corresponds to a row with a dynamic height, return the height of the cell
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
		self.ingredientEditorViewController.recipe = recipe;
		self.ingredientEditorViewController.orderIndex = [recipe.recipeItems count];
		self.ingredientEditorViewController.recipeItem = nil;
		self.ingredientEditorViewController.shouldSaveChanges = YES;
	}
	else {
		self.ingredientEditorViewController.recipe = newRecipe;
		self.ingredientEditorViewController.orderIndex = [newRecipe.recipeItems count];
		self.ingredientEditorViewController.recipeItem = nil;
		self.ingredientEditorViewController.shouldSaveChanges = NO;
	}
	
	// Push the view controller
	[((UINavigationController*)self.parentViewController) pushViewController:self.ingredientEditorViewController animated:YES];
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
@synthesize ingredientEditorViewController;
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
