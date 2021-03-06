//
//  RecipeAppAppDelegate.m
//  RecipeApp
//
//  Created by Charles Augustine, Karen Sottile, Daniel Mundra, Megen Brittell on 11/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import "RecipeAppAppDelegate.h"
#import "RecipesViewController.h"
#import "ShoppingListViewController.h"
#import "Ingredient.h"
#import "PreparationMethod.h"
#import "PreppedIngredient.h"
#import "Recipe.h"
#import "RecipeItem.h"
#import "ShoppingListItem.h"
#import "Unit.h"


static NSString* const kDefaultsKeyDefaultPreferencesCreated = @"DefaultsKeyDefaultPreferencesCreated";


@interface RecipeAppAppDelegate (/*Private*/)
- (void)_addExampleRecipes;

@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property(nonatomic, retain, readonly) NSManagedObjectModel* managedObjectModel;
@property(nonatomic, retain, readonly) NSString* applicationDocumentsDirectory;
@end


@implementation RecipeAppAppDelegate
#pragma mark Application Lifecycle
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Setup the default user preferences and test data as necessary
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if(![defaults boolForKey:kDefaultsKeyDefaultPreferencesCreated]) {	
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		[self _addExampleRecipes];
		
		// Save the data
		NSError* error;
		if(![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
			
			// Fail
			abort();
		}
		
		[self.managedObjectContext reset];
		
		[defaults setBool:YES forKey:kDefaultsKeyDefaultPreferencesCreated];
		[defaults synchronize];
		
		[pool drain];
	}	
	
	// Set the recipe/shopping list views managed object context
	recipesViewController.managedObjectContext = self.managedObjectContext;
	shoppingListViewController.managedObjectContext = self.managedObjectContext;
	
	// Add the top level view controller to the window and display it
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {	
    NSError* error = nil;
    if(managedObjectContext != nil) {
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Error saving managed object context %@, %@", error, [error userInfo]);
        } 
    }
}


#pragma mark Memory Management
- (void)dealloc {	
	[window release];
	[tabBarController release];
	[recipeNavController release];
	[shoppingListNavController release];
	[settingsNavController release];
	[helpNavController release];
	[recipesViewController release];
	[shoppingListViewController release];
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[super dealloc];
}


#pragma mark Public
- (void)presentRecipe:(Recipe*)recipe {
	[recipeNavController popToRootViewControllerAnimated:NO];
	[tabBarController setSelectedViewController:recipeNavController];
	[self performSelector:@selector(_pushRecipeDetail:) withObject:recipe afterDelay:0.1];
}


- (void)_pushRecipeDetail:(Recipe*)recipe {
	[recipesViewController showDetailViewForRecipe:recipe];
}


