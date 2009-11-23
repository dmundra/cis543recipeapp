//
//  RecipeAppAppDelegate.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import "RecipeAppAppDelegate.h"


@interface RecipeAppAppDelegate (/*Private*/)
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain, readonly) NSString* applicationDocumentsDirectory;
@end


@implementation RecipeAppAppDelegate
#pragma mark Application Lifecycle
- (void)applicationDidFinishLaunching:(UIApplication *)application { 
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

