//
//  AbstractSearchOrCreateViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface AbstractSearchOrCreateViewController (Internal)
- (NSArray*)_names;
- (NSString*)_initialFilterTerm;
- (void)_choseNameAtIndex:(NSInteger)index;
- (void)_createdName:(NSString*)result;
@end
