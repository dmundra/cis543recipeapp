//
//  ShoppingListViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface ShoppingListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
	IBOutlet UITableView* shoppingListTable;	
	NSManagedObjectContext* managedObjectContext;
	
	NSMutableArray* modifiedShoppingList;
}
- (IBAction)clearAll:(id)sender;

@property(nonatomic, retain) UITableView* shoppingListTable;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSArray *tableData;
@end
