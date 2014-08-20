//
//  StartupOptions.m
//  NCursesLibrary
//
//  Created by Christer on 2014-08-14.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "StartupOptions.h"

@interface StartupOptions ()
@property (nonatomic, strong) NSArray *openFiles;
@end

@implementation StartupOptions

static StartupOptions *instance = nil;
+ (StartupOptions*)sharedInstance
{
    if(!instance) {
        instance = [[StartupOptions alloc] init];
        
        NSMutableArray *options = [NSMutableArray array];
        for(NSString *argument in[[NSProcessInfo processInfo] arguments]) {
            [options addObject:argument];
        }
        [instance setOpenFiles:options];
    }
    return instance;
}

+ (NSArray *)openFiles
{
    return [[self sharedInstance] openFiles];
}

@end
