//
//  RecipeNameCategoryAndSourceEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "RecipeNameCategoryAndSourceEditorViewController.h"
#import "Recipe.h"
#import "PickerSheetViewController.h"


enum {
	RecipeInfoSectionTitle,
	RecipeInfoSectionSource,
	RecipeInfoSectionCategory,
	RecipeInfoSectionCount
};

@implementation RecipeNameCategoryAndSourceEditorViewController
#pragma mark View Life Cycle
- (void)viewWillAppear:(BOOL)animated {	
	[titleTextField setText:recipe.name];
	[titleTextField setPlaceholder:recipe.name];
	[sourceTextField setText:recipe.source];
}

- (void)viewDidLoad {
	self.nameCategoryAndSourceTable.editing = YES;
	
	categoryPickerSheetViewController = [[PickerSheetViewController alloc] init];
	categoryPickerSheetViewController.delegate = self;
	categoryPickerSheetViewController.pickerView.dataSource = self;
	categoryPickerSheetViewController.pickerView.delegate = self;
	categoryPickerSheetViewController.pickerView.showsSelectionIndicator = YES;
}

- (void)viewDidUnload {
	self.nameCategoryAndSourceTable = nil;
	self.titleTextField = nil;
	self.sourceTextField = nil;
	self.titleViewCell = nil;
	self.sourceViewCell = nil;
	self.categoryViewCell = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[nameCategoryAndSourceTable release];
	[titleTextField release];
	[sourceTextField release];
	[titleViewCell release];
	[sourceViewCell release];
	[categoryViewCell release];		
	[recipe release];	
	[managedObjectContext release];
	[categoryPickerSheetViewController release];
    [super dealloc];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = nil;
	
	if(indexPath.section == RecipeInfoSectionTitle) {
		result = titleViewCell;
	} else if (indexPath.section == RecipeInfoSectionSource) {
		result = sourceViewCell;
	} else {
		result = categoryViewCell;
	}
	
	return result;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return RecipeInfoSectionCount;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 1;
}


#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Deselect the selected index path
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(indexPath.section == RecipeInfoSectionCategory) {
		[categoryPickerSheetViewController showInWindow:self];
	}
}


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if(textField == sourceTextField) {
		recipe.source = [sourceTextField.text stringByReplacingCharactersInRange:range withString:string];
	}
	else if(textField == titleTextField) {
		NSString* temp = [titleTextField.text stringByReplacingCharactersInRange:range withString:string];
		if ([temp length] > 0) {
			recipe.name = temp;
		} else {
			recipe.name = titleTextField.placeholder;
		}

	}
	
	if(shouldSaveChanges)
	{
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
		}
	}
	
	return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
	if(textField == sourceTextField) {
		recipe.source = nil;
	}
	else if(textField == titleTextField) {
		recipe.name = titleTextField.placeholder;
	}
	
	if(shouldSaveChanges)
	{
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
		}
	}
	
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];	
	return NO;
}

#pragma mark PickerSheetViewControllerDelegate
- (void)pickerSheetDidDismissWithDone:(PickerSheetViewController*)pickerSheet {

}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return CategoryCount;
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString* result = NSStringFromCategory([NSNumber numberWithInt:row]);
	return result;
}


#pragma mark Properties
@synthesize nameCategoryAndSourceTable;
@synthesize recipe;
@synthesize shouldSaveChanges;
@synthesize managedObjectContext;
@synthesize titleTextField;
@synthesize sourceTextField;
@synthesize titleViewCell;
@synthesize sourceViewCell;
@synthesize categoryViewCell;
@end
