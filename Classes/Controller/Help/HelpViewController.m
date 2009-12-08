//
//  HelpViewController.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "HelpViewController.h"


@implementation HelpViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.helpTable = nil;
	self.helpCell = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[helpTable release];
	[helpCell release];
	
    [super dealloc];
}


#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return helpCell;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 1;
}


#pragma mark Properties
@synthesize helpTable;
@synthesize helpCell;
@end
