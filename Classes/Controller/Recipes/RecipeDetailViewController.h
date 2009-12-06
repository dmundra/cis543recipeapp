//
//  RecipeDetailViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe;


@interface RecipeDetailViewController : UIViewController {
	Recipe* recipe;
	
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
