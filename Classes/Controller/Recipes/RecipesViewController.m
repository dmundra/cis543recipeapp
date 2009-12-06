//
//  RecipesViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipesViewController.h"
#import "RecipeDetailViewController.h"


@implementation RecipesViewController
#pragma mark View Life Cycle
- (void)viewDidLoad {
	self.recipeDetailViewController.managedObjectContext = managedObjectContext;
}


- (void)viewDidUnload {
	self.recipesTable = nil;
	
	self.recipeDetailViewController.managedObjectContext = nil;
	self.recipeDetailViewController = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[recipesTable release];

	[recipeDetailViewController release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	// Dequeue a cell to reuse
	result = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
	
	// If no cell is available, create a new one
	if(result == nil) {
		result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipeCell"] autorelease];
		result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// Set cell text
	result.textLabel.text = @"Some recipe";
	
	return result;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	
	// Set the result to the number of recipes in the section
	result = 1;
	
	return result;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect the selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Set the selected recipe on the detail view
	
	// Show the detail view
	[((UINavigationController*)self.parentViewController) pushViewController:recipeDetailViewController animated:YES];
}


#pragma mark Properties
@synthesize recipesTable;

@synthesize recipeDetailViewController;

@synthesize managedObjectContext;
@end