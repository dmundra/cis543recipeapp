//
//  AddToShoppingCartViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AddToShoppingCartViewController.h"
#import "Recipe.h"
#import "RecipeItem.h"
#import "ShoppingListItem.h"
#import "PreppedIngredient.h"
#import "Ingredient.h"
#import "PreparationMethod.h"
#import "Unit.h"


@implementation AddToShoppingCartViewController
#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	[selectedState removeAllObjects];
	
	// Set the selected state to true for all recipe items initially
	for(int index = 0; index < [recipe.recipeItems count]; ++index) {
		[selectedState addObject:[NSNumber numberWithBool:YES]];
	}
	selectedRowCount = [selectedState count];
	
	[addToCartTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	selectedState = [[NSMutableArray alloc] init];
}


- (void)viewDidUnload {
	[selectedState removeAllObjects];
	[selectedState release];
	selectedState = nil;
	
	self.addToCartTable = nil;
	self.addButton = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[addToCartTable release];
	[addButton release];
	
	[recipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)addToCart:(id)sender {
	NSArray* recipeItems = recipe.sortedRecipeItems;

	for(int index = 0; index < [selectedState count]; ++index) {
		BOOL selected = [[selectedState objectAtIndex:index] boolValue];
		if(selected) {
			RecipeItem* recipeItem = [recipeItems objectAtIndex:index];
			ShoppingListItem* listItem = [NSEntityDescription insertNewObjectForEntityForName:@"ShoppingListItem" inManagedObjectContext:managedObjectContext];
			
			if(recipeItem.ingredient == nil) {
				listItem.ingredient = recipeItem.preppedIngredient.ingredient;
			}
			else {
				listItem.ingredient = recipeItem.ingredient;
			}
			listItem.quantity = recipeItem.quantity;
			listItem.unit = recipeItem.unit;
			listItem.recipe = recipe;
		}
	}
	
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
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	result = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
	
	if(result == nil) {
		result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IngredientCell"] autorelease];
		result.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	RecipeItem* recipeItem = (RecipeItem*)[recipe.sortedRecipeItems objectAtIndex:indexPath.row];
	if(recipeItem.ingredient != nil) {
		result.textLabel.text = recipeItem.ingredient.name;
	}
	else {
		result.textLabel.text = [NSString stringWithFormat:@"%@ %@", recipeItem.preppedIngredient.preparationMethod.name, recipeItem.preppedIngredient.ingredient.name];
	}
	result.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity(recipeItem.quantity), NSStringFromUnit(recipeItem.unit)];
	
	if([[selectedState objectAtIndex:indexPath.row] boolValue]) {
		result.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		result.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return result;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [recipe.recipeItems count];
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Flip the selected value and update the accessory on the cell
	BOOL newState = ![[selectedState objectAtIndex:indexPath.row] boolValue];
	[selectedState replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:newState]];
	
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	if(newState) {
		++selectedRowCount;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		--selectedRowCount;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	addButton.enabled = selectedRowCount > 0;
}


#pragma mark Properties
@synthesize addToCartTable;
@synthesize addButton;

@synthesize recipe;

@synthesize managedObjectContext;
@end
