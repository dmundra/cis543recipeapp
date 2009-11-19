//
//  ShoppingListViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListViewController.h"


@implementation ShoppingListViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.shoppingListTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[shoppingListTable release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize shoppingListTable;
@end
