//
//  HelpViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "HelpViewController.h"


@implementation HelpViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.helpTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[helpTable release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize helpTable;
@end
