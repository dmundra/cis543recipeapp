//
//  ShoppingListRecipeCell.m
//  RecipeApp
//
//  Created by Daniel Mundra on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ShoppingListRecipeCell.h"


@implementation ShoppingListRecipeCell
#pragma mark Memory Management
- (void)dealloc {
	[label release];
	[button release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize label;
@synthesize button;
@end
