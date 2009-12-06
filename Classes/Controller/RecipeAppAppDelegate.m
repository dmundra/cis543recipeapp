//
//  RecipeAppAppDelegate.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import "RecipeAppAppDelegate.h"


static NSString* const kDefaultsKeyDefaultPreferencesCreated = @"DefaultsKeyDefaultPreferencesCreated";


@interface RecipeAppAppDelegate (/*Private*/)
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain, readonly) NSString* applicationDocumentsDirectory;
@end


@implementation RecipeAppAppDelegate
#pragma mark Application Lifecycle
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Setup the default user preferences and test data as necessary
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if(![defaults boolForKey:kDefaultsKeyDefaultPreferencesCreated]) {	
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
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
		hungarianMushroomSoup.instructions = @"1. Saute onions in 2 Tbsp stock, salt lightly. A few minutes later, add mushrooms, 1 tsp dill, 1/2 cup stock or water, tamari, and paprika. Cover and simmer 15 minutes.\n2. Melt butter in large saucepan. Whisk in flour and cook, whisking, a few minutes. Add milk. Cook, stirring frequently, over low heat about 10 minutes - until thick.\n3. Stir in mushroom mixture and remaining stock. Cover and simmer 10-15 minutes.\n4. Just before serving, add salt, pepper, lemon juice, sour cream, and if desired extra dill (1 tsp). Serve garnished with parsley.";
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
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[super dealloc];
}


#pragma mark Properties
@synthesize window;
@synthesize tabBarController;
@synthesize recipeNavController;
@synthesize shoppingListNavController;
@synthesize settingsNavController;
@synthesize helpNavController;


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

