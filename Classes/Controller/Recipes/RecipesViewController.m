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
#pragma mark Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRecipe:)];
	}
	
	return self;
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	self.recipeDetailViewController.managedObjectContext = managedObjectContext;
	self.newRecipeDetailViewController.managedObjectContext = managedObjectContext;
}


- (void)viewDidUnload {
	self.recipesTable = nil;
	
	self.recipeDetailViewController = nil;
	self.newRecipeNavController = nil;
	self.newRecipeDetailViewController = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[recipesTable release];

	[recipeDetailViewController release];
	[newRecipeNavController release];
	[newRecipeDetailViewController release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)addNewRecipe:(id)sender {
	[self presentModalViewController:newRecipeNavController animated:YES];
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
@synthesize newRecipeNavController;
@synthesize newRecipeDetailViewController;

@synthesize managedObjectContext;
@end