//
//  RecipeDetailViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeDetailViewController.h"
#import "RecipeNameCategoryAndSourceEditorViewController.h"
#import "PreparationMethod.h"
#import "PreppedIngredient.h"
#import "Recipe.h"
#import "RecipeImage.h"
#import "RecipeItem.h"
#import "Ingredient.h"
#import "Unit.h"


enum {
	RecipeDetailSectionInfo,
	RecipeDetailSectionIngredients,
	RecipeDetailSectionInstructions,
	RecipeDetailSectionCount
};


enum {
	InfoRowNameCategoryAndSource,
	InfoRowServingSize,
	InfoRowPreparationTime,
	InfoRowDescription,
	InfoRowCount
};

enum {
	InstructionsRowInstructions,
	InstructionsRowCount
};


@interface RecipeDetailViewController (/*Private*/)
- (void)_addIngredient;

- (void)_updateRecipeImageNameCategoryAndSourceCell;
- (void)_updateRecipeDescriptionCell;
- (void)_updateRecipeInstructionsCell;
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
	}
	
	return self;
}


#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
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
		self.navigationItem.title = recipe.name;
		self.navigationItem.leftBarButtonItem = nil;
		self.navigationItem.rightBarButtonItem = editButton;
		recipeDetailTable.editing = NO;
	}
	
	[self _updateRecipeImageNameCategoryAndSourceCell];
	[self _updateRecipeDescriptionCell];
	[self _updateRecipeInstructionsCell];

	[recipeDetailTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	self.recipeNameCategoryAndSourceEditorViewController.managedObjectContext = self.managedObjectContext;
}


