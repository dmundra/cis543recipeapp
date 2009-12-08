//
//  IngredientEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "IngredientEditorViewController.h"
#import "Recipe.h"
#import "Unit.h"


enum {
	IngredientSectionQuantityUnitButtons,
	IngredientSectionQuantityUnit,
	IngredientSectionPrepMethodIngredientButtons,
	IngredientSectionPreppedIngredient,
	IngredientSectionCount
};

enum {
	QuantityPickerComponentHundreds,
	QuantityPickerComponentTens,
	QuantityPickerComponentOnes,
	QuantityPickerComponentDecimal,
	QuantityPickerComponentCount
};


@interface IngredientEditorViewController (/*Private*/)
- (void)_updateQuantityUnitCell;
- (void)_updatePreppedIngredientCell;
@end


@implementation IngredientEditorViewController
#pragma mark Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		self.navigationItem.title = @"Edit Ingredient";
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
	}
	
	return self;
}


#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	[self _updateQuantityUnitCell];
	[self _updatePreppedIngredientCell];
	
	[ingredientTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	quantityPickerSheetViewController = [[PickerSheetViewController alloc] init];
	quantityPickerSheetViewController.delegate = self;
	quantityPickerSheetViewController.pickerView.dataSource = self;
	quantityPickerSheetViewController.pickerView.delegate = self;
	unitPickerSheetViewController = [[PickerSheetViewController alloc] init];
	unitPickerSheetViewController.delegate = self;
	unitPickerSheetViewController.pickerView.dataSource = self;
	unitPickerSheetViewController.pickerView.delegate = self;
}


- (void)viewDidUnload {
	self.ingredientTable = nil;
	self.changeUnitQuantityButtonsCell = nil;
	self.unitQuantityCell = nil;
	self.unitQuantityLabel = nil;
	self.prepMethodIngredientButtonsCell = nil;
	self.preppedIngredientCell = nil;
	self.preppedIngredientLabel = nil;
	
	[quantityPickerSheetViewController release];
	quantityPickerSheetViewController = nil;
	[unitPickerSheetViewController release];
	unitPickerSheetViewController = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[ingredientTable release];
	[changeUnitQuantityButtonsCell release];
	[unitQuantityCell release];
	[unitQuantityLabel release];
	[prepMethodIngredientButtonsCell release];
	[preppedIngredientCell release];
	[preppedIngredientLabel release];
	
	[quantityPickerSheetViewController release];
	[unitPickerSheetViewController release];
	
	[recipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)done:(id)sender {
	[((UINavigationController*)self.parentViewController) popViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[((UINavigationController*)self.parentViewController) popViewControllerAnimated:YES];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	if(indexPath.section == IngredientSectionQuantityUnitButtons) {
		result = changeUnitQuantityButtonsCell;
	}
	else if(indexPath.section == IngredientSectionQuantityUnit) {
		result = unitQuantityCell;
	}
	else if(indexPath.section == IngredientSectionPrepMethodIngredientButtons) {
		result = prepMethodIngredientButtonsCell;
	}
	else if(indexPath.section == IngredientSectionPreppedIngredient) {
		result = preppedIngredientCell;
	}
	
	return result;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return IngredientSectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString* result = nil;
	
	if(section == IngredientSectionPrepMethodIngredientButtons) {
		result = @" ";
	}
	
	return result;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat result = tableView.rowHeight;
	
	if(indexPath.section == IngredientSectionQuantityUnitButtons) {
		result = changeUnitQuantityButtonsCell.frame.size.height;
	}
	else if(indexPath.section == IngredientSectionPrepMethodIngredientButtons) {
		result = prepMethodIngredientButtonsCell.frame.size.height;
	}
	
	return result;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	CGFloat result = tableView.sectionHeaderHeight;
	
	if(section == IngredientSectionPrepMethodIngredientButtons) {
		result = 34.0;
	}
	
	return result;
}


#pragma mark PickerSheetViewControllerDelegate
- (void)pickerSheetDidDismissWithCancel:(PickerSheetViewController*)pickerSheet {
	// Nothing to do here
}


- (void)pickerSheetDidDismissWithDone:(PickerSheetViewController*)pickerSheet {
	if(pickerSheet == quantityPickerSheetViewController) {
	}
	else if(pickerSheet == unitPickerSheetViewController) {
	}
}


#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	NSInteger result = 0;

	if(pickerView == quantityPickerSheetViewController.pickerView) {
		result = QuantityPickerComponentCount;
	}
	else if(pickerView == unitPickerSheetViewController.pickerView) {
		result = 1;
	}
	
	return result;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger result = 0;

	if(pickerView == quantityPickerSheetViewController.pickerView) {
		if(component == QuantityPickerComponentOnes) {
			result = 10;
		}
		else if(component == QuantityPickerComponentTens) {
			result = 10;
		}
		else if(component == QuantityPickerComponentHundreds) {
			result = 10;
		}
		else if(component == QuantityPickerComponentDecimal) {
			result = 20;
		}
	}
	else if(pickerView == unitPickerSheetViewController.pickerView) {
		result = UnitCount;
	}
	
	return result;
}


#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString* result = nil;

	if(pickerView == quantityPickerSheetViewController.pickerView) {
		if(component == QuantityPickerComponentOnes) {
			result = [NSString stringWithFormat:@"%d", row];
		}
		else if(component == QuantityPickerComponentTens) {
			result = [NSString stringWithFormat:@"%d", row];
		}
		else if(component == QuantityPickerComponentHundreds) {
			result = [NSString stringWithFormat:@"%d", row];
		}
		else if(component == QuantityPickerComponentDecimal) {
			result = [NSString stringWithFormat:@"%d", row];
		}
	}
	else if(pickerView == unitPickerSheetViewController.pickerView) {
		result = NSStringFromUnit([NSNumber numberWithInteger:row]);
	}
	
	return result;
}


#pragma mark Private
- (void)_updateQuantityUnitCell {
}


- (void)_updatePreppedIngredientCell {
}


#pragma mark Properties
@synthesize ingredientTable;
@synthesize changeUnitQuantityButtonsCell;
@synthesize unitQuantityCell;
@synthesize unitQuantityLabel;
@synthesize prepMethodIngredientButtonsCell;
@synthesize preppedIngredientCell;
@synthesize preppedIngredientLabel;

@synthesize recipe;

@synthesize shouldSaveChanges;
@synthesize managedObjectContext;
@end
