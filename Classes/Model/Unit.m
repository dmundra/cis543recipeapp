//
//  Unit.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Unit.h"

NSString* NSStringFromUnit(NSNumber* unit) {
	NSInteger value = [unit integerValue];
	NSString* result = nil;
	
	switch(value) {
		case UnitOunce:
			result = @"ounce";
			break;
		case UnitPound:
			result = @"pound";
			break;
		case UnitCup:
			result = @"cup";
			break;
		case UnitTablespoon:
			result = @"tablespoon";
			break;
		case UnitTeaspoon:
			result = @"teaspoon";
			break;
		case UnitIgnored:
		default:
			result = @"";
			break;
	}
	
	return result;
}