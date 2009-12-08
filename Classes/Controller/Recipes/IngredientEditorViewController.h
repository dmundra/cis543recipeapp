//
//  IngredientEditorViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "PickerSheetViewController.h"
#import "IngredientSearchOrCreateViewController.h"
#import "PrepMethodSearchOrCreateViewController.h"

@class Recipe, RecipeItem;


@interface IngredientEditorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PickerSheetViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, IngredientSearchOrCreateViewControllerDelegate, PrepMethodSearchOrCreateViewControllerDelegate> {
	IBOutlet UITableView* ingredientTable;
	IBOutlet UITableViewCell* preppedIngredientCell;
	IBOutlet UITableViewCell* changeUnitQuantityButtonsCell;
	IBOutlet UITableViewCell* prepMethodIngredientButtonsCell;
	
	IBOutlet IngredientSearchOrCreateViewController* ingredientSearchOrCreateViewController;
	IBOutlet PrepMethodSearchOrCreateViewController* prepMethodSearchOrCreateViewController;
	
	UIBarButtonItem* doneButton;
	
	PickerSheetViewController* quantityPickerSheetViewController;
	PickerSheetViewController* unitPickerSheetViewController;
	
	double quantity;
	NSInteger unit;
	RecipeItem* recipeItem;
	PreparationMethod* preparationMethod;
	NSString* newPrepMethod;
	Ingredient* ingredient;
	NSString* newIngredient;
	BOOL resetForNewRecipeItem;
	
	Recipe* recipe;
	NSInteger orderIndex;
	
	BOOL shouldSaveChanges;
	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)pickQuantity:(id)sender;
- (IBAction)pickUnit:(id)sender;
- (IBAction)pickPrepMethod:(id)sender;
- (IBAction)pickIngredient:(id)sender;

@property(nonatomic, retain) UITableView* ingredientTable;
@property(nonatomic, retain) UITableViewCell* preppedIngredientCell;
@property(nonatomic, retain) UITableViewCell* changeUnitQuantityButtonsCell;
@property(nonatomic, retain) UITableViewCell* prepMethodIngredientButtonsCell;

@property(nonatomic, retain) IngredientSearchOrCreateViewController* ingredientSearchOrCreateViewController;
@property(nonatomic, retain) PrepMethodSearchOrCreateViewController* prepMethodSearchOrCreateViewController;

@property(nonatomic, retain) RecipeItem* recipeItem;
@property(nonatomic, retain) Recipe* recipe;
@property(nonatomic, assign) NSInteger orderIndex;

@property(nonatomic, assign) BOOL shouldSaveChanges;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
