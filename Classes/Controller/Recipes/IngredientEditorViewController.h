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

@class RecipeItem;


@interface IngredientEditorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PickerSheetViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, IngredientSearchOrCreateViewControllerDelegate, PrepMethodSearchOrCreateViewControllerDelegate> {
	IBOutlet UITableView* ingredientTable;
	IBOutlet UITableViewCell* changeUnitQuantityButtonsCell;
	IBOutlet UITableViewCell* unitQuantityCell;
	IBOutlet UILabel* unitQuantityLabel;
	IBOutlet UITableViewCell* prepMethodIngredientButtonsCell;
	IBOutlet UITableViewCell* preppedIngredientCell;
	IBOutlet UILabel* preppedIngredientLabel;
	
	IBOutlet IngredientSearchOrCreateViewController* ingredientSearchOrCreateViewController;
	IBOutlet PrepMethodSearchOrCreateViewController* prepMethodSearchOrCreateViewController;
	
	PickerSheetViewController* quantityPickerSheetViewController;
	PickerSheetViewController* unitPickerSheetViewController;
	
	RecipeItem* recipeItem;
	RecipeItem* newRecipeItem;
	PreparationMethod* preparationMethod;
	NSString* newPrepMethod;
	Ingredient* ingredient;
	NSString* newIngredient;
	BOOL resetForNewRecipeItem;
	
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
@property(nonatomic, retain) UITableViewCell* changeUnitQuantityButtonsCell;
@property(nonatomic, retain) UITableViewCell* unitQuantityCell;
@property(nonatomic, retain) UILabel* unitQuantityLabel;
@property(nonatomic, retain) UITableViewCell* prepMethodIngredientButtonsCell;
@property(nonatomic, retain) UITableViewCell* preppedIngredientCell;
@property(nonatomic, retain) UILabel* preppedIngredientLabel;

@property(nonatomic, retain) IngredientSearchOrCreateViewController* ingredientSearchOrCreateViewController;
@property(nonatomic, retain) PrepMethodSearchOrCreateViewController* prepMethodSearchOrCreateViewController;

@property(nonatomic, retain) RecipeItem* recipeItem;

@property(nonatomic, assign) BOOL shouldSaveChanges;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
