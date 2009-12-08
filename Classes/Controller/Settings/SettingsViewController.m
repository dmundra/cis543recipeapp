//
//  SettingsViewController.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "SettingsViewController.h"


@implementation SettingsViewController
#pragma mark View Life Cycle
- (void)viewDidUnload {
	self.settingsTable = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[settingsTable release];
	
    [super dealloc];
}


#pragma mark Properties
@synthesize settingsTable;
@end
