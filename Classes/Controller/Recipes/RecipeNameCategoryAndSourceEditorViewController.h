//
//  RecipeNameCategoryAndSourceEditorViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe;


@interface RecipeNameCategoryAndSourceEditorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	IBOutlet UITableView* nameCategoryAndSourceTable;
	IBOutlet UITextField *titleTextField;
	IBOutlet UITextField *sourceTextField;
	
	IBOutlet UITableViewCell* titleViewCell;
	IBOutlet UITableViewCell* sourceViewCell;
	IBOutlet UITableViewCell* categoryViewCell;
		
	Recipe* recipe;
	
	BOOL shouldSaveChanges;
	NSManagedObjectContext* managedObjectContext;
}

@property(nonatomic, retain) UITableView* nameCategoryAndSourceTable;
@property(nonatomic, retain) Recipe* recipe;
@property(nonatomic, retain) UITextField *titleTextField;
@property(nonatomic, retain) UITextField *sourceTextField;
@property(nonatomic, retain) IBOutlet UITableViewCell* titleViewCell;
@property(nonatomic, retain) IBOutlet UITableViewCell* sourceViewCell;
@property(nonatomic, retain) IBOutlet UITableViewCell* categoryViewCell;
@property(nonatomic, assign) BOOL shouldSaveChanges;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
