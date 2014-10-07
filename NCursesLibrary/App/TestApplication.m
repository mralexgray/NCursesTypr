//
//  TestApplication.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "TestApplication.h"
#import "MainViewController.h"
#import "NCScreen.h"

#import "NCNavigationController.h"

@implementation TestApplication

static NCNavigationController* nvc;
static NCWindow* window;

- (void)applicationLaunched {
  [super applicationLaunched];

  nvc = [NCNavigationController.alloc initWithRootViewController:MainViewController.new];

  window = [NCWindow.alloc initWithFrame:NCScreen.bounds];
  [window setRootViewController:nvc];

  [self addWindow:window];
}

@end
