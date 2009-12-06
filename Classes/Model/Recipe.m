// 
//  Recipe.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Recipe.h"
#import "RecipeItem.h"
#import "ShoppingListItem.h"


@implementation Recipe 
#pragma mark Properties (CoreData)
@dynamic category;
@dynamic description;
@dynamic instructions;
@dynamic name;
@dynamic preparationTime;
@dynamic servingSize;
@dynamic source;
@dynamic recipeItems;
@dynamic shoppingListItems;
@end
