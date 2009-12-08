//
//  ShoppingListDetailViewController.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class ShoppingListItem;
@class ShoppingListRecipeCell;

@interface ShoppingListDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView* recipesTable;
	IBOutlet ShoppingListRecipeCell* cell;
	
	NSMutableDictionary* shoppingListItem;	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)showRecipe:(id)sender;

@property(nonatomic, retain) UITableView* recipesTable;
@property(nonatomic, retain) ShoppingListRecipeCell* cell;

@property(nonatomic, retain) NSMutableDictionary* shoppingListItem;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
