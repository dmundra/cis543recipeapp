//
//  ShoppingListDetailViewController.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListDetailViewController.h"
#import "RecipeAppAppDelegate.h"
#import "ShoppingListItem.h"
#import "Ingredient.h"
#import "Recipe.h"
#import "ShoppingListRecipeCell.h"

@interface ShoppingListDetailViewController (/*Private*/)
@property(nonatomic, retain, readonly) NSFetchedResultsController* fetchedResultsController;
@end

@implementation ShoppingListDetailViewController

#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = [shoppingListItem objectForKey:@"Name"];
	[fetchedResultsController release];
	fetchedResultsController = nil; 
	
	[recipesTable reloadData];
}

#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.recipesTable = nil;
	self.cell = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[recipesTable release];
	[cell release];
	[shoppingListItem release];
	[fetchedResultsController release];
	[managedObjectContext release];
	
    [super dealloc];
}

#pragma mark IBAction
- (IBAction)showRecipe:(id)sender {
	
	for (ShoppingListRecipeCell* aCell in [self.recipesTable visibleCells]) {
		if (aCell.button == sender) {
			NSIndexPath* indexPath = [self.recipesTable indexPathForCell:aCell];
			ShoppingListItem* item = [fetchedResultsController objectAtIndexPath:indexPath];
			[((RecipeAppAppDelegate*)[[UIApplication sharedApplication] delegate]) presentRecipe:item.recipe];
		}
	}	
}

#pragma mark UITableViewDataSource
- (void)fetch {
	NSError *error = nil;
	BOOL success = [self.fetchedResultsController performFetch:&error];
	NSAssert2(success, @"Unhandled error performing fetch at ShoppingListDetailViewController.m, line %d: %@", __LINE__, [error localizedDescription]);
	[self.recipesTable reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"self.ingredient.name = %@ AND self.unit = %@", [shoppingListItem objectForKey:@"Name"], [shoppingListItem objectForKey:@"Unit"]]];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"ShoppingListItem" inManagedObjectContext:self.managedObjectContext]];
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"unit" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"ShoppingListRecipeListCache%@", [shoppingListItem objectForKey:@"Name"]]];
		[fetchedResultsController performFetch:nil];
	}
	
	return fetchedResultsController;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ShoppingListRecipeCell* result;
    static NSString *kCellIdentifier = @"ShoppingListRecipeListItemCell";
    result = (ShoppingListRecipeCell *) [self.recipesTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (result == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ShoppingListRecipeCell" owner:self options:nil];
		result = [cell autorelease];
		cell = nil;
    }
	
    ShoppingListItem* listItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    result.label.text = listItem.recipe.name;
    return result;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Properties
@synthesize recipesTable;
@synthesize cell;
@synthesize shoppingListItem;
@synthesize managedObjectContext;

@end
