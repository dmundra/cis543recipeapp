//
//  AbstractTextEditorViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "AbstractTextEditorViewController.h"
#import "AbstractTextEditorViewController+Internal.h"


@implementation AbstractTextEditorViewController
#pragma mark View Management
- (void)viewWillAppear:(BOOL)animated {
	textView.text = [self _initialValueToEdit];
	[textView becomeFirstResponder];
}


#pragma mark View Life Cycle
- (void)viewDidLoad {
	textEditorTable.editing = YES;
}


- (void)viewDidUnload {
	self.textEditorTable = nil;
	self.textViewCell = nil;
	self.textView = nil;
}


#pragma mark Memory Management
- (void)dealloc {
	[textEditorTable release];
	[textViewCell release];
	[textView release];
	
    [super dealloc];
}


#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return textViewCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	[self _valueChange:[aTextView.text stringByReplacingCharactersInRange:range withString:text] shouldSave:shouldSaveChanges];
	
	return YES;
}


#pragma mark Properties
@synthesize textEditorTable;
@synthesize textViewCell;
@synthesize textView;

@synthesize shouldSaveChanges;
@end
