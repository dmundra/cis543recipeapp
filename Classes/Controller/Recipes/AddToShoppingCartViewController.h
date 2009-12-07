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
	IBOutlet UIBarButtonItem* addButton;
	
	Recipe* recipe;
	NSInteger selectedRowCount;
	NSMutableArray* selectedState;
	
	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)addToCart:(id)sender;
- (IBAction)cancel:(id)sender;

@property(nonatomic, retain) UITableView* addToCartTable;
@property(nonatomic, retain) UIBarButtonItem* addButton;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
