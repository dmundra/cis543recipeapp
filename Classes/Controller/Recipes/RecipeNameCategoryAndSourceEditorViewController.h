//
//  RecipeNameCategoryAndSourceEditorViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe;


@interface RecipeNameCategoryAndSourceEditorViewController : UIViewController {
	IBOutlet UITableView* nameCategoryAndSourceTable;
	
	Recipe* recipe;
	
	BOOL shouldSaveChanges;
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) UITableView* nameCategoryAndSourceTable;

@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, assign) BOOL shouldSaveChanges;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
