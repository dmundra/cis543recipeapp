//
//  PickerSheetViewController.h
//  RecipeApp
//
//  Created by Charles Augustine on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@protocol PickerSheetViewControllerDelegate;


@interface PickerSheetViewController : NSObject <UIPickerViewDelegate> {
	UIActionSheet* actionSheet;
	UIPickerView* pickerView;
	
	id <PickerSheetViewControllerDelegate> delegate;
}
- (id)init;
- (id)initWithUIPickerView:(UIPickerView*)pickerView;

- (IBAction)showInWindow:(id)sender;

@property(nonatomic, retain, readonly) UIPickerView* pickerView;

@property(nonatomic, assign) id <PickerSheetViewControllerDelegate> delegate;
@end


@protocol PickerSheetViewControllerDelegate <NSObject>
- (void)pickerSheetDidDismissWithDone:(PickerSheetViewController*)pickerSheet;
@optional
- (void)pickerSheetDidDismissWithCancel:(PickerSheetViewController*)pickerSheet;
@end