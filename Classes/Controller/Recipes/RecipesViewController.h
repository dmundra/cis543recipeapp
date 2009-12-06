//
//  RecipesViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface RecipesViewController : UIViewController {
	IBOutlet UITableView* recipesTable;
	
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) UITableView* recipesTable;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
