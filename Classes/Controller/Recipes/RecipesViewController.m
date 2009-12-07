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
#import "Ingredient.h"
#import "RecipeItem.h"
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
	self.filteredRecipeList = [NSMutableArray array];
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
	[searchBar release];
	[recipeDetailViewController release];
	[newRecipeNavController release];
	[newRecipeDetailViewController release];
	[filteredRecipeList release];
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
	if (table == self.searchDisplayController.searchResultsTableView)
	{
		return [self.filteredRecipeList count];
	}
	else
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"RecipeListItemCell";
    UITableViewCell *cell = [self.recipesTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Recipe *recipe = nil;
	if( table == self.searchDisplayController.searchResultsTableView)
	{
		recipe = [self.filteredRecipeList objectAtIndex:indexPath.row];
	}
	else
	{
		recipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}
    cell.textLabel.text = recipe.name;
	
    return cell;
}


#pragma mark IBAction
- (IBAction)addNewRecipe:(id)sender {
	[self presentModalViewController:newRecipeNavController animated:YES];
}


#pragma mark Public
- (void)showDetailViewForRecipe:(Recipe*)recipe {
	// Set the selected recipe on the detail view
	recipeDetailViewController.recipe = recipe;
	// Show the detail view
	[((UINavigationController*)self.parentViewController) pushViewController:recipeDetailViewController animated:YES];	
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

#pragma mark Recipe Search Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredRecipeList removeAllObjects]; // First clear the filtered array.
	
	[self.filteredRecipeList addObjectsFromArray:fetchedResultsController.fetchedObjects];
	if ([scope isEqualToString:@"All"])
	{
		[self.filteredRecipeList filterUsingPredicate:[NSPredicate predicateWithFormat:@"(self.name contains[cd] %@) OR (ANY self.recipeItems.ingredient.name contains[cd] %@)", searchText, searchText]];
	}
	else if ([@"Title" isEqualToString:scope])
	{
		[self.filteredRecipeList filterUsingPredicate:[NSPredicate predicateWithFormat:@"self.name contains[cd] %@", searchText]];
	}
	else if ( [@"Ingredient" isEqualToString:scope]){
		[self.filteredRecipeList filterUsingPredicate:[NSPredicate predicateWithFormat:@"ANY self.recipeItems.ingredient.name contains[cd] %@", searchText]];
	}
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
//	for (Recipe *recipe in fetchedResultsController.fetchedObjects)
//	{
//		if ([scope isEqualToString:@"All"] || [@"Title" isEqualToString:scope])
//		{
//			NSComparisonResult result = [recipe.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if ((result == NSOrderedSame) && (![filteredRecipeList containsObject:recipe]))
//			{
//				[self.filteredRecipeList addObject:recipe];
//            }
//		}
//		if ([scope isEqualToString:@"All"] || [@"Ingredient" isEqualToString:scope])
//		{
//			for(RecipeItem *ritem in recipe.recipeItems)			{
//				Ingredient *ingred = ritem.ingredient; 
//				NSComparisonResult result = [ingred.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//				if ((result == NSOrderedSame)   && (![filteredRecipeList containsObject:recipe]))
//
//				{
//					[self.filteredRecipeList addObject:recipe];
//				}
//			}
//		}
//		
//	}
//OR (self.recipeItems.ingredient.name contains[cd] %@)
	
}



#pragma mark searchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark Properties
@synthesize recipesTable;

@synthesize recipeDetailViewController;
@synthesize newRecipeNavController;
@synthesize newRecipeDetailViewController;
@synthesize searchBar;
@synthesize filteredRecipeList;
@synthesize managedObjectContext;
@end