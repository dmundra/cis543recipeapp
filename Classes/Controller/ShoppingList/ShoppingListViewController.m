//
//  ShoppingListViewController.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListViewController.h"
#import "ShoppingListDetailViewController.h"
#import "ShoppingListItem.h"
#import "Ingredient.h"
#import "RecipeItem.h"
#import "Unit.h"

@interface ShoppingListViewController (/*Private*/)
- (void)_updateClearAllButton;
@end

@implementation ShoppingListViewController

#pragma mark Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll:)] autorelease];
	}
	
	return self;
}


#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	// Clear the table data
	[modifiedShoppingList release];
	modifiedShoppingList = nil;
	[self _updateClearAllButton];
	
	[shoppingListTable reloadData];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	self.shoppingListDetailViewController.managedObjectContext = self.managedObjectContext;
}

- (void)viewDidUnload {
	self.shoppingListTable = nil;
	self.shoppingListDetailViewController = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[shoppingListTable release];
	[modifiedShoppingList release];
	[managedObjectContext release];
	[shoppingListDetailViewController release];
	
    [super dealloc];
}

#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[modifiedShoppingList removeObjectAtIndex:indexPath.row];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ShoppingListItemCell";
    UITableViewCell *cell = [self.shoppingListTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    NSMutableDictionary *shoppingListItem = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = [shoppingListItem objectForKey:@"Name"];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity([shoppingListItem objectForKey:@"Quantity"]), NSStringFromUnit([shoppingListItem objectForKey:@"Unit"])];
    return cell;
}

#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)table:(UITableView *)table editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;		
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary* item = [self.tableData objectAtIndex:indexPath.row];
	// Deselect the selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Set the selected recipe on the detail view
	shoppingListDetailViewController.shoppingListItem = item;
	// Show the detail view
	[((UINavigationController*)self.parentViewController) pushViewController:shoppingListDetailViewController animated:YES];
}


- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
	NSMutableDictionary* item = [self.tableData objectAtIndex:indexPath.row];
	UITableViewCell *cell = [self.shoppingListTable cellForRowAtIndexPath:indexPath];
	
	if ([[item objectForKey:@"Purchased"] boolValue]) {
		[cell.textLabel setTextColor:[UIColor blackColor]];
		[item setObject:[NSNumber numberWithBool:NO] forKey:@"Purchased"];
	} else {
		[cell.textLabel setTextColor:[UIColor grayColor]];
		[item setObject:[NSNumber numberWithBool:YES] forKey:@"Purchased"];
	}
}

#pragma mark IBAction
- (void)_updateClearAllButton {
	if ([self.tableData count] == 0) {
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	} else {		
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
}

- (IBAction)clearAll:(id)sender {
	UIActionSheet *action;
	action = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to clear shopping list?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	[action showInView:[[UIApplication sharedApplication] keyWindow]];
	[action release];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"ShoppingListItem" inManagedObjectContext:self.managedObjectContext]];
			
		NSError* error;
		NSArray* shoppingList = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
		if(shoppingList == nil) {
			NSLog(@"Error looking up shopping list items: %@\n%@", error, [error userInfo]);
		}
			
		for (ShoppingListItem* listItem in shoppingList) {
			[managedObjectContext deleteObject:listItem];
		}
			
		// Save the data
		if(![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			} else {
				NSLog(@"  %@", [error userInfo]);
			}
		}
			
		[modifiedShoppingList release];
		modifiedShoppingList = nil;
		[self.shoppingListTable reloadData];
		[self _updateClearAllButton];
	}	
}

#pragma mark Properties
@synthesize shoppingListTable;

@synthesize managedObjectContext;

- (NSArray*)tableData {
	if (modifiedShoppingList == nil) {
		modifiedShoppingList = [[NSMutableArray alloc] init];

		NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"ShoppingListItem" inManagedObjectContext:self.managedObjectContext]];
		
		NSError* error;
		NSArray* shoppingList = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
		if(shoppingList == nil) {
			NSLog(@"Error looking up shopping list items: %@\n%@", error, [error userInfo]);
		}
		
		// Aggregates list by combining similar recipes that have similar units
		for (ShoppingListItem* listItem in shoppingList) {
			BOOL flag = YES;
			for (NSMutableDictionary* listItemAlreadyStored in modifiedShoppingList) {
				if ([listItem.ingredient.name isEqualToString:[listItemAlreadyStored objectForKey:@"Name"]]) {
					if ([listItem.unit isEqualToNumber:[listItemAlreadyStored objectForKey:@"Unit"]]) {
						double temp1 = [[listItemAlreadyStored objectForKey:@"Quantity"] doubleValue]; 
						double temp2 = [listItem.quantity doubleValue];
						
						if( temp1 != -1.0 && temp2 != -1.0) {
							[listItemAlreadyStored setObject:[NSNumber numberWithDouble:(temp1 + temp2)] forKey:@"Quantity"];
						}
						flag = NO;
					}				
				}
			}
			
			if (flag) {
				[modifiedShoppingList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:listItem.ingredient.name, @"Name", listItem.unit, @"Unit", listItem.quantity, @"Quantity", listItem.purchased, @"Purchased", nil]];
			}
		}
		
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ingredient.name" ascending:YES];
		[modifiedShoppingList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		[sortDescriptor release];
	}
		
	return [NSArray arrayWithArray:modifiedShoppingList];
}

@synthesize shoppingListDetailViewController;

@end
