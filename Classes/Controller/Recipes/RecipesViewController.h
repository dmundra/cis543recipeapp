//
//  RecipesViewController.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe, RecipeDetailViewController;


@interface RecipesViewController : UIViewController {
	IBOutlet UITableView* recipesTable;
	
	IBOutlet RecipeDetailViewController* recipeDetailViewController;
	IBOutlet UINavigationController* newRecipeNavController;
	IBOutlet RecipeDetailViewController* newRecipeDetailViewController;
	IBOutlet UISearchBar* searchBar;
	
	NSFetchedResultsController *fetchedResultsController;
	NSMutableArray* filteredRecipeList;

	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)addNewRecipe:(id)sender;

- (void)showDetailViewForRecipe:(Recipe*)recipe;

@property(nonatomic, retain) UITableView* recipesTable;
@property(nonatomic, retain) UISearchBar* searchBar;


@property(nonatomic, retain) RecipeDetailViewController* recipeDetailViewController;
@property(nonatomic, retain) UINavigationController* newRecipeNavController;
@property(nonatomic, retain) RecipeDetailViewController* newRecipeDetailViewController;
@property(nonatomic, retain) NSMutableArray* filteredRecipeList;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
