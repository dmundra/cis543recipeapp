//
//  HelpViewController.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface HelpViewController : UIViewController <UITableViewDataSource> {
	IBOutlet UITableView* helpTable;
	IBOutlet UITableViewCell* helpCell;
}
@property(nonatomic, retain) UITableView* helpTable;
@property(nonatomic, retain) UITableViewCell* helpCell;
@end
