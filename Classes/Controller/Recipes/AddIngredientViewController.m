//
//  AddIngredientViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AddIngredientViewController.h"
#import "Recipe.h"
#import "Unit.h"


enum {
	IngredientRowUnitQuantity,
	IngredientRowPreparationMethod,
	IngredientRowIngredient,
	IngredientRowCount
};

enum {
	PickerComponentQuantityInteger,
	PickerComponentQuantityFraction,
	PickerComponentUnit,
	PickerComponentCount
};


@interface AddIngredientViewController (/*Private*/)
- (void)_updateUnitQuantityCell;
- (void)_updatePrepMethodCell;
- (void)_updateIngredientCell;
@end


@implementation AddIngredientViewController
#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	[self _updateUnitQuantityCell];
	[self _updatePrepMethodCell];
	[self _updateIngredientCell];
	
	[ingredientTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	pickerSheetViewController = [[PickerSheetViewController alloc] init];
	pickerSheetViewController.delegate = self;
	pickerSheetViewController.pickerView.dataSource = self;
	pickerSheetViewController.pickerView.delegate = self;
}


- (void)viewDidUnload {
	self.ingredientTable = nil;
	self.unitQuantityCell = nil;
	self.unitQuantityLabel = nil;
	self.prepMethodCell = nil;
	self.preparationMethodLabel = nil;
	self.ingredientCell = nil;
	self.ingredientLabel = nil;
	
	[pickerSheetViewController release];
	pickerSheetViewController = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[ingredientTable release];
	[unitQuantityCell release];
	[unitQuantityLabel release];
	[prepMethodCell release];
	[preparationMethodLabel release];
	[ingredientCell release];
	[ingredientLabel release];
	
	[pickerSheetViewController release];
	
	[recipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = nil;
	
	if(indexPath.row == IngredientRowUnitQuantity) {
		cell = unitQuantityCell;
	}
	else if(indexPath.row == IngredientRowPreparationMethod) {
		cell = prepMethodCell;
	}
	else if(indexPath.row == IngredientRowIngredient) {
		cell = ingredientCell;
	}
	
	return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = IngredientRowCount;
	
	return result;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == IngredientRowUnitQuantity) {
		[pickerSheetViewController showInWindow:self];
	}
	else if(indexPath.row == IngredientRowPreparationMethod) {
		// TODO: Show some view to pick this
	}
	else if(indexPath.row == IngredientRowIngredient) {
		// TODO: Show some view to pick this
	}
}


#pragma mark PickerSheetViewControllerDelegate
- (void)pickerSheetDidDismissWithCancel:(PickerSheetViewController*)pickerSheet {
	// Nothing to do here
}


- (void)pickerSheetDidDismissWithDone:(PickerSheetViewController*)pickerSheet {
	// TODO: Update values and save as appropriate
}


#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return PickerComponentCount;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger result = 0;
	
	if(component == PickerComponentQuantityInteger) {
		// TODO: How many of these are we supporting? 0 - 99?
	}
	else if(component == PickerComponentQuantityFraction) {
		// TODO: How many of these are we supporting? 0.0 - 0.95 in increments of 0.05?
	}
	else if(component == PickerComponentUnit) {
		result = UnitCount;
	}
	
	return result;
}


#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString* result = nil;
	
	if(component == PickerComponentQuantityInteger) {
		result = [NSString stringWithFormat:@"%d", row];
	}
	else if(component == PickerComponentQuantityFraction) {
		// TODO: Translate the row into the displayed value
	}
	else if(component == PickerComponentUnit) {
		result = NSStringFromUnit([NSNumber numberWithInteger:row]);
	}
	
	return result;
}


#pragma mark Private
- (void)_updateUnitQuantityCell {
	// TODO: Update the values of the unitQuantityLabel
}


- (void)_updatePrepMethodCell {
	// TODO: Update the values of the preparationMethodLabel
}


- (void)_updateIngredientCell {
	// TODO: Update the values of the ingredient label
}


#pragma mark Properties
@synthesize ingredientTable;
@synthesize unitQuantityCell;
@synthesize unitQuantityLabel;
@synthesize prepMethodCell;
@synthesize preparationMethodLabel;
@synthesize ingredientCell;
@synthesize ingredientLabel;

@synthesize recipe;

@synthesize shouldSaveChanges;
@synthesize managedObjectContext;
@end
