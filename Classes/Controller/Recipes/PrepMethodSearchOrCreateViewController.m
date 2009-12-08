//
//  PrepMethodSearchOrCreateViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "PrepMethodSearchOrCreateViewController.h"
#import "AbstractSearchOrCreateViewController+Internal.h"


@implementation PrepMethodSearchOrCreateViewController
#pragma mark Memory Management
- (void)dealloc {
	[preparationMethodName release];
	[preparationMethods release];
	
	// delegate not retained
	
	[super dealloc];
}


#pragma mark Internal
- (NSArray*)_names {
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PreparationMethod" inManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
	
	[preparationMethods release];
	preparationMethods = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] retain];
	
	return [preparationMethods valueForKey:@"name"];
}


- (NSString*)_initialFilterTerm {
	return preparationMethodName;
}


- (void)_choseNameAtIndex:(NSInteger)index {
	[delegate didChoosePrepMethod:[preparationMethods objectAtIndex:index]];
}


- (void)_createdName:(NSString *)result {
	[delegate didCreateNewPrepMethod:result];
}


#pragma mark Properties
@synthesize preparationMethodName;

@synthesize delegate;
@end
