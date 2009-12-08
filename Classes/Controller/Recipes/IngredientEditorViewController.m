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
#import "PreppedIngredient.h"
#import "PreparationMethod.h"
#import "Ingredient.h"
#import "Unit.h"


enum {
	IngredientSectionPreppedIngredient,
	IngredientSectionPrepMethodIngredientButtons,
	IngredientSectionQuantityUnitButtons,
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
- (void)_updatePreppedIngredientCell;
- (void)_updateDoneButton;

- (void)_addToTasteQuantitySelected;
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
		doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
		self.navigationItem.rightBarButtonItem = doneButton;
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
			quantity = 1.0;
			unit = 0;
			[ingredient release];
			ingredient = nil;
			[preparationMethod release];
			preparationMethod = nil;
			[newIngredient release];
			newIngredient = nil;
			[newPrepMethod release];
			newPrepMethod = nil;
			
			// Set the navigation item for new recipe mode
			self.navigationItem.title = @"Add Ingredient";
		}
		else {
			recipe = recipeItem.recipe;
			orderIndex = [recipeItem.orderIndex integerValue];
			quantity = [recipeItem.quantity doubleValue];
			unit = [recipeItem.unit integerValue];
			[ingredient release];
			[preparationMethod release];
			if(recipeItem.ingredient == nil) {
				ingredient = [recipeItem.preppedIngredient.ingredient retain];
				preparationMethod = [recipeItem.preppedIngredient.preparationMethod retain];
			}
			else {
				ingredient = [recipeItem.ingredient retain];
				preparationMethod = nil;
			}
			[newIngredient release];
			newIngredient = nil;
			[newPrepMethod release];
			newPrepMethod = nil;			
			
			// Set the navigation item for normal recipe mode
			self.navigationItem.title = @"Edit Ingredient";
		}
		
		resetForNewRecipeItem = NO;
	}
	
	// Update the UI to reflect the current state
	[self _updatePreppedIngredientCell];
	[self _updateDoneButton];
	
	[ingredientTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	ingredientSearchOrCreateViewController.managedObjectContext = self.managedObjectContext;
	prepMethodSearchOrCreateViewController.managedObjectContext = self.managedObjectContext;
	
	preppedIngredientCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
	preppedIngredientCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	quantityPickerSheetViewController = [[PickerSheetViewController alloc] init];
	quantityPickerSheetViewController.delegate = self;
	quantityPickerSheetViewController.pickerView.dataSource = self;
	quantityPickerSheetViewController.pickerView.delegate = self;
	quantityPickerSheetViewController.pickerView.showsSelectionIndicator = YES;
	NSMutableArray* items = [NSMutableArray arrayWithArray:quantityPickerSheetViewController.toolbar.items];
	[items insertObject:[[[UIBarButtonItem alloc] initWithTitle:@"Add To Taste" style:UIBarButtonItemStyleDone target:self action:@selector(_addToTasteQuantitySelected)] autorelease] atIndex:2];
	[items insertObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease] atIndex:3];
	quantityPickerSheetViewController.toolbar.items = items;
	
	unitPickerSheetViewController = [[PickerSheetViewController alloc] init];
	unitPickerSheetViewController.delegate = self;
	unitPickerSheetViewController.pickerView.dataSource = self;
	unitPickerSheetViewController.pickerView.delegate = self;
	unitPickerSheetViewController.pickerView.showsSelectionIndicator = YES;
}


