// 
//  RecipeItem.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeItem.h"
#import "Recipe.h"
#import "PreppedIngredient.h"


@implementation RecipeItem 
#pragma mark Properties (CoreData)
@dynamic quantity;
@dynamic unit;
@dynamic recipe;
@dynamic preppedIngredients;
@end
