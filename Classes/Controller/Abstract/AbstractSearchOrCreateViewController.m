//
//  AbstractSearchOrCreateViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractSearchOrCreateViewController.h"
#import "AbstractSearchOrCreateViewController+Internal.h"


@interface AbstractSearchOrCreateViewController (/*Private*/)
- (void)_filterNamesAndUpdateTable;
@end


@implementation AbstractSearchOrCreateViewController
#pragma mark View Life Cycle
- (void)viewDidLoad {
	filteredNames = [[NSMutableArray alloc] init];
}


- (void)viewDidUnload {
	self.searchTable = nil;
	self.nameLabel = nil;
	self.nameTextField = nil;
	self.doneButton = nil;
	
	[filteredNames release];
	filteredNames = nil;
}


#pragma mark View Management
- (void)viewDidAppear:(BOOL)animated {
	[unfilteredNames release];
	unfilteredNames = [self _names];
	
	[filterTerm release];
	filterTerm = nil;
	
	[self _filterNamesAndUpdateTable];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];

	[nameTextField becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark Memory Management
- (void)dealloc {
	[searchTable release];
	[nameLabel release];
	[nameTextField release];
	[doneButton release];
	
	[filterTerm release];
	[unfilteredNames release];
	[filteredNames release];
	
    [super dealloc];
}


#pragma mark IBAction
- (IBAction)done:(id)sender {
	[nameTextField resignFirstResponder];
	
	[UIView beginAnimations:@"searchTableResize" context:nil];
	[UIView setAnimationDuration:0.3];
	searchTable.contentInset = UIEdgeInsetsMake(searchTable.contentInset.top, searchTable.contentInset.left, 0.0, searchTable.contentInset.right);
	searchTable.scrollIndicatorInsets = UIEdgeInsetsMake(searchTable.scrollIndicatorInsets.top, searchTable.scrollIndicatorInsets.left, 0.0, searchTable.scrollIndicatorInsets.right);
	[UIView commitAnimations];
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
	
	if(result == nil) {
		result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"] autorelease];
	}
	
	return result;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[filterTerm release];
	filterTerm = [[textField.text stringByReplacingCharactersInRange:range withString:string] retain];
	
	[self _filterNamesAndUpdateTable];
	
	return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
	[filterTerm release];
	filterTerm = nil;
	
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self done:textField];
	
	return NO;
}


#pragma mark Private
- (void)_filterNamesAndUpdateTable {
	[filteredNames removeAllObjects];

	if([filterTerm length] > 0) {
		[filteredNames addObjectsFromArray:[unfilteredNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith '%@'"]]];
	}
	else {
		[filteredNames addObjectsFromArray:unfilteredNames];
	}
	
	[searchTable reloadData];
}


#pragma mark Private (Notification)
- (void)_keyboardWasShown:(NSNotification*)aNotification {
	NSDictionary* info = [aNotification userInfo];
	
	// Get the size of the keyboard.
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	[UIView beginAnimations:@"searchTableResize" context:nil];
	[UIView setAnimationDuration:0.3];
	searchTable.contentInset = UIEdgeInsetsMake(searchTable.contentInset.top, searchTable.contentInset.left, keyboardSize.height, searchTable.contentInset.right);
	searchTable.scrollIndicatorInsets = UIEdgeInsetsMake(searchTable.scrollIndicatorInsets.top, searchTable.scrollIndicatorInsets.left, keyboardSize.height, searchTable.scrollIndicatorInsets.right);
	[UIView commitAnimations];
}


#pragma mark Properties
@synthesize searchTable;
@synthesize nameLabel;
@synthesize nameTextField;
@synthesize doneButton;
@end