#pragma mark Private
- (void)_addExampleRecipes {
	PreparationMethod* sliced = [NSEntityDescription insertNewObjectForEntityForName:@"PreparationMethod" inManagedObjectContext:self.managedObjectContext];
	sliced.name = @"sliced";
	PreparationMethod* chopped = [NSEntityDescription insertNewObjectForEntityForName:@"PreparationMethod" inManagedObjectContext:self.managedObjectContext];
	chopped.name = @"chopped";
	
	Ingredient* mushroom = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	mushroom.name = @"mushroom";
	Ingredient* onion = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	onion.name = @"onion";
	Ingredient* butter = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	butter.name = @"butter";
	Ingredient* flour = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	flour.name = @"flour";
	Ingredient* skimMilk = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	skimMilk.name = @"skim milk";
	Ingredient* dillWeed = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	dillWeed.name = @"dill weed";
	Ingredient* paprika = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	paprika.name = @"paprika";
	Ingredient* soySauce = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	soySauce.name = @"soy sauce";
	Ingredient* salt = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	salt.name = @"salt";
	Ingredient* stock = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	stock.name = @"stock";
	Ingredient* freshLemonJuice = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	freshLemonJuice.name = @"fresh lemon juice";
	Ingredient* parsley = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	parsley.name = @"parsley";
	Ingredient* pepper = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	pepper.name = @"pepper";
	Ingredient* sourCream = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	sourCream.name = @"sour cream";
	
	Recipe* hungarianMushroomSoup = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
	hungarianMushroomSoup.name = @"Hungarian Mushroom Soup";
	hungarianMushroomSoup.source = @"The Moosewood Cookbook";
	hungarianMushroomSoup.instructions = @"1. Saute onions in 2 Tbsp stock, salt lightly. A few minutes later, add mushrooms, 1 tsp dill, 1/2 cup stock or water, tamari, and paprika. Cover and simmer 15 minutes.\n\n2. Melt butter in large saucepan. Whisk in flour and cook, whisking, a few minutes. Add milk. Cook, stirring frequently, over low heat about 10 minutes - until thick.\n\n3. Stir in mushroom mixture and remaining stock. Cover and simmer 10-15 minutes.\n\n4. Just before serving, add salt, pepper, lemon juice, sour cream, and if desired extra dill (1 tsp). Serve garnished with parsley.";
	hungarianMushroomSoup.preparationTime = [NSNumber numberWithInteger:60];
	hungarianMushroomSoup.servingSize = [NSNumber numberWithInteger:4];
	
	PreppedIngredient* slicedMushroom = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	slicedMushroom.ingredient = mushroom;
	slicedMushroom.preparationMethod = sliced;
	
	PreppedIngredient* choppedOnion = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	choppedOnion.ingredient = onion;
	choppedOnion.preparationMethod = chopped;
	
	PreppedIngredient* choppedParsley = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	choppedParsley.ingredient = parsley;
	choppedParsley.preparationMethod = chopped;
	
	RecipeItem* itemOne = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemOne.preppedIngredient = slicedMushroom;
	itemOne.orderIndex = [NSNumber numberWithInteger:0];
	itemOne.quantity = [NSNumber numberWithDouble:12.0];
	itemOne.unit = [NSNumber numberWithInteger:UnitOunce];
	RecipeItem* itemTwo = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTwo.preppedIngredient = choppedOnion;
	itemTwo.orderIndex = [NSNumber numberWithInteger:1];
	itemTwo.quantity = [NSNumber numberWithDouble:2.0];
	itemTwo.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemThree = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemThree.ingredient = butter;
	itemThree.orderIndex = [NSNumber numberWithInteger:2];
	itemThree.quantity = [NSNumber numberWithDouble:2.0];
	itemThree.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemFour = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFour.ingredient = flour;
	itemFour.orderIndex = [NSNumber numberWithInteger:3];
	itemFour.quantity = [NSNumber numberWithDouble:3.0];
	itemFour.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemFive = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFive.ingredient = skimMilk;
	itemFive.orderIndex = [NSNumber numberWithInteger:4];
	itemFive.quantity = [NSNumber numberWithDouble:1.0];
	itemFive.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemSix = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemSix.ingredient = dillWeed;
	itemSix.orderIndex = [NSNumber numberWithInteger:5];
	itemSix.quantity = [NSNumber numberWithDouble:2.0];
	itemSix.unit = [NSNumber numberWithInteger:UnitTeaspoon];
	RecipeItem* itemSeven = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemSeven.ingredient = paprika;
	itemSeven.orderIndex = [NSNumber numberWithInteger:6];
	itemSeven.quantity = [NSNumber numberWithDouble:1.0];
	itemSeven.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemEight = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemEight.ingredient = soySauce;
	itemEight.orderIndex = [NSNumber numberWithInteger:7];
	itemEight.quantity = [NSNumber numberWithDouble:1.0];
	itemEight.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemNine = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemNine.ingredient = salt;
	itemNine.orderIndex = [NSNumber numberWithInteger:8];
	itemNine.quantity = [NSNumber numberWithDouble:1.0];
	itemNine.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemTen = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTen.ingredient = stock;
	itemTen.orderIndex = [NSNumber numberWithInteger:9];
	itemTen.quantity = [NSNumber numberWithDouble:2.0];
	itemTen.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemEleven = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemEleven.ingredient = freshLemonJuice;
	itemEleven.orderIndex = [NSNumber numberWithInteger:10];
	itemEleven.quantity = [NSNumber numberWithDouble:2.0];
	itemEleven.unit = [NSNumber numberWithInteger:UnitTeaspoon];
	RecipeItem* itemTwelve = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTwelve.ingredient = parsley;
	itemTwelve.orderIndex = [NSNumber numberWithInteger:11];
	itemTwelve.quantity = [NSNumber numberWithDouble:0.25];
	itemTwelve.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemThirteen = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemThirteen.ingredient = pepper;
	itemThirteen.orderIndex = [NSNumber numberWithInteger:12];
	itemThirteen.quantity = [NSNumber numberWithDouble:kQuantityToTaste];
	itemThirteen.unit = [NSNumber numberWithInteger:UnitIgnored];
	RecipeItem* itemFourteen = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFourteen.ingredient = sourCream;
	itemFourteen.orderIndex = [NSNumber numberWithInteger:13];
	itemFourteen.quantity = [NSNumber numberWithDouble:0.5];
	itemFourteen.unit = [NSNumber numberWithInteger:UnitCup];
	
	[hungarianMushroomSoup setRecipeItems:[NSSet setWithObjects:itemOne, itemTwo, itemThree, itemFour, itemFive, itemSix, itemSeven, itemEight, itemNine, itemTen, itemEleven, itemTwelve, itemThirteen, itemFourteen, nil]];


	PreparationMethod* diced = [NSEntityDescription insertNewObjectForEntityForName:@"PreparationMethod" inManagedObjectContext:self.managedObjectContext];
	diced.name = @"diced";
	
	Ingredient* vegetableOil = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	vegetableOil.name = @"vegetable oil";
	Ingredient* cabbage = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	cabbage.name = @"cabbage";
	Ingredient* celery = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	celery.name = @"celery";
	Ingredient* sugar = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	sugar.name = @"sugar";
	Ingredient* chickenBroth = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	chickenBroth.name = @"chicken broth";
	Ingredient* water = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	water.name = @"water";
	Ingredient* sesameOil = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	sesameOil.name = @"sesame oil";
	Ingredient* cornStarch = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	cornStarch.name = @"corn starch";
	Ingredient* cookedTurkey = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	cookedTurkey.name = @"cooked turkey";
	Ingredient* cookedRice = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	cookedRice.name = @"cooked rice";
	Ingredient* almonds = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	almonds.name = @"almonds";
	
	Recipe* turkeyChowMein = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
	turkeyChowMein.name = @"Turkey Chow Mein";
	turkeyChowMein.source = @"Epicurious.com";
	turkeyChowMein.instructions = @"In a large heavy skillet heat the vegetable oil until it is hot but not smoking and in it, stir-fry the onion, the cabbage, and the celery for 3 minutes, or until the cabbage is wilted. Add the sugar, the broth, the water, the soy sauce, and the sesame oil and simmer the mixture, covered, for 3 minutes. Stir the cornstarch mixture, stir it into the vegetable mixture, and bring the liquid to a boil. Stir in the turkey and simmer the chow mein until it is heated through. Serve the chow mein over the rice and sprinkle with the almonds.";
	turkeyChowMein.preparationTime = [NSNumber numberWithInteger:45];
	turkeyChowMein.servingSize = [NSNumber numberWithInteger:2];
	
	PreppedIngredient* slicedOnion = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	slicedOnion.ingredient = onion;
	slicedOnion.preparationMethod = sliced;
	
	PreppedIngredient* slicedCabbage = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	slicedCabbage.ingredient = cabbage;
	slicedCabbage.preparationMethod = sliced;
	
	PreppedIngredient* slicedCelery = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	slicedCelery.ingredient = celery;
	slicedCelery.preparationMethod = sliced;
	
	PreppedIngredient* dicedCookedTurkey = [NSEntityDescription insertNewObjectForEntityForName:@"PreppedIngredient" inManagedObjectContext:self.managedObjectContext];
	dicedCookedTurkey.ingredient = cookedTurkey;
	dicedCookedTurkey.preparationMethod = diced;
	
	RecipeItem* itemOne2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemOne2.ingredient = vegetableOil;
	itemOne2.orderIndex = [NSNumber numberWithInteger:0];
	itemOne2.quantity = [NSNumber numberWithDouble:2.0];
	itemOne2.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemTwo2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTwo2.preppedIngredient = slicedOnion;
	itemTwo2.orderIndex = [NSNumber numberWithInteger:1];
	itemTwo2.quantity = [NSNumber numberWithDouble:0.5];
	itemTwo2.unit = [NSNumber numberWithInteger:UnitIgnored];
	RecipeItem* itemThree2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemThree2.preppedIngredient = slicedCabbage;
	itemThree2.orderIndex = [NSNumber numberWithInteger:2];
	itemThree2.quantity = [NSNumber numberWithDouble:4.0];
	itemThree2.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemFour2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFour2.preppedIngredient = slicedCelery;
	itemFour2.orderIndex = [NSNumber numberWithInteger:3];
	itemFour2.quantity = [NSNumber numberWithDouble:1.0];
	itemFour2.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemFive2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFive2.ingredient = sugar;
	itemFive2.orderIndex = [NSNumber numberWithInteger:4];
	itemFive2.quantity = [NSNumber numberWithDouble:0.5];
	itemFive2.unit = [NSNumber numberWithInteger:UnitTeaspoon];
	RecipeItem* itemSix2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemSix2.ingredient = chickenBroth;
	itemSix2.orderIndex = [NSNumber numberWithInteger:5];
	itemSix2.quantity = [NSNumber numberWithDouble:0.75];
	itemSix2.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemSeven2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemSeven2.ingredient = water;
	itemSeven2.orderIndex = [NSNumber numberWithInteger:6];
	itemSeven2.quantity = [NSNumber numberWithDouble:0.25];
	itemSeven2.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemEight2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemEight2.ingredient = soySauce;
	itemEight2.orderIndex = [NSNumber numberWithInteger:7];
	itemEight2.quantity = [NSNumber numberWithDouble:1.0];
	itemEight2.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemNine2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemNine2.ingredient = sesameOil;
	itemNine2.orderIndex = [NSNumber numberWithInteger:8];
	itemNine2.quantity = [NSNumber numberWithDouble:1.0];
	itemNine2.unit = [NSNumber numberWithInteger:UnitTeaspoon];
	RecipeItem* itemTen2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTen2.ingredient = cornStarch;
	itemTen2.orderIndex = [NSNumber numberWithInteger:9];
	itemTen2.quantity = [NSNumber numberWithDouble:1.0];
	itemTen2.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemEleven2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemEleven2.preppedIngredient = dicedCookedTurkey;
	itemEleven2.orderIndex = [NSNumber numberWithInteger:10];
	itemEleven2.quantity = [NSNumber numberWithDouble:2.0];
	itemEleven2.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemTwelve2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTwelve2.ingredient = cookedRice;
	itemTwelve2.orderIndex = [NSNumber numberWithInteger:11];
	itemTwelve2.quantity = [NSNumber numberWithDouble:1];
	itemTwelve2.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemThirteen2 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemThirteen2.ingredient = almonds;
	itemThirteen2.orderIndex = [NSNumber numberWithInteger:12];
	itemThirteen2.quantity = [NSNumber numberWithDouble:0.25];
	itemThirteen2.unit = [NSNumber numberWithInteger:UnitCup];
	
	[turkeyChowMein setRecipeItems:[NSSet setWithObjects:itemOne2, itemTwo2, itemThree2, itemFour2, itemFive2, itemSix2, itemSeven2, itemEight2, itemNine2, itemTen2, itemEleven2, itemTwelve2, itemThirteen2, nil]];


	Ingredient* largeEggs = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	largeEggs.name = @"large eggs";
	Ingredient* granulatedSugar = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	granulatedSugar.name = @"granulated sugar";
	Ingredient* hotshortbreadBase = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	hotshortbreadBase.name = @"hotshortbread base";
	Ingredient* confectionersSugar = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.managedObjectContext];
	confectionersSugar.name = @"confectioners' sugar";
	
	Recipe* lemonBars = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
	lemonBars.name = @"Lemon Bars";
	lemonBars.source = @"Epicurious.com";
	lemonBars.instructions = @"Preheat oven to 350 degrees farenheit. \nIn a bowl whisk together eggs and granulated sugar until combined well and stir in lemon juice and flour. Pour lemon mixture over hot shortbread. Reduce oven temperature to 300°F. and bake confection in middle of oven until set, about 30 minutes. Cool completely in pan and cut into 24 bars. Bar cookies keep, covered and chilled, 3 days. Sift confectioners' sugar over bars before serving.";
	lemonBars.preparationTime = [NSNumber numberWithInteger:45];
	lemonBars.servingSize = [NSNumber numberWithInteger:12];
	
	RecipeItem* itemOne3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemOne3.ingredient = largeEggs;
	itemOne3.orderIndex = [NSNumber numberWithInteger:0];
	itemOne3.quantity = [NSNumber numberWithDouble:4.0];
	itemOne3.unit = [NSNumber numberWithInteger:UnitIgnored];
	RecipeItem* itemTwo3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemTwo3.ingredient = granulatedSugar;
	itemTwo3.orderIndex = [NSNumber numberWithInteger:1];
	itemTwo3.quantity = [NSNumber numberWithDouble:1.5];
	itemTwo3.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemThree3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemThree3.ingredient = freshLemonJuice;
	itemThree3.orderIndex = [NSNumber numberWithInteger:2];
	itemThree3.quantity = [NSNumber numberWithDouble:0.75];
	itemThree3.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemFour3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFour3.ingredient = flour;
	itemFour3.orderIndex = [NSNumber numberWithInteger:3];
	itemFour3.quantity = [NSNumber numberWithDouble:0.33];
	itemFour3.unit = [NSNumber numberWithInteger:UnitCup];
	RecipeItem* itemFive3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemFive3.ingredient = hotshortbreadBase;
	itemFive3.orderIndex = [NSNumber numberWithInteger:4];
	itemFive3.quantity = [NSNumber numberWithDouble:1.0];
	itemFive3.unit = [NSNumber numberWithInteger:UnitIgnored];
	RecipeItem* itemSix3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemSix3.ingredient = confectionersSugar;
	itemSix3.orderIndex = [NSNumber numberWithInteger:5];
	itemSix3.quantity = [NSNumber numberWithDouble:3.0];
	itemSix3.unit = [NSNumber numberWithInteger:UnitTablespoon];
	RecipeItem* itemSeven3 = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeItem" inManagedObjectContext:self.managedObjectContext];
	itemSeven3.ingredient = salt;
	itemSeven3.orderIndex = [NSNumber numberWithInteger:6];
	itemSeven3.quantity = [NSNumber numberWithDouble:0.5];
	itemSeven3.unit = [NSNumber numberWithInteger:UnitTablespoon];
	
	[lemonBars setRecipeItems:[NSSet setWithObjects:itemOne3, itemTwo3, itemThree3, itemFour3, itemFive3, itemSix3, itemSeven3, nil]];
}


#pragma mark Properties
@synthesize window;
@synthesize tabBarController;
@synthesize recipeNavController;
@synthesize shoppingListNavController;
@synthesize settingsNavController;
@synthesize helpNavController;
@synthesize recipesViewController;
@synthesize shoppingListViewController;


- (NSManagedObjectContext*)managedObjectContext {
    if(managedObjectContext == nil) {
		NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
		
		if(coordinator != nil) {
			managedObjectContext = [[NSManagedObjectContext alloc] init];
			[managedObjectContext setPersistentStoreCoordinator:coordinator];
			[managedObjectContext setUndoManager:nil];
		}
	}
	
    return managedObjectContext;
}


#pragma mark Properties (Private)
- (NSManagedObjectModel*)managedObjectModel {	
    if(managedObjectModel == nil) {
		managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    }
	
    return managedObjectModel;
}


- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    if(persistentStoreCoordinator == nil) {
		NSURL* storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"RecipeApp.sqlite"]];
		
		NSError* error;
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
			NSLog(@"Error adding persistent store to the persistent store coordinator: %@", [error localizedDescription]);
			exit(-1);
		}
	}
	
    return persistentStoreCoordinator;
}


- (NSString*)applicationDocumentsDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
	return basePath;
}
@end

