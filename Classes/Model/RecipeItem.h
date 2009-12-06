//
//  RecipeItem.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class PreppedIngredient, Recipe;


@interface RecipeItem : NSManagedObject {
}
@property(nonatomic, retain) NSNumber* orderIndex;
@property(nonatomic, retain) NSNumber* quantity;
@property(nonatomic, retain) NSNumber* unit;
@property(nonatomic, retain) Ingredient* ingredient;
@property(nonatomic, retain) PreppedIngredient* preppedIngredient;
@property(nonatomic, retain) Recipe* recipe;
@end



