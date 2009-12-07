//
//  DescriptionEditorViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractTextEditorViewController.h"

@class Recipe;


@interface DescriptionEditorViewController : AbstractTextEditorViewController {
	Recipe* recipe;
	
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic, retain) Recipe* recipe;

@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@end
