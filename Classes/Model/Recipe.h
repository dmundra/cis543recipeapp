//
//  Recipe.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class RecipeItem, ShoppingListItem;


@interface Recipe : NSManagedObject {
}
@property(nonatomic, retain) NSNumber* category;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSString* instructions;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSNumber* preparationTime;
@property(nonatomic, retain) NSNumber* servingSize;
@property(nonatomic, retain) NSString* source;
@property(nonatomic, retain) NSSet* recipeItems;
@property(nonatomic, retain) NSSet* shoppingListItems;

@property(nonatomic, retain) NSArray* sortedRecipeItems;
@end


@interface Recipe (CoreDataGeneratedAccessors)
- (void)addRecipeItemsObject:(RecipeItem*)value;
- (void)removeRecipeItemsObject:(RecipeItem*)value;
- (void)addRecipeItems:(NSSet*)value;
- (void)removeRecipeItems:(NSSet*)value;

- (void)addShoppingListItemsObject:(ShoppingListItem*)value;
- (void)removeShoppingListItemsObject:(ShoppingListItem*)value;
- (void)addShoppingListItems:(NSSet*)value;
- (void)removeShoppingListItems:(NSSet*)value;
@end

