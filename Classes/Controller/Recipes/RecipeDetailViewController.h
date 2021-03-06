//
//  RecipeDetailViewController.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "PickerSheetViewController.h"

@class Recipe, RecipeNameCategoryAndSourceEditorViewController, DescriptionEditorViewController, IngredientEditorViewController, AddToShoppingCartViewController, InstructionsEditorViewController;


// The Recipe Detail View Controller class
@interface RecipeDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PickerSheetViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
	// IBOutlet UI Components 
	IBOutlet UITableView* recipeDetailTable;
	IBOutlet UITableViewCell* recipeImageNameCategoryAndSourceCell;
	IBOutlet UIImageView* recipeImageView;
	IBOutlet UIButton* editImageButton;
	IBOutlet UIButton* addImageButton;
	IBOutlet UILabel* recipeNameLabel;
	IBOutlet UILabel* recipeCategoryAndSourceLabel;
	IBOutlet UITableViewCell* recipeDescriptionCell;
	IBOutlet UILabel* descriptionTextLabel;
	IBOutlet UITableViewCell* addToShoppingCartButtonCell;
	IBOutlet UITableViewCell* recipeInstructionsCell;
	IBOutlet UILabel* instructionsLabel;
	
	// IBOutlet Child View Controllers
	IBOutlet RecipeNameCategoryAndSourceEditorViewController* recipeNameCategoryAndSourceEditorViewController;
	IBOutlet DescriptionEditorViewController* descriptionEditorViewController;
	IBOutlet IngredientEditorViewController* ingredientEditorViewController;
	IBOutlet AddToShoppingCartViewController* addToShoppingCartViewController;
	IBOutlet InstructionsEditorViewController* instructionsEditorViewController;
	
	// Other UI Components
	UIBarButtonItem* editButton;
	UIBarButtonItem* doneButton;
	
	UIBarButtonItem* cancelButton;
	UIBarButtonItem* saveButton;
	
	PickerSheetViewController* servingsPickerSheetViewController;
	PickerSheetViewController* prepTimePickerSheetViewController;
	
	// Recipe instances
	Recipe* recipe;
	Recipe* newRecipe;
	
	// Various state flags
	BOOL singleEditMode;
	BOOL resetForNewRecipe;
	
	// The database context
	NSManagedObjectContext* managedObjectContext;
}
// IBActions
- (IBAction)edit:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)selectImage:(id)sender;
- (IBAction)addToCart:(id)sender;

// Property declarations
@property(nonatomic, retain) UITableView* recipeDetailTable;
@property(nonatomic, retain) UITableViewCell* recipeImageNameCategoryAndSourceCell;
@property(nonatomic, retain) UIImageView* recipeImageView;
@property(nonatomic, retain) UIButton* editImageButton;
@property(nonatomic, retain) UIButton* addImageButton;
@property(nonatomic, retain) UILabel* recipeNameLabel;
@property(nonatomic, retain) UILabel* recipeCategoryAndSourceLabel;
@property(nonatomic, retain) UITableViewCell* recipeDescriptionCell;
@property(nonatomic, retain) UILabel* descriptionTextLabel;
@property(nonatomic, retain) UITableViewCell* addToShoppingCartButtonCell;
@property(nonatomic, retain) UITableViewCell* recipeInstructionsCell;
@property(nonatomic, retain) UILabel* instructionsLabel;

@property(nonatomic, retain) RecipeNameCategoryAndSourceEditorViewController* recipeNameCategoryAndSourceEditorViewController;
@property(nonatomic, retain) DescriptionEditorViewController* descriptionEditorViewController;
@property(nonatomic, retain) IngredientEditorViewController* ingredientEditorViewController;
@property(nonatomic, retain) AddToShoppingCartViewController* addToShoppingCartViewController;
@property(nonatomic, retain) InstructionsEditorViewController* instructionsEditorViewController;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
