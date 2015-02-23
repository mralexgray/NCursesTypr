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

static NCViewController *vc;
static NCNavigationController* nvc;
static NCWindow* window;

- (void)applicationLaunched {

  [super applicationLaunched];

  vc = NCViewController.new;
  NSRect r = NCScreen.bounds;
  r.size.height /= 2.;
  vc.view = [NCView.alloc initWithFrame:r];
  vc.view.backgroundColor = [NCColor redColor];
//  nvc =
//    [NCNavigationController.alloc initWithRootViewController:MainViewController.new];

  window = [NCWindow.alloc initWithFrame:r];
  [window setRootViewController:vc];

  [self addWindow:window];
}

@end
