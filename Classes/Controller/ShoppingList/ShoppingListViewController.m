//
//  ShoppingListViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListViewController.h"
#import "ShoppingListItem.h"
#import "Ingredient.h"
#import "RecipeItem.h"
#import "Unit.h"

@interface ShoppingListViewController (/*Private*/)
@property(nonatomic, retain, readonly) NSFetchedResultsController* fetchedResultsController;
@end


@implementation ShoppingListViewController

#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.shoppingListTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[shoppingListTable release];
	[fetchedResultsController release];
	[managedObjectContext release];
	
    [super dealloc];
}

- (void)fetch {
	NSError *error = nil;
	BOOL success = [self.fetchedResultsController performFetch:&error];
	NSAssert2(success, @"Unhandled error performing fetch at ShoppingListViewController.m, line %d: %@", __LINE__, [error localizedDescription]);
	[self.shoppingListTable reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"ShoppingListItem" inManagedObjectContext:self.managedObjectContext]];
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ingredient.name" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"ShoppingListCache"];
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
    static NSString *kCellIdentifier = @"ShoppingListItemCell";
    UITableViewCell *cell = [self.shoppingListTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    ShoppingListItem *shoppingListItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = shoppingListItem.ingredient.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity(shoppingListItem.quantity), NSStringFromUnit(shoppingListItem.unit)];
    return cell;
}

#pragma mark Properties
@synthesize shoppingListTable;

@synthesize managedObjectContext;
@end
