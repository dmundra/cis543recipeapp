//
//  AbstractSearchOrCreateViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface AbstractSearchOrCreateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	IBOutlet UITableView* searchTable;
	IBOutlet UILabel* nameLabel;
	IBOutlet UITextField* nameTextField;
	IBOutlet UIBarButtonItem* doneButton;
	
	NSString* filterTerm;
	NSArray* unfilteredNames;
	NSMutableArray* filteredNames;
	
	BOOL keyboardShown;
	
	NSManagedObjectContext* managedObjectContext;
}
- (IBAction)done:(id)sender;

@property(nonatomic, retain) UITableView* searchTable;
@property(nonatomic, retain) UILabel* nameLabel;
@property(nonatomic, retain) UITextField* nameTextField;
@property(nonatomic, retain) UIBarButtonItem* doneButton;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
