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
		case Ounce:
			result = @"ounce";
			break;
		case Pound:
			result = @"pound";
			break;
		case Tablespoon:
			result = @"tablespoon";
			break;
		case Teaspoon:
			result = @"teaspoon";
			break;
		case UnitIgnored:
		default:
			result = @"";
			break;
	}
	
	return result;
}