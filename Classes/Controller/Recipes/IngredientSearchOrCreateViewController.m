//
//  IngredientSearchOrCreateViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "IngredientSearchOrCreateViewController.h"
#import "AbstractSearchOrCreateViewController+Internal.h"


@implementation IngredientSearchOrCreateViewController
#pragma mark Memory Management
- (void)dealloc {
	[ingredientName release];
	[ingredients release];
	
	// delegate not retained
	
	[super dealloc];
}


#pragma mark Internal
- (NSArray*)_names {
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	[ingredients release];
	ingredients = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] retain];
	[fetchRequest release];
	
	return [ingredients valueForKey:@"name"];
}


- (NSString*)_navTitle {
	return @"Pick Ingredient";
}


- (NSString*)_nameLabel {
	return @"Ingredient:";
}


- (NSString*)_initialFilterTerm {
	return ingredientName;
}


- (void)_choseNameAtIndex:(NSInteger)index {
	[delegate didChooseIngredient:[ingredients objectAtIndex:index]];
}


- (void)_createdName:(NSString *)result {
	[delegate didCreateNewIngredient:result];
}


#pragma mark Properties
@synthesize ingredientName;

@synthesize delegate;
@end
