//
//  ShoppingListDetailViewController.h
//  RecipeApp
//
//  Created by Daniel Mundra on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class ShoppingListItem;

@interface ShoppingListDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView* recipesTable;
	
	NSMutableDictionary* shoppingListItem;	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext* managedObjectContext;
}

@property(nonatomic, retain) UITableView* recipesTable;

@property(nonatomic, retain) NSMutableDictionary* shoppingListItem;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
