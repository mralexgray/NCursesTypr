//
//  TestViewController.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCNavigationController.h"
#import "FileSelectorViewController.h"
#import "NCAlertView.h"

@interface FileSelectorViewController ()
@property (nonatomic, strong) FSViewer *fileViewer;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) int tag;
@end

@implementation FileSelectorViewController

- (id) initWithPath:(NSString *)path
            withTag:(int)tag
{
    self = [super init];
    if(self) {
        self.tag = tag;
        if(path && path.length > 0 && ![[path substringFromIndex:path.length-1] isEqualToString:@"/"]) {
            self.path = [NSString stringWithFormat:@"%@/",path];
        } else {
            self.path = path;
        }
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.fileViewer = [[FSViewer alloc] initWithFrame:self.view.bounds];
    self.fileViewer.delegate = self;
    [self.fileViewer openPath:self.path];
    [self.view addSubview:self.fileViewer];
}

- (void)keyPress:(NCKey *)key
{
    if([key isEqual:[NCKey NCKEY_ESC]]) {
        [self.navigationController popViewController];
    } else if([key isEqualTo:[NCKey NCKEY_ARROW_UP]]) {
        [self.fileViewer moveUp];
    } else if([key isEqualTo:[NCKey NCKEY_ARROW_DOWN]]) {
        [self.fileViewer moveDown];
    } else if([key isEqualTo:[NCKey NCKEY_ENTER]]) {
        [self.fileViewer moveIn];
    } else if([key isEqualTo:[NCKey NCKEY_BACK_SPACE]]) {
        if(self.allowNewFile) {
            [self.fileViewer fileNewRemovePreviousCharacter];
        } else {
            [self.fileViewer filterRemovePreviousCharacter];
        }
    } else {
        if(self.allowNewFile) {
            [self.fileViewer fileNewAddCharacter:[key getCharacter]];
        } else {
            [self.fileViewer filterAddCharacter:[key getCharacter]];
        }
    }
}

- (void)didSelectFile:(NSString *)filePath
{
    NCAlertView *alert = [[NCAlertView alloc] initWithTitle:self.allowNewFile ? @"Write file" : @"Open file"
                                                 andMessage:self.allowNewFile ? [NSString stringWithFormat:@"Do you want to write to '%@'?",filePath] :
                          [NSString stringWithFormat:@"Do you want to open '%@'?",filePath]];
    [alert addButton:@"OK" withBlock:^{
        if(self.output && [self.output respondsToSelector:@selector(didSelectFile:withTag:)]) {
            [self.output didSelectFile:filePath
                               withTag:self.tag];
        }
        [self.navigationController popViewController];
    }];
    [alert addButton:@"Cancel" withBlock:nil];
    [alert show];
}

- (void)didSelectFolder:(NSString *)dirPath
{
    [self.fileViewer openPath:dirPath];
}

@end
