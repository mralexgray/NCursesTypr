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

- (void)applicationLaunched
{
    [super applicationLaunched];
    
    MainViewController *vc = [[MainViewController alloc] init];
    NCNavigationController *nvc = [[NCNavigationController alloc] initWithRootViewController:vc];
    
    NCWindow *window = [[NCWindow alloc] initWithFrame:[NCScreen bounds]];
    [window setRootViewController:nvc];
    
    [self addWindow:window];
}

@end
