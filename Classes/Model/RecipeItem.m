// 
//  RecipeItem.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeItem.h"
#import "Recipe.h"
#import "PreppedIngredient.h"


double const kQuantityToTaste = -1.0;


@implementation RecipeItem 
#pragma mark Properties (CoreData)
@dynamic orderIndex;
@dynamic quantity;
@dynamic unit;
@dynamic ingredient;
@dynamic preppedIngredient;
@dynamic recipe;
@end

NSString* NSStringFromQuantity(NSNumber* quantity) {
	double value = [quantity doubleValue];
	NSString* result = nil;
	static NSNumberFormatter* numberFormatter;	
	if(numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[numberFormatter setMinimumIntegerDigits:0];
		[numberFormatter setMaximumFractionDigits:2];
	}
	
	if(value >= (kQuantityToTaste - 0.1) && value <= (kQuantityToTaste + 0.1)) {
		result = @"add to taste";
	} else {		
		result = [numberFormatter stringFromNumber:quantity];
	}
	
	return result;
}