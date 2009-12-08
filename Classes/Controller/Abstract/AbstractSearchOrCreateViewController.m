//
//  AbstractSearchOrCreateViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractSearchOrCreateViewController.h"


@implementation AbstractSearchOrCreateViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Memory Management
- (void)dealloc {
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)done:(id)sender {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


#pragma mark Properties
@end
