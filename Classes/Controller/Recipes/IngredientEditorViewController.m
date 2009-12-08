//
//  IngredientEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "IngredientEditorViewController.h"
#import "PrepMethodSearchOrCreateViewController.h"
#import "IngredientSearchOrCreateViewController.h"
#import "RecipeItem.h"
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
- (void)_updateUnitQuantityLabel;

@property(nonatomic, retain, readonly) RecipeItem* _recipeItemToEdit;
@end


static NSNumberFormatter* numberFormatter;


@implementation IngredientEditorViewController
#pragma mark Initialization
+ (void)initialize {
	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumIntegerDigits:0];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		self.navigationItem.title = @"Edit Ingredient";
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];

		resetForNewRecipeItem = YES;
	}
	
	return self;
}


#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	// Only reset the state of the view if a new recipe item has been assigned
	if(resetForNewRecipeItem) {
		// If we're being shown without a recipe item set, assume add recipe item mode
		if(recipeItem == nil) {
			
			// Only create a new recipe item if one does not already exist (this way we don't clear the recipe item when an editor view returns to us)
			if(newRecipeItem == nil) {
				newRecipeItem = [[NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext] retain];
			}
			
			// Set the navigation item for new recipe mode
			self.navigationItem.title = @"Add Ingredient";
		}
		else {
			// Set the navigation item for normal recipe mode
			self.navigationItem.title = @"Edit Ingredient";
		}
		
		resetForNewRecipeItem = NO;
	}
	
	// Update the UI to reflect the current state
	[self _updateQuantityUnitCell];
	[self _updatePreppedIngredientCell];
	[self _updateUnitQuantityLabel];
	
	[ingredientTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	ingredientSearchOrCreateViewController.managedObjectContext = self.managedObjectContext;
	prepMethodSearchOrCreateViewController.managedObjectContext = self.managedObjectContext;
	
	quantityPickerSheetViewController = [[PickerSheetViewController alloc] init];
	quantityPickerSheetViewController.delegate = self;
	quantityPickerSheetViewController.pickerView.dataSource = self;
	quantityPickerSheetViewController.pickerView.delegate = self;
	quantityPickerSheetViewController.pickerView.showsSelectionIndicator = YES;
	unitPickerSheetViewController = [[PickerSheetViewController alloc] init];
	unitPickerSheetViewController.delegate = self;
	unitPickerSheetViewController.pickerView.dataSource = self;
	unitPickerSheetViewController.pickerView.delegate = self;
	unitPickerSheetViewController.pickerView.showsSelectionIndicator = YES;
}


