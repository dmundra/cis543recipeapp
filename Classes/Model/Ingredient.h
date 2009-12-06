//
//  Ingredient.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class PreppedIngredient, ShoppingListItem;


@interface Ingredient : NSManagedObject {
}
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSSet* ingredients;
@property(nonatomic, retain) NSSet* preppedIngredients;
@property(nonatomic, retain) NSSet* shoppingListItems;
@end


@interface Ingredient (CoreDataGeneratedAccessors)
- (void)addIngredientsObject:(Ingredient*)value;
- (void)removeIngredientsObject:(Ingredient*)value;
- (void)addIngredients:(NSSet*)value;
- (void)removeIngredients:(NSSet*)value;

- (void)addPreppedIngredientsObject:(PreppedIngredient*)value;
- (void)removePreppedIngredientsObject:(PreppedIngredient*)value;
- (void)addPreppedIngredients:(NSSet*)value;
- (void)removePreppedIngredients:(NSSet*)value;

- (void)addShoppingListItemsObject:(ShoppingListItem*)value;
- (void)removeShoppingListItemsObject:(ShoppingListItem*)value;
- (void)addShoppingListItems:(NSSet*)value;
- (void)removeShoppingListItems:(NSSet*)value;
@end

