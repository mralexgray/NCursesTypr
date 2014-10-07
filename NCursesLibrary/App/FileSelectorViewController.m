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
@property (nonatomic) FSViewer* fileViewer;
@property (nonatomic) NSString* path;
@property (nonatomic) int tag;
@end

@implementation FileSelectorViewController

- initWithPath:(NSString*)_
       withTag:(int)tag {
  if (!(self = super.init)) return nil;

  _tag = tag;
  _path = _ && _.length && ![[_ substringFromIndex:_.length - 1] isEqualToString:@"/"] ? _ :
                                                                                         [_ stringByAppendingString:@"/"];

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.fileViewer = [FSViewer.alloc initWithFrame:self.view.bounds];
  _fileViewer.delegate = self;
  [_fileViewer openPath:_path];
  [self.view addSubview:_fileViewer];
}

- (void)keyPress:(NCKey*)key {

  [key isEqual:NCKey.NCKEY_ESC] ? [self.navigationController popViewController] :
                                  [key isEqual:NCKey.NCKEY_ARROW_UP] ? [self.fileViewer moveUp] :
                                                                       [key isEqual:NCKey.NCKEY_ARROW_DOWN] ? [self.fileViewer moveDown] :
                                                                                                              [key isEqual:NCKey.NCKEY_ENTER] ? [self.fileViewer moveIn] :
                                                                                                                                                [key isEqual:NCKey.NCKEY_BACK_SPACE] ?

                                                                                                                                                self.allowNewFile ? [self.fileViewer fileNewRemovePreviousCharacter] : [self.fileViewer filterRemovePreviousCharacter] :
                                                                                                                                                self.allowNewFile ? [self.fileViewer fileNewAddCharacter:key.getCharacter] : [self.fileViewer filterAddCharacter:key.getCharacter];
}

- (void)didSelectFile:(NSString*)filePath {
  NCAlertView* alert = [NCAlertView.alloc initWithTitle:self.allowNewFile ? @"Write file" : @"Open file"
                                             andMessage:[NSString stringWithFormat:@"%@ '%@'?",
                                                                                   self.allowNewFile ? @"Do you want to write to?" : @"Do you want to open",
                                                                                   filePath]];
  [alert addButton:@"OK" withBlock:^{
        if(self.output && [self.output respondsToSelector:@selector(didSelectFile:withTag:)])
            [self.output didSelectFile:filePath
                               withTag:self.tag];
        [self.navigationController popViewController];
  }];
  [alert addButton:@"Cancel" withBlock:nil];
  [alert show];
}

- (void)didSelectFolder:(NSString*)dirPath {
  [self.fileViewer openPath:dirPath];
}

@end
