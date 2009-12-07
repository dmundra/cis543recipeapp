//
//  AbstractTextEditorViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface AbstractTextEditorViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITableView* textEditorTable;
	IBOutlet UITableViewCell* textViewCell;
	IBOutlet UITextView* textView;
	
	BOOL shouldSaveChanges;
}
@property(nonatomic, retain) UITableView* textEditorTable;
@property(nonatomic, retain) UITableViewCell* textViewCell;
@property(nonatomic, retain) UITextView* textView;

@property(nonatomic, assign) BOOL shouldSaveChanges;
@end
