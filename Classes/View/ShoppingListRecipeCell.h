//
//  ShoppingListRecipeCell.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShoppingListRecipeCell : UITableViewCell {
    IBOutlet UILabel *label;
	IBOutlet UIButton *button;
}
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIButton *button;
@end
