//
//  IngredientEditorViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "PickerSheetViewController.h"

@class Recipe;


@interface IngredientEditorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PickerSheetViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UITableView* ingredientTable;
	IBOutlet UITableViewCell* changeUnitQuantityButtonsCell;
	IBOutlet UITableViewCell* unitQuantityCell;
	IBOutlet UILabel* unitQuantityLabel;
	IBOutlet UITableViewCell* prepMethodIngredientButtonsCell;
	IBOutlet UITableViewCell* preppedIngredientCell;
	IBOutlet UILabel* preppedIngredientLabel;
	
	PickerSheetViewController* quantityPickerSheetViewController;
	PickerSheetViewController* unitPickerSheetViewController;
	
	Recipe* recipe;
	
	BOOL shouldSaveChanges;
	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@property(nonatomic, retain) UITableView* ingredientTable;
@property(nonatomic, retain) UITableViewCell* changeUnitQuantityButtonsCell;
@property(nonatomic, retain) UITableViewCell* unitQuantityCell;
@property(nonatomic, retain) UILabel* unitQuantityLabel;
@property(nonatomic, retain) UITableViewCell* prepMethodIngredientButtonsCell;
@property(nonatomic, retain) UITableViewCell* preppedIngredientCell;
@property(nonatomic, retain) UILabel* preppedIngredientLabel;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, assign) BOOL shouldSaveChanges;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
