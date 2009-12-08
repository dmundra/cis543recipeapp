//
//  PrepMethodSearchOrCreateViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractSearchOrCreateViewController.h"


@protocol PrepMethodSearchOrCreateViewControllerDelegate;


@interface PrepMethodSearchOrCreateViewController : AbstractSearchOrCreateViewController {
	NSString* preparationMethodName;
	
	NSArray* preparationMethods;
	
	IBOutlet id <PrepMethodSearchOrCreateViewControllerDelegate> delegate;
}
@property(nonatomic, retain) NSString* preparationMethodName;

@property(nonatomic, assign) id <PrepMethodSearchOrCreateViewControllerDelegate> delegate;
@end


@protocol PrepMethodSearchOrCreateViewControllerDelegate <NSObject>
- (void)didChoosePrepMethod:(NSString*)prepMethodName;
- (void)didCreateNewPrepMethod:(NSString*)prepMethodName;
@end