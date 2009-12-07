//
//  AddIngredientViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "PickerSheetViewController.h"

@class Recipe;


@interface AddIngredientViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PickerSheetViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UITableView* ingredientTable;
	IBOutlet UITableViewCell* unitQuantityCell;
	IBOutlet UILabel* unitQuantityLabel;
	IBOutlet UITableViewCell* prepMethodCell;
	IBOutlet UILabel* preparationMethodLabel;
	IBOutlet UITableViewCell* ingredientCell;
	IBOutlet UILabel* ingredientLabel;
	
	PickerSheetViewController* pickerSheetViewController;
	
	Recipe* recipe;
	
	BOOL shouldSaveChanges;
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) UITableView* ingredientTable;
@property(nonatomic, retain) UITableViewCell* unitQuantityCell;
@property(nonatomic, retain) UILabel* unitQuantityLabel;
@property(nonatomic, retain) UITableViewCell* prepMethodCell;
@property(nonatomic, retain) UILabel* preparationMethodLabel;
@property(nonatomic, retain) UITableViewCell* ingredientCell;
@property(nonatomic, retain) UILabel* ingredientLabel;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, assign) BOOL shouldSaveChanges;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
