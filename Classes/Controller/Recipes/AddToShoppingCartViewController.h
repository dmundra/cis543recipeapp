//
//  AddToShoppingCartViewController.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe;

// The Add To Shopping Cart View Controller class
@interface AddToShoppingCartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	// IBOutlet UI Components
	IBOutlet UITableView* addToCartTable;
	IBOutlet UIBarButtonItem* addButton;
	
	// Recipe instance
	Recipe* recipe;
	
	// Various state values
	NSInteger selectedRowCount;
	NSMutableArray* selectedState;
	
	// The database context
	NSManagedObjectContext* managedObjectContext;
}
// IBActions
- (IBAction)addToCart:(id)sender;
- (IBAction)cancel:(id)sender;

// Property Declarations
@property(nonatomic, retain) UITableView* addToCartTable;
@property(nonatomic, retain) UIBarButtonItem* addButton;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
