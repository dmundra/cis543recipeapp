//
//  PreppedIngredient.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class Ingredient, PreparationMethod, RecipeItem;


@interface PreppedIngredient : NSManagedObject {
}
@property(nonatomic, retain) PreparationMethod* preparationMethod;
@property(nonatomic, retain) NSSet* recipeItems;
@property(nonatomic, retain) Ingredient* ingredient;
@end


@interface PreppedIngredient (CoreDataGeneratedAccessors)
- (void)addRecipeItemsObject:(RecipeItem*)value;
- (void)removeRecipeItemsObject:(RecipeItem*)value;
- (void)addRecipeItems:(NSSet*)value;
- (void)removeRecipeItems:(NSSet*)value;
@end

