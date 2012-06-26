//
//  AppDelegate.m
//  Furry Bunny
//
//  Created by Martin Knoll on 23.04.12.
//  Copyright (c) 2012 Otto-von-Guericke-Universität Magdeburg. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate()
@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  GLKViewController *controller = [[ViewController alloc] init];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = controller;
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
