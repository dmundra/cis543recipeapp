//
//  PreparationMethod.h
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@class PreppedIngredient;


@interface PreparationMethod : NSManagedObject {
}
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSSet* preppedIngredients;
@end


@interface PreparationMethod (CoreDataGeneratedAccessors)
- (void)addPreppedIngredientsObject:(PreppedIngredient*)value;
- (void)removePreppedIngredientsObject:(PreppedIngredient*)value;
- (void)addPreppedIngredients:(NSSet*)value;
- (void)removePreppedIngredients:(NSSet*)value;
@end

