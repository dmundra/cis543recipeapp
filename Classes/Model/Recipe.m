// 
//  Recipe.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Recipe.h"
#import "RecipeImage.h"
#import "RecipeItem.h"
#import "ShoppingListItem.h"


@implementation Recipe 
#pragma mark Properties (CoreData)
@dynamic category;
@dynamic descriptionText;
@dynamic image;
@dynamic instructions;
@dynamic name;
@dynamic preparationTime;
@dynamic servingSize;
@dynamic source;
@dynamic recipeItems;
@dynamic shoppingListItems;


#pragma mark Properties (Derived)
- (NSArray*)sortedRecipeItems {
	// Sort the recipe items by order index
	NSArray* result = nil;
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:NO];
	result = [[self.recipeItems allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	return result;
}
@end


NSString* NSStringFromCategory(NSNumber* category) {
	NSInteger value = [category integerValue];
	NSString* result = nil;
	
	switch(value) {
		case CategoryBeverage:
			result = @"Beverage";
			break;
		case CategoryBread:
			result = @"Bread";
			break;
		case CategoryMainDish:
			result = @"Main Dish";
			break;
		case CategorySoup:
			result = @"Soup";
			break;
		case CategorySandwich:
			result = @"Sandwich";
			break;
		case CategorySideDish:
			result = @"Side Dish";
			break;
		case CategorySalad:
			result = @"Salad";
			break;
		case CategoryDessert:
			result = @"Dessert";
			break;
	}
	
	return result;
}