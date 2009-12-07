//
//  PickerSheetViewController.m
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "PickerSheetViewController.h"


@interface PickerSheetViewController (/*Private*/)
- (void)_initializeWithUIPickerView:(UIPickerView*)pickerView;

- (void)_cancel:(id)sender;
- (void)_save:(id)sender;
@end


@implementation PickerSheetViewController
#pragma mark Initialization
- (id)init {
	if(self = [super init]) {
		[self _initializeWithUIPickerView:[[[UIPickerView alloc] init] autorelease]];
	}
	
	return self;
}


- (id)initWithUIPickerView:(UIPickerView*)aPickerView {
	if(self = [super init]) {
		[self _initializeWithUIPickerView:aPickerView];
	}
	
	return self;
}


- (void)_initializeWithUIPickerView:(UIPickerView*)aPickerView {
	pickerView = [aPickerView retain];
	
	actionSheet = [[UIActionSheet alloc] init];
	actionSheet.frame = CGRectMake(0.0, 0.0, 320.0, 260.0);
	[actionSheet addSubview:pickerView];
	pickerView.frame = CGRectMake(0.0, 44.0, pickerView.frame.size.width, pickerView.frame.size.height);
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	toolbar.barStyle = UIBarStyleBlackOpaque;
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel:)];
	UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_save:)];
	toolbar.items = [NSArray arrayWithObjects:cancelButton, space, saveButton, nil];
	[actionSheet addSubview:toolbar];
	toolbar.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
}


#pragma mark Memory Management
- (void)dealloc {
	[actionSheet release];
	[pickerView release];
	
	// delegate not retained
	
    [super dealloc];
}


#pragma mark Public
-(IBAction)showInWindow:(id)sender {
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	actionSheet.frame = CGRectMake(0.0, 220.0, 320.0, 260.0);
}


#pragma mark Private
- (void)_cancel:(id)sender {
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
	[delegate pickerSheetDidDismissWithCancel:self];
}


- (void)_save:(id)sender {
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	
	[delegate pickerSheetDidDismissWithDone:self];
}


#pragma mark Properties
@synthesize pickerView;

@synthesize delegate;
@end
