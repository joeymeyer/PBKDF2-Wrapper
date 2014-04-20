//
//  PWAppDelegate.m
//  PBKDF2-Wrapper Example
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "PWAppDelegate.h"
#import "PWExampleViewController.h"

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  
  PWExampleViewController *controller = [[PWExampleViewController alloc] init];
  
  self.window.rootViewController = controller;
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
