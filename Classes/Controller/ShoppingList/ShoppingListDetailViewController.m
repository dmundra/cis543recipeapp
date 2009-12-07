//
//  ShoppingListDetailViewController.m
//  RecipeApp
//
//  Created by Daniel Mundra on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListDetailViewController.h"


@implementation ShoppingListDetailViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
}


#pragma mark Memory Management
- (void)dealloc {
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize shoppingListItem;

@synthesize managedObjectContext;

@end