- (void)viewDidUnload {
	self.ingredientTable = nil;
	self.preppedIngredientCell = nil;
	self.changeUnitQuantityButtonsCell = nil;
	self.prepMethodIngredientButtonsCell = nil;
	
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
	[preppedIngredientCell release];
	[changeUnitQuantityButtonsCell release];
	[prepMethodIngredientButtonsCell release];
	
	[ingredientSearchOrCreateViewController release];
	[prepMethodSearchOrCreateViewController release];
	
	[quantityPickerSheetViewController release];
	[unitPickerSheetViewController release];
	
	[doneButton release];
	
	[recipeItem release];
	[recipe release];
	[preparationMethod release];
	[newPrepMethod release];
	[ingredient release];
	[newIngredient release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)done:(id)sender {
	RecipeItem* itemToEdit = nil;
	if(recipeItem == nil) {
		itemToEdit = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
		itemToEdit.recipe = recipe;
		itemToEdit.orderIndex = [NSNumber numberWithInteger:orderIndex];
	}
	else {
		itemToEdit = recipeItem;
	}
	
	itemToEdit.quantity = [NSNumber numberWithDouble:quantity];
	itemToEdit.unit = [NSNumber numberWithInteger:unit];
	
	if([newPrepMethod length] > 0) {
		[preparationMethod release];
		preparationMethod = [NSEntityDescription insertNewObjectForEntityForName:@"PreparationMethod" inManagedObjectContext:self.managedObjectContext];
		preparationMethod.name = newPrepMethod;
	}
	
	if([newIngredient length] > 0) {
		[ingredient release];
		ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
		ingredient.name = newIngredient;
	}
	
	if(preparationMethod != nil) {
		if(itemToEdit.preppedIngredient == nil) {
			itemToEdit.preppedIngredient = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
		}
		
		itemToEdit.ingredient = nil;
		itemToEdit.preppedIngredient.ingredient = ingredient;
		itemToEdit.preppedIngredient.preparationMethod = preparationMethod;
	}
	else {
		itemToEdit.ingredient = ingredient;
		itemToEdit.preppedIngredient = nil;
	}
	
	if(shouldSaveChanges) {
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
	
	[((UINavigationController*)self.parentViewController) popViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[((UINavigationController*)self.parentViewController) popViewControllerAnimated:YES];
}


- (IBAction)pickQuantity:(id)sender {
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
	[unitPickerSheetViewController.pickerView selectRow:unit inComponent:0 animated:NO];
	[unitPickerSheetViewController showInWindow:self];
}


- (IBAction)pickPrepMethod:(id)sender {
	prepMethodSearchOrCreateViewController.preparationMethodName = (preparationMethod == nil ? newPrepMethod : preparationMethod.name);
	[self presentModalViewController:prepMethodSearchOrCreateViewController animated:YES];
}


- (IBAction)pickIngredient:(id)sender {
	ingredientSearchOrCreateViewController.ingredientName = (ingredient == nil ? newIngredient : ingredient.name);
	[self presentModalViewController:ingredientSearchOrCreateViewController animated:YES];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	if(indexPath.section == IngredientSectionQuantityUnitButtons) {
		result = changeUnitQuantityButtonsCell;
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
	
	if(section == IngredientSectionPreppedIngredient) {
		result = @"Ingredient:";
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
	
	if(section == IngredientSectionPreppedIngredient) {
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
		quantity = (double)(hundreds * 100) + (double)(tens * 10) + (double)ones + ((double)decimal * 0.05);
	
	} else if(pickerSheet == unitPickerSheetViewController) {
		unit = [pickerSheet.pickerView selectedRowInComponent:0];
	}
	
	[self _updatePreppedIngredientCell];
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
	CGFloat result = 280.0;
	
	if(pickerView == quantityPickerSheetViewController.pickerView) {
		result = 30.0;
		if (component == QuantityPickerComponentDecimal) {
			result = 55.0;
		}
	}
	
	return result;
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


#pragma mark IngredientSearchOrCreateViewControllerDelegate
- (void)didChooseIngredient:(Ingredient*)anIngredient {
	[newIngredient release];
	newIngredient = nil;
	[anIngredient retain];
	[ingredient release];
	ingredient = anIngredient;
	
	[self _updatePreppedIngredientCell];
}


- (void)didCreateNewIngredient:(NSString*)ingredientName {
	[ingredient release];
	ingredient = nil;
	[ingredientName retain];
	[newIngredient release];
	newIngredient = ingredientName; 
	
	[self _updatePreppedIngredientCell];
}


#pragma mark PrepMethodSearchOrCreateViewControllerDelegate
- (void)didChoosePrepMethod:(PreparationMethod*)aPreparationMethod {
	[newPrepMethod release];
	newPrepMethod = nil;
	[aPreparationMethod retain];
	[preparationMethod release];
	preparationMethod = aPreparationMethod;
	
	[self _updatePreppedIngredientCell];
}


- (void)didCreateNewPrepMethod:(NSString*)prepMethodName {
	[preparationMethod release];
	preparationMethod = nil;
	[prepMethodName retain];
	[newPrepMethod release];
	newPrepMethod = prepMethodName;
	
	[self _updatePreppedIngredientCell];
}


#pragma mark Private
- (void)_updatePreppedIngredientCell {
	NSString* preparationMethodValue = nil;
	if(preparationMethod != nil) {
		preparationMethodValue = preparationMethod.name;
	}
	else if([newPrepMethod length] > 0) {
		preparationMethodValue = newPrepMethod;
	}
	
	NSString* ingredientValue = nil;
	if(ingredient != nil) {
		ingredientValue = ingredient.name;
	}
	else if([newIngredient length] > 0) {
		ingredientValue = newIngredient;
	}
	
	if([ingredientValue length] > 0) {
		preppedIngredientCell.textLabel.textColor = [UIColor blackColor];
		preppedIngredientCell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		
		if([preparationMethodValue length] > 0) {
			preppedIngredientCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", preparationMethodValue, ingredientValue];
		}
		else {
			preppedIngredientCell.textLabel.text = ingredientValue;
		}
	}
	else {
		preppedIngredientCell.textLabel.textColor = [UIColor lightGrayColor];
		preppedIngredientCell.textLabel.font = [UIFont italicSystemFontOfSize:17.0];
		preppedIngredientCell.textLabel.text = @"No Ingredient Set.";
	}
	
	if(quantity >= 0.0) {
		preppedIngredientCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity([NSNumber numberWithDouble:quantity]), NSStringFromUnit([NSNumber numberWithInteger:unit])];
	}
	else {
		preppedIngredientCell.detailTextLabel.text = NSStringFromQuantity([NSNumber numberWithDouble:quantity]);
	}
}


- (void)_updateDoneButton {
	if(ingredient != nil || [newIngredient length] > 0) {
		doneButton.enabled = YES;
	}
	else {
		doneButton.enabled = NO;
	}
}


- (void)_addToTasteQuantitySelected {
	[quantityPickerSheetViewController dismiss:self];
	
	quantity = kQuantityToTaste;
	
	[self _updatePreppedIngredientCell];	
}


#pragma mark Properties
@synthesize ingredientTable;
@synthesize preppedIngredientCell;
@synthesize changeUnitQuantityButtonsCell;
@synthesize prepMethodIngredientButtonsCell;

@synthesize ingredientSearchOrCreateViewController;
@synthesize prepMethodSearchOrCreateViewController;

@synthesize recipeItem;
@synthesize recipe;
@synthesize orderIndex;


- (void)setRecipeItem:(RecipeItem *)aRecipeItem {
	[self willChangeValueForKey:@"recipeItem"];
	[aRecipeItem retain];
	[recipeItem release];
	recipeItem = aRecipeItem;
	[self didChangeValueForKey:@"recipeItem"];
		
	resetForNewRecipeItem = YES;
}


@synthesize shouldSaveChanges;
@synthesize managedObjectContext;
@end
