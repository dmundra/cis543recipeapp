//
//  DescriptionEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "DescriptionEditorViewController.h"
#import "AbstractTextEditorViewController+Internal.h"
#import "Recipe.h"


@implementation DescriptionEditorViewController
#pragma mark Memory Management
- (void)dealloc {
	[recipe release];
	
	[managedObjectContext release];
	
	[super dealloc];
}


#pragma mark Internal
- (NSString*)_initialValueToEdit {
	return recipe.descriptionText;
}


- (void)_valueChange:(NSString*)newValue shouldSave:(BOOL)shouldSave {
	recipe.descriptionText = newValue;
	
	if(shouldSaveChanges) {
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


#pragma mark Properties
@synthesize recipe;

@synthesize managedObjectContext;
@end
