//
//  ShoppingListViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class ShoppingListDetailViewController;

@interface ShoppingListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
	IBOutlet UITableView* shoppingListTable;	
	NSManagedObjectContext* managedObjectContext;
	
	NSMutableArray* modifiedShoppingList;
	
	IBOutlet ShoppingListDetailViewController* shoppingListDetailViewController;
}
- (IBAction)clearAll:(id)sender;

@property(nonatomic, retain) UITableView* shoppingListTable;

@property(nonatomic, retain) ShoppingListDetailViewController* shoppingListDetailViewController;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSArray *tableData;
@end