- (void)viewDidUnload {
	self.ingredientTable = nil;
	self.changeUnitQuantityButtonsCell = nil;
	self.unitQuantityCell = nil;
	self.unitQuantityLabel = nil;
	self.prepMethodIngredientButtonsCell = nil;
	self.preppedIngredientCell = nil;
	self.preppedIngredientLabel = nil;
	
	self.ingredientSearchOrCreateViewController = nil;
	self.prepMethodSearchOrCreateViewController = nil;
	
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
	
	[ingredientSearchOrCreateViewController release];
	[prepMethodSearchOrCreateViewController release];
	
	[quantityPickerSheetViewController release];
	[unitPickerSheetViewController release];
	
	[recipeItem release];
	[newRecipeItem release];
	
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


- (IBAction)pickQuantity:(id)sender {
	double quantity = [self._recipeItemToEdit.quantity doubleValue];
	NSInteger hundreds =  (int)quantity / 100;
	NSInteger tens = ((int)quantity / 10) % 10;
	NSInteger ones = ((int)quantity % 10);
	NSInteger decimals = ((int)round(quantity * 100.0) % 100) / 5;
	[quantityPickerSheetViewController.pickerView selectRow:hundreds inComponent:QuantityPickerComponentHundreds animated:NO];
	[quantityPickerSheetViewController.pickerView selectRow:tens inComponent:QuantityPickerComponentTens animated:NO];
	[quantityPickerSheetViewController.pickerView selectRow:ones inComponent:QuantityPickerComponentOnes animated:NO];
	[quantityPickerSheetViewController.pickerView selectRow:decimals inComponent:QuantityPickerComponentDecimal animated:NO];
	[quantityPickerSheetViewController showInWindow:self];
}


- (IBAction)pickUnit:(id)sender {
	NSInteger unit = [self._recipeItemToEdit.unit intValue];
	[unitPickerSheetViewController.pickerView selectRow:unit inComponent:0 animated:NO];
	[unitPickerSheetViewController showInWindow:self];
}


- (IBAction)pickPrepMethod:(id)sender {
	[self presentModalViewController:prepMethodSearchOrCreateViewController animated:YES];
}


- (IBAction)pickIngredient:(id)sender {
	[self presentModalViewController:ingredientSearchOrCreateViewController animated:YES];
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
- (void)pickerSheetDidDismissWithDone:(PickerSheetViewController*)pickerSheet {
	if(pickerSheet == quantityPickerSheetViewController) {		
		NSInteger ones = [pickerSheet.pickerView selectedRowInComponent:QuantityPickerComponentOnes];
		NSInteger tens = [pickerSheet.pickerView selectedRowInComponent:QuantityPickerComponentTens];
		NSInteger hundreds = [pickerSheet.pickerView selectedRowInComponent:QuantityPickerComponentHundreds];
		NSInteger decimal = [pickerSheet.pickerView selectedRowInComponent:QuantityPickerComponentDecimal];
		
		NSString* quantityValue = [NSString stringWithFormat:@"%d%d%d%@", hundreds, tens, ones, [numberFormatter stringFromNumber:[NSNumber numberWithFloat:(float)decimal * 0.05]]];
		self._recipeItemToEdit.quantity = [NSNumber numberWithFloat:[quantityValue floatValue]];
	
	} else if(pickerSheet == unitPickerSheetViewController) {
		NSInteger unit = [pickerSheet.pickerView selectedRowInComponent:0];
		
		self._recipeItemToEdit.unit = [NSNumber numberWithInteger:unit];		
	}
	
	[self _updateUnitQuantityLabel];
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
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if(pickerView == quantityPickerSheetViewController.pickerView) {
		CGFloat width = 55;
		if (component == 0 || component == 1 || component == 2) {
			width = 30;
		}
		return width;
	} else if (pickerView == unitPickerSheetViewController.pickerView) {
		return 280.0;
 	} else {
		return 280.0;
	}
}

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
			result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:(float)row * 0.05]]; 
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


- (void)_updateUnitQuantityLabel {
	[unitQuantityLabel setText:[NSString stringWithFormat:@"%@ %@",NSStringFromQuantity(self._recipeItemToEdit.quantity),NSStringFromUnit(self._recipeItemToEdit.unit)]];
}


#pragma mark Properties
@synthesize ingredientTable;
@synthesize changeUnitQuantityButtonsCell;
@synthesize unitQuantityCell;
@synthesize unitQuantityLabel;
@synthesize prepMethodIngredientButtonsCell;
@synthesize preppedIngredientCell;
@synthesize preppedIngredientLabel;

@synthesize ingredientSearchOrCreateViewController;
@synthesize prepMethodSearchOrCreateViewController;

@synthesize recipeItem;


- (void)setRecipeItem:(RecipeItem *)aRecipeItem {
	if(aRecipeItem != recipeItem) {
		[self willChangeValueForKey:@"recipeItem"];
		[aRecipeItem retain];
		[recipeItem release];
		recipeItem = aRecipeItem;
		[self didChangeValueForKey:@"recipeItem"];
		
		resetForNewRecipeItem = YES;
	}
}


@synthesize shouldSaveChanges;
@synthesize managedObjectContext;


#pragma mark Properties (Private, Derived)
- (RecipeItem*)_recipeItemToEdit {
	RecipeItem* result = nil;
	
	if(recipeItem == nil) {
		result = newRecipeItem;
	}
	else {
		result = recipeItem;
	}
	
	return result;
}
@end
