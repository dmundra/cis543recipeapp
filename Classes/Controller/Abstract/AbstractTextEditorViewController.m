//
//  AbstractTextEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractTextEditorViewController.h"
#import "AbstractTextEditorViewController+Internal.h"


@implementation AbstractTextEditorViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.textEditorTable = nil;
	self.textViewCell = nil;
	self.textView = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[textEditorTable release];
	[textViewCell release];
	[textView release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize textEditorTable;
@synthesize textViewCell;
@synthesize textView;

@synthesize shouldSaveChanges;
@end
