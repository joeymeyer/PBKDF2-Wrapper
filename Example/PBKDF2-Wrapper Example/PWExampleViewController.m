//
//  PWExampleViewController.m
//  PBKDF2-Wrapper Example
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "PWExampleViewController.h"
#import "PBKDF2-Wrapper.h"

@interface NSData (PBKDF2WrapperExample)

- (NSString *)hexString;

@end

@implementation NSData (PBKDF2WrapperExample)

- (NSString *)hexString {
  return [[[self description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
}

@end

@interface PWExampleViewController ()

@property(nonatomic,getter=isCalculating) BOOL calculating;
@property(nonatomic) PBKDF2PseudoRandomFunction selectedFunction;

- (void)hideKeyboard;

@end

@implementation PWExampleViewController

#pragma mark - Object Lifecycle

- (id)init {
  self = [super init];
  if (self) {
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(selectedFunction))
              options:0
              context:NULL];
  }
  return self;
}

- (void)dealloc {
  [self removeObserver:self
            forKeyPath:NSStringFromSelector(@selector(selectedFunction))];
}

#pragma mark - Key/Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == self) {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedFunction))]) {
      self.algorithmField.text = NSStringFromPBKDF2PseudoRandomFunction(self.selectedFunction);
    }
  }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.selectedFunction = PBKDF2DefaultPseudoRandomFunction;
  
  UIPickerView *pickerView = [[UIPickerView alloc] init];
  [pickerView sizeToFit];
  pickerView.delegate = self;
  self.algorithmField.inputView = pickerView;
  
  UIToolbar *toolbar = [[UIToolbar alloc] init];
  [toolbar setBarStyle:UIBarStyleDefault];
  [toolbar sizeToFit];
  
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(hideKeyboard)];
  
  [toolbar setItems:@[doneButton]];
  
  self.passwordField.inputAccessoryView = toolbar;
  self.saltField.inputAccessoryView = toolbar;
  self.roundsField.inputAccessoryView = toolbar;
  self.algorithmField.inputAccessoryView = toolbar;
  
  self.derivedKeyTextView.layer.cornerRadius = 4.0f;
}

#pragma mark - Button Handlers

- (IBAction)didPressReset:(id)sender {
  self.passwordField.text = nil;
  self.saltField.text = nil;
  self.roundsField.text = nil;
  self.derivedKeyTextView.text = nil;
  self.selectedFunction = PBKDF2DefaultPseudoRandomFunction;
}

- (IBAction)didPressDeriveKey:(id)sender {
  NSString *password = self.passwordField.text;
  NSData *salt = [self.saltField.text dataUsingEncoding:NSUTF8StringEncoding];
  NSUInteger rounds = [[NSNumber numberWithLongLong:[self.roundsField.text longLongValue]] unsignedIntegerValue];
  
  NSString *errorMessage;
  
  if (password.length == 0 || salt.length == 0 || rounds == 0) {
    errorMessage = NSLocalizedString(@"Please enter a password, salt, and the number of rounds", nil);
  } else if (self.isCalculating) {
    errorMessage = NSLocalizedString(@"Wait for current key derivation to finish", nil);
  }
  
  if (errorMessage) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
  } else {
    self.calculating = YES;
    [self.activityView startAnimating];
    self.derivedKeyTextView.text = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithSalt:salt
                                                                    derivedKeyLength:PBKDF2DefaultDerivedKeyLength
                                                                              rounds:rounds
                                                                pseudoRandomFunction:self.selectedFunction];
      
      PBKDF2Result *result = [[PBKDF2Result alloc] initWithPassword:password configuration:configuration];
      
      [result calculateDerivedKey];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        self.derivedKeyTextView.text = [result.derivedKey hexString];
        [self.activityView stopAnimating];
        self.calculating = NO;
      });
    });
  }
}

#pragma mark - UIPickerViewDelegate/UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 5;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return NSStringFromPBKDF2PseudoRandomFunction(row);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  self.selectedFunction = row;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self hideKeyboard];
  
  return NO;
}

#pragma mark - Private

- (void)hideKeyboard {
  [self.passwordField resignFirstResponder];
  [self.saltField resignFirstResponder];
  [self.roundsField resignFirstResponder];
  [self.algorithmField resignFirstResponder];
}

@end
