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


double const kQuantityToTaste = -1;


@implementation RecipeItem 
#pragma mark Properties (CoreData)
@dynamic orderIndex;
@dynamic quantity;
@dynamic unit;
@dynamic ingredient;
@dynamic preppedIngredient;
@dynamic recipe;
@end
