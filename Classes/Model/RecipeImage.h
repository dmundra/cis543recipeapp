//
//  RecipeImage.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Recipe;


@interface RecipeImage : NSManagedObject {
}
@property(nonatomic, retain) NSData* data;
@property(nonatomic, retain) Recipe* recipe;
@end