- (void)viewDidUnload {
	self.recipeDetailTable = nil;
	self.recipeImageNameCategoryAndSourceCell = nil;
	self.recipeImageView = nil;
	self.recipeNameLabel = nil;
	self.recipeCategoryAndSourceLabel = nil;
	self.recipeDescriptionCell = nil;
	self.descriptionTextLabel = nil;
	self.recipeInstructionsCell = nil;
	self.instructionsLabel = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[recipeDetailTable release];
	[recipeImageNameCategoryAndSourceCell release];
	[recipeImageView release];
	[recipeNameLabel release];
	[recipeCategoryAndSourceLabel release];
	[recipeDescriptionCell release];
	[descriptionTextLabel release];
	[recipeInstructionsCell release];
	[instructionsLabel release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)edit:(id)sender {
	
}


- (IBAction)done:(id)sender {
}


- (IBAction)cancel:(id)sender {
	[newRecipe release];
	newRecipe = nil;
	
	[self.managedObjectContext rollback];
	
	[self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction)save:(id)sender {
}


#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString* result = nil;
	
	if(section == RecipeDetailSectionIngredients) {
		result = @"Ingredients:";
	}
	else if(section == RecipeDetailSectionInstructions) {
		result = @"Instructions:";
	}
	
	return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	if(indexPath.section == RecipeDetailSectionInfo) {
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
	else if(indexPath.section == RecipeDetailSectionIngredients) {
		NSInteger ingredientIndex = indexPath.row;

		// If the table view is in editing mode, the first ingredient row will be an "Add ingredient..." row
		if(tableView.editing) {
			--ingredientIndex;
			if(ingredientIndex == -1) {
				result = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
				
				if(result == nil) {
					result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"] autorelease];
					result.accessoryType = UITableViewCellAccessoryNone;
					result.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
				
				result.textLabel.text = @"Add Ingredient...";
			}
		}
		
		if(ingredientIndex >= 0) {
			result = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
			
			if(result == nil) {
				result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RecipeCell"] autorelease];
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
	else if(indexPath.section == RecipeDetailSectionInstructions) {
		result = recipeInstructionsCell;
	}
	
	if(tableView.editing) {
		result.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	else {
		result.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return result;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return RecipeDetailSectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	
	if(section == RecipeDetailSectionInfo) {
		result = InfoRowCount;
	}
	else if(section == RecipeDetailSectionIngredients) {
		if(recipe != nil) {
			result = [recipe.recipeItems count];
		}
		else {
			result = [newRecipe.recipeItems count];
		}

		// If in edit mode, an "Add ingredient..." row will be inserted at the top of the ingredients section
		if(tableView.editing) {
			++result;
		}
	}
	else if(section == RecipeDetailSectionInstructions) {
		result = InstructionsRowCount;
	}
	
	return result;
}


#pragma mark UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// Only indent the ingredients section
	BOOL result = NO;

	if(indexPath.section == RecipeDetailSectionIngredients) {
		result = YES;
	}
	
	return result;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
	
	// Set an editing style if the section is the ingredients section
	if(indexPath.section == RecipeDetailSectionIngredients) {
		// If the row is 0 use the insert style for the "Add Ingredient..." line, otherwise use delete
		if(indexPath.row == 0) {
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
	
	// Present the appropriate editor for the selected index path
	if(indexPath.section == RecipeDetailSectionInfo && indexPath.row == InfoRowNameCategoryAndSource) {
		// If we're dealing with a new recipe, the subview should not save the context
		if(recipe != nil) {
			self.recipeNameCategoryAndSourceEditorViewController.shouldSaveChanges = YES;
		}
		else {
			self.recipeNameCategoryAndSourceEditorViewController.shouldSaveChanges = NO;
		}
		
		self.recipeNameCategoryAndSourceEditorViewController.recipe = (recipe == nil ? newRecipe : recipe);
		
		[((UINavigationController*)self.parentViewController) pushViewController:self.recipeNameCategoryAndSourceEditorViewController animated:YES];
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat result = tableView.rowHeight;
	
	if(indexPath.section == RecipeDetailSectionInfo) {
		if(indexPath.row == InfoRowNameCategoryAndSource) {
			result = recipeImageNameCategoryAndSourceCell.frame.size.height;
		}
		else if(indexPath.row == InfoRowDescription) {
			result = recipeDescriptionCell.frame.size.height;
		}
	}
	if(indexPath.section == RecipeDetailSectionInstructions && indexPath.row == InstructionsRowInstructions) {
		result = recipeInstructionsCell.frame.size.height;
	}
	
	return result;
}


#pragma mark Private
- (void)_addIngredient {
}


#pragma mark Private (UI)
- (void)_updateRecipeImageNameCategoryAndSourceCell {
	Recipe* sourceRecipe = (recipe == nil ? newRecipe : recipe);
	
	if(sourceRecipe.image == nil) {
		recipeImageView.image = [UIImage imageNamed:@"emptyImageView.png"];
	}
	else {
		recipeImageView.image = [UIImage imageWithData:sourceRecipe.image.data];
	}
	recipeNameLabel.text = sourceRecipe.name;
	if([sourceRecipe.source length] > 0) {
		recipeCategoryAndSourceLabel.text = [NSString stringWithFormat:@"%@, %@", NSStringFromCategory(sourceRecipe.category), sourceRecipe.source];
	}
	else {
		recipeCategoryAndSourceLabel.text = NSStringFromCategory(sourceRecipe.category);
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


#pragma mark Properties
@synthesize recipeDetailTable;
@synthesize recipeImageNameCategoryAndSourceCell;
@synthesize recipeImageView;
@synthesize recipeNameLabel;
@synthesize recipeCategoryAndSourceLabel;
@synthesize recipeDescriptionCell;
@synthesize descriptionTextLabel;
@synthesize recipeInstructionsCell;
@synthesize instructionsLabel;

@synthesize recipeNameCategoryAndSourceEditorViewController;

@synthesize recipe;


- (void)setRecipe:(Recipe *)aRecipe {
	[self willChangeValueForKey:@"recipe"];
	[aRecipe retain];
	[recipe release];
	recipe = aRecipe;
	[self didChangeValueForKey:@"recipe"];
}


@synthesize managedObjectContext;
@end
