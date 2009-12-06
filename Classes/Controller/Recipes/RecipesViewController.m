//
//  RecipesViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipesViewController.h"
#import "RecipeDetailViewController.h"
#import "Recipe.h"
@interface RecipesViewController (/*Private*/)
@property(nonatomic, retain, readonly) NSFetchedResultsController* fetchedResultsController;
@end


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


- (void)fetch {
	NSError *error = nil;
	BOOL success = [self.fetchedResultsController performFetch:&error];
	NSAssert2(success, @"Unhandled error performing fetch at RecipesViewController.m, line %d: %@", __LINE__, [error localizedDescription]);
	[self.recipesTable reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext]];
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"RecipeListCache"];
		[fetchedResultsController performFetch:nil];
	}
	
	return fetchedResultsController;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"RecipeListItemCell";
    UITableViewCell *cell = [self.recipesTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = recipe.name;
	
    return cell;
}


#pragma mark IBAction
- (IBAction)addNewRecipe:(id)sender {
	[self presentModalViewController:newRecipeNavController animated:YES];
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
	// Deselect the selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Set the selected recipe on the detail view
	recipeDetailViewController.recipe = recipe;
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