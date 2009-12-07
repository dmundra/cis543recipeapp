//
//  ShoppingListDetailViewController.h
//  RecipeApp
//
//  Created by Daniel Mundra on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class ShoppingListItem;

@interface ShoppingListDetailViewController : UIViewController {
	ShoppingListItem* shoppingListItem;
	
	NSManagedObjectContext* managedObjectContext;
}

@property(nonatomic, retain) ShoppingListItem* shoppingListItem;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@end
