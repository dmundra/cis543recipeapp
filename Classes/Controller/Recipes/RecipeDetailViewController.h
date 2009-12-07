//
//  RecipeDetailViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe, RecipeNameCategoryAndSourceEditorViewController;


@interface RecipeDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView* recipeDetailTable;
	IBOutlet UITableViewCell* recipeImageNameCategoryAndSourceCell;
	IBOutlet UIImageView* recipeImageView;
	IBOutlet UILabel* recipeNameLabel;
	IBOutlet UILabel* recipeCategoryAndSourceLabel;
	IBOutlet UITableViewCell* recipeDescriptionCell;
	IBOutlet UILabel* descriptionTextLabel;
	
	IBOutlet RecipeNameCategoryAndSourceEditorViewController* recipeNameCategoryAndSourceEditorViewController;
	
	UIBarButtonItem* editButton;
	UIBarButtonItem* doneButton;
	
	UIBarButtonItem* cancelButton;
	UIBarButtonItem* saveButton;
	
	Recipe* recipe;
	Recipe* newRecipe;
	
	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)edit:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@property(nonatomic, retain) UITableView* recipeDetailTable;
@property(nonatomic, retain) UITableViewCell* recipeImageNameCategoryAndSourceCell;
@property(nonatomic, retain) UIImageView* recipeImageView;
@property(nonatomic, retain) UILabel* recipeNameLabel;
@property(nonatomic, retain) UILabel* recipeCategoryAndSourceLabel;
@property(nonatomic, retain) UITableViewCell* recipeDescriptionCell;
@property(nonatomic, retain) UILabel* descriptionTextLabel;

@property(nonatomic, retain) RecipeNameCategoryAndSourceEditorViewController* recipeNameCategoryAndSourceEditorViewController;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
