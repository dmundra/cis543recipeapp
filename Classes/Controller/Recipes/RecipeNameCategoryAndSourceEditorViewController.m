//
//  RecipeNameCategoryAndSourceEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeNameCategoryAndSourceEditorViewController.h"
#import "Recipe.h"


@implementation RecipeNameCategoryAndSourceEditorViewController
#pragma mark View Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
	NSString *defaultTextString = nil;
	if(recipe.name != nil)
	{
		[titleTextField setText:recipe.name];
	}
	else
	{
		[titleTextField setText:defaultTextString];
	}
	//if(recipe.category != nil)
//	{
//		[categoryTextField setText:NSStringFromCategory(recipe.category)];
//	}
//	else
//	{
//		[categoryTextField setText:defaultTextString];
//	}
	if(recipe.source != nil)
	{
		[sourceTextField setText:recipe.source];
	}
	else
	{
		[sourceTextField setText:defaultTextString];
	}
}

- (void)viewDidUnload {
	self.nameCategoryAndSourceTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[nameCategoryAndSourceTable release];
	[titleTextField release];
	[sourceTextField release];


	[recipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}

#pragma mark TextEdit
-(IBAction)textFieldDoneEditing:(id)sender 
{
	
	[recipe setName:[titleTextField text]];
	[recipe setSource:[sourceTextField text]];
	if(shouldSaveChanges)
	{
		// Save the data
		NSError* error;
		if(![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
		}
	}
	
	//closes the pop-up keyboard when 'done' button is hit on the keyboard. 
	[sender resignFirstResponder];
}





#pragma mark Properties
@synthesize nameCategoryAndSourceTable;

@synthesize recipe;

@synthesize shouldSaveChanges;
@synthesize managedObjectContext;
@synthesize titleTextField;


@synthesize sourceTextField;
@end
