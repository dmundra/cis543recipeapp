//
//  RecipeAppAppDelegate.h
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


@class RecipesViewController, ShoppingListViewController;


@interface RecipeAppAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UITabBarController* tabBarController;
	IBOutlet UINavigationController* recipeNavController;
	IBOutlet UINavigationController* shoppingListNavController;
	IBOutlet UINavigationController* settingsNavController;
	IBOutlet UINavigationController* helpNavController;
	IBOutlet RecipesViewController* recipesViewController;
	IBOutlet ShoppingListViewController* shoppingListViewController;

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property(nonatomic, retain) UIWindow *window;
@property(nonatomic, retain) UITabBarController* tabBarController;
@property(nonatomic, retain) UINavigationController* recipeNavController;
@property(nonatomic, retain) UINavigationController* shoppingListNavController;
@property(nonatomic, retain) UINavigationController* settingsNavController;
@property(nonatomic, retain) UINavigationController* helpNavController;
@property(nonatomic, retain) RecipesViewController* recipesViewController;
@property(nonatomic, retain) ShoppingListViewController* shoppingListViewController;

@property(nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@end

