// 
//  Recipe.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Recipe.h"
#import "RecipeImage.h"
#import "RecipeItem.h"
#import "ShoppingListItem.h"


const NSInteger kPreparationTimeNotSet = 0;
const NSInteger kServingSizeNotSet = 0;


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
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
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


extern NSString* NSStringFromPreparationTime(NSNumber* preparationTime) {
	NSInteger value = [preparationTime integerValue];
	NSString* result = nil;
	
	NSInteger minutes = 0;
	NSInteger hours = 0;
	
	hours = value / 60;
	minutes = value % 60;
	
	NSString* hoursString = @"";
	if(hours > 0) {
		hoursString = [NSString stringWithFormat:@"%d hour%@", hours, (hours == 1 ? @"" : @"s")];
	}
	
	NSString* minutesString = @"";
	if(minutes > 0) {
		minutesString = [NSString stringWithFormat:@"%d minute%@", minutes, (minutes == 1 ? @"" : @"s")];
	}
	
	if(value != kPreparationTimeNotSet) {
		if([hoursString length] > 0 && [minutesString length] > 0) {
			result = [NSString stringWithFormat:@"%@, %@", hoursString, minutesString];
		}
		else if([hoursString length] > 0) {
			result = hoursString;
		}
		else {
			result = minutesString;
		}
	}
	else {
		result = @"Not set";
	}
	
	return result;
}


extern NSString* NSStringFromServingSize(NSNumber* servingSize) {
	NSInteger value = [servingSize integerValue];
	NSString* result = nil;
	
	if(value != kServingSizeNotSet) {
		result = [NSString stringWithFormat:@"%d serving%@", value, (value == 1 ? @"" : @"s")];
	}
	else {
		result = @"Not set";
	}
	
	return result;
}