//
//  AbstractTextEditorViewController+Internal.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface AbstractTextEditorViewController (Internal)
- (NSString*)initialValueToEdit;
- (void)valueChange:(NSString*)newValue shouldSave:(BOOL)shouldSave;
@end
