//
//  SettingsViewController.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface SettingsViewController : UIViewController {
	IBOutlet UITableView* settingsTable;
}
@property(nonatomic, retain) UITableView* settingsTable;
@end
