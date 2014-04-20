//
//  PWExampleViewController.h
//  PBKDF2-Wrapper Example
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWExampleViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic,strong) IBOutlet UITextField *passwordField;
@property(nonatomic,strong) IBOutlet UITextField *saltField;
@property(nonatomic,strong) IBOutlet UITextField *roundsField;
@property(nonatomic,strong) IBOutlet UITextField *algorithmField;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *activityView;
@property(nonatomic,strong) IBOutlet UITextView *derivedKeyTextView;
@property(nonatomic,strong) IBOutlet UIButton *resetButton;
@property(nonatomic,strong) IBOutlet UIButton *deriveKeyButton;

@end
