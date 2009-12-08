//
//  Unit.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


typedef enum {
	UnitIgnored,
	UnitOunce,
	UnitPound,
	UnitCup,
	UnitTablespoon,
	UnitTeaspoon,
	UnitCount
} Unit;


// Returns a string representation of the unit value
extern NSString* NSStringFromUnit(NSNumber* unit);