//
//  RecipesViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipesViewController.h"


@implementation RecipesViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.recipesTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[recipesTable release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize recipesTable;

@synthesize managedObjectContext;
@end
