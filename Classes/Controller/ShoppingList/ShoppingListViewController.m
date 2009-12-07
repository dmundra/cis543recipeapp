//
//  ShoppingListViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
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
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAll:)];
	}
	
	return self;
}


#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	// Clear the table data
	[modifiedShoppingList release];
	modifiedShoppingList = nil;
	[self _updateClearAllButton];
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
    ShoppingListItem *shoppingListItem = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = shoppingListItem.ingredient.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSStringFromQuantity(shoppingListItem.quantity), NSStringFromUnit(shoppingListItem.unit)];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	ShoppingListItem* item = [self.tableData objectAtIndex:indexPath.row];
	// Deselect the selected cell
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Set the selected recipe on the detail view
	shoppingListDetailViewController.shoppingListItem = item;
	// Show the detail view
	[((UINavigationController*)self.parentViewController) pushViewController:shoppingListDetailViewController animated:YES];
}


- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
	ShoppingListItem* item = [self.tableData objectAtIndex:indexPath.row];
	UITableViewCell *cell = [self.shoppingListTable cellForRowAtIndexPath:indexPath];
	
	if ([item.purchased boolValue]) {
		[cell.textLabel setTextColor:[UIColor blackColor]];
		item.purchased = [NSNumber numberWithBool:NO];
	
		// Save the data
		NSError* error;
		if(![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
		}
	} else {
		[cell.textLabel setTextColor:[UIColor grayColor]];
		item.purchased = [NSNumber numberWithBool:YES];
		
		// Save the data
		NSError* error;
		if(![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
		}
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
			for (ShoppingListItem* listItemAlreadyStored in modifiedShoppingList) {
				if ([listItem.ingredient.name isEqualToString:listItemAlreadyStored.ingredient.name]) {
					if (listItem.unit == listItemAlreadyStored.unit) {
						double temp1 = [listItemAlreadyStored.quantity doubleValue]; 
						double temp2 = [listItem.quantity doubleValue];
						listItemAlreadyStored.quantity = [NSNumber numberWithDouble:(temp1 + temp2)];
						flag = NO;
					}				
				}
			}
			
			if (flag) {
				[modifiedShoppingList addObject:listItem];
			}
		}
		
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ingredient.name" ascending:YES];
		[modifiedShoppingList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	}
		
	return [NSArray arrayWithArray:modifiedShoppingList];
}

@synthesize shoppingListDetailViewController;

@end
