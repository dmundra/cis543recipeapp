//
//  AddToShoppingCartViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe;


@interface AddToShoppingCartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView* addToCartTable;
	
	Recipe* recipe;
	
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) UITableView* addToCartTable;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
