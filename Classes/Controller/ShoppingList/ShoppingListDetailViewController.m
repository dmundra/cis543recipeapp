//
//  ShoppingListDetailViewController.m
//  RecipeApp
//
//  Created by Daniel Mundra on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListDetailViewController.h"
#import "ShoppingListItem.h"
#import "Ingredient.h"
#import "Recipe.h"
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
}


#pragma mark Memory Management
- (void)dealloc {
	[recipesTable release];
	[managedObjectContext release];
	
    [super dealloc];
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
    static NSString *kCellIdentifier = @"ShoppingListRecipeListItemCell";
    UITableViewCell *cell = [self.recipesTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    ShoppingListItem* listItem = nil;
	listItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = listItem.recipe.name;
	
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Properties
@synthesize recipesTable;
@synthesize shoppingListItem;
@synthesize managedObjectContext;

@end
