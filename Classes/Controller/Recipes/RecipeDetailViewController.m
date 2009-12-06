//
//  RecipeDetailViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeDetailViewController.h"


@implementation RecipeDetailViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
}


#pragma mark Memory Management
- (void)dealloc {
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize recipe;

@synthesize managedObjectContext;
@end
