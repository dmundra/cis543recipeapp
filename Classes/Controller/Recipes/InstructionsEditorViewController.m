//
//  InstructionsEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "InstructionsEditorViewController.h"
#import "AbstractTextEditorViewController+Internal.h"


@implementation InstructionsEditorViewController
#pragma mark Memory Management
- (void)dealloc {
	[recipe release];
	
	[managedObjectContext release];
	
	[super dealloc];
}


#pragma mark Internal
- (NSString*)initialValueToEdit {
	NSString* result = nil;
	
	// TODO: Retrieve the instructions from the recipe
	
	return result;
}


- (void)valueChange:(NSString*)newValue shouldSave:(BOOL)shouldSave {
}


#pragma mark Properties
@synthesize recipe;

@synthesize managedObjectContext;
@end
