//
//  IngredientSearchOrCreateViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractSearchOrCreateViewController.h"

@class Ingredient;

@protocol IngredientSearchOrCreateViewControllerDelegate;


@interface IngredientSearchOrCreateViewController : AbstractSearchOrCreateViewController {
	NSString* ingredientName;
	
	NSArray* ingredients;
	
	IBOutlet id <IngredientSearchOrCreateViewControllerDelegate> delegate;
}
@property(nonatomic, retain) NSString* ingredientName;

@property(nonatomic, assign) id <IngredientSearchOrCreateViewControllerDelegate> delegate;
@end


@protocol IngredientSearchOrCreateViewControllerDelegate <NSObject>
- (void)didChooseIngredient:(Ingredient*)ingredient;
- (void)didCreateNewIngredient:(NSString*)ingredientName;
@end
