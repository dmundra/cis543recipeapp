//
//  ShoppingListViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface ShoppingListViewController : UIViewController {
	IBOutlet UITableView* shoppingListTable;
	
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) UITableView* shoppingListTable;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
