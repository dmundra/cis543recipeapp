//
//  AddToShoppingCartViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AddToShoppingCartViewController.h"
#import "Recipe.h"


@implementation AddToShoppingCartViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.addToCartTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[addToCartTable release];
	
	[recipe release];
	
	[managedObjectContext release];
	
    [super dealloc];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	return result;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	
	return result;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Properties
@synthesize addToCartTable;

@synthesize recipe;

@synthesize managedObjectContext;
@end
