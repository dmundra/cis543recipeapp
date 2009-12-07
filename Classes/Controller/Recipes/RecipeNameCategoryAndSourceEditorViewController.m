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
- (void)viewDidUnload {
	self.nameCategoryAndSourceTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[nameCategoryAndSourceTable release];
	
	[recipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize nameCategoryAndSourceTable;

@synthesize recipe;

@synthesize shouldSaveChanges;
@synthesize managedObjectContext;
@end
