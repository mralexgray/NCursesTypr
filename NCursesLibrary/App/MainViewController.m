//
//  DetailViewController.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-18.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "MainViewController.h"
#import "StartupOptions.h"

#import "NCApplication.h"
#import "NCNavigationController.h"
#import "NCAlertView.h"
#import "NCLabel.h"

@interface MainViewController ()
@property (nonatomic, assign) BOOL commandMode;
@property (nonatomic, assign) BOOL searchMode;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSArray *copiedText;

@property (nonatomic, strong) TextEditorView *textEditorView;
@property (nonatomic, strong) TabMenuView *tabMenuView;
@property (nonatomic, strong) NCLabel *modeLabel;
@end

@implementation MainViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tabMenuView = [[TabMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.tabMenuView setOutput:self];
    [self.tabMenuView setBackgroundColor:[NCColor whiteColor]];
    [self.tabMenuView setActiveColor:[NCColor blackColor]];
    [self.tabMenuView setPassiveColor:[NCColor whiteColor]];
    [self.view addSubview:self.tabMenuView];
    
    self.textEditorView = [[TextEditorView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, self.view.frame.size.height-2)];
    self.textEditorView.output = self;
    [self.view addSubview:self.textEditorView];
    
    self.modeLabel = [[NCLabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 1, self.view.frame.size.width, 1)];
    [self.modeLabel setText:(self.searchString ? [@"SEARCH:" stringByAppendingString:[self.searchString uppercaseString]] : (self.commandMode ? @"COMMAND MODE" : @"INPUT MODE"))];
    [self.modeLabel setForegroundColor:[NCColor blackColor]];
    [self.modeLabel setBackgroundColor:[NCColor whiteColor]];
    [self.view addSubview:self.modeLabel];
    
    for(NSString *openFile in [StartupOptions openFiles]) {
        FileBuffer *buffer = [FileBuffer fileBufferFromFilePath:openFile];
        if(buffer) {
            NSString *path = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingFormat:@"/%@",[openFile lastPathComponent]];
            [self.tabMenuView addMenuItem:path tag:buffer];
        }
    }
}

- (void)keyPress:(NCKey *)key
{
    if([key isEqualTo:[NCKey NCKEY_ESC]]) {
        self.commandMode = !self.commandMode;
    } else {
        if(self.searchMode) {
            if([key isEqualTo:[NCKey NCKEY_Q]] || [key isEqualTo:[NCKey NCKEY_q]]) {
                self.searchMode = NO;
                self.searchString = nil;
            } else if([key isEqualTo:[NCKey NCKEY_ENTER]]) {
                if(self.searchString && self.searchString.length > 0) {
                    [self.textEditorView moveFind:self.searchString];
                }
            } else if([key isEqualTo:[NCKey NCKEY_BACK_SPACE]]) {
                if(self.searchString && self.searchString.length > 1) {
                    self.searchString = [self.searchString substringToIndex:self.searchString.length-1];
                } else {
                    self.searchString = nil;
                }
            } else {
                if(!self.searchString) {
                    self.searchString = [NSString stringWithFormat:@"%c",[key getCharacter]];
                } else {
                    self.searchString = [self.searchString stringByAppendingFormat:@"%c",[key getCharacter]];
                }
            }
        }
        else if(self.commandMode) {
            if([key isEqualTo:[NCKey NCKEY_r]] || [key isEqualTo:[NCKey NCKEY_R]]) {
                // Read new buffer
                FileSelectorViewController *vc = [[FileSelectorViewController alloc] initWithPath:[[NSFileManager defaultManager] currentDirectoryPath]
                                                                                          withTag:0];
                vc.output = self;
                [self.navigationController pushViewController:vc];
            }
            else if([key isEqualTo:[NCKey NCKEY_n]] || [key isEqualTo:[NCKey NCKEY_N]]) {
                // New buffer
                FileBuffer *nBuffer = [[FileBuffer alloc] init];
                nBuffer.lines = [NSMutableArray arrayWithObject:[NSMutableString string]];
                [self.tabMenuView addMenuItem:@"New buffer" tag:nBuffer];
            }
            else if([key isEqualTo:[NCKey NCKEY_w]] || [key isEqualTo:[NCKey NCKEY_W]]) {
                // Write buffer
                FileSelectorViewController *vc = [[FileSelectorViewController alloc] initWithPath:[[NSFileManager defaultManager] currentDirectoryPath]
                                                                                          withTag:1];
                vc.output = self;
                vc.allowNewFile = YES;
                [self.navigationController pushViewController:vc];
            }
            else if([key isEqualTo:[NCKey NCKEY_Q]] || [key isEqualTo:[NCKey NCKEY_q]]) {
                // Close buffer
                if(![self.textEditorView stopMarkMode]) {
                    if(![self.tabMenuView removeCurrentItem]) {
                        [[NCApplication sharedApplication] closeApplication];
                    }
                }
            }
            else if([key isEqualTo:[NCKey NCKEY_M]] || [key isEqualTo:[NCKey NCKEY_m]]) {
                // Mark mode
                [self.textEditorView startMarkMode];
            }
            else if([key isEqualTo:[NCKey NCKEY_S]] || [key isEqualTo:[NCKey NCKEY_s]]) {
                // Search mode
                self.searchMode = YES;
            }
            else if([key isEqualTo:[NCKey NCKEY_C]] || [key isEqualTo:[NCKey NCKEY_c]]) {
                // Copy
                self.copiedText = [self.textEditorView markCopy];
            }
            else if([key isEqualTo:[NCKey NCKEY_X]] || [key isEqualTo:[NCKey NCKEY_x]]) {
                // Cut
                self.copiedText = [self.textEditorView markCut];
            }
            else if([key isEqualTo:[NCKey NCKEY_P]] || [key isEqualTo:[NCKey NCKEY_p]]) {
                // Paste
                [self.textEditorView paste:self.copiedText];
            }
            else if([key isEqualTo:[NCKey NCKEY_A]] || [key isEqualTo:[NCKey NCKEY_a]]) {
                // Jump to begining of line
                [self.textEditorView moveBeginingOfLine];
            }
            else if([key isEqualTo:[NCKey NCKEY_E]] || [key isEqualTo:[NCKey NCKEY_e]]) {
                // Jump to end of line
                [self.textEditorView moveEndOfLine];
            }
            else if([key isEqualTo:[NCKey NCKEY_Y]] || [key isEqualTo:[NCKey NCKEY_y]]) {
                // Page up
                [self.textEditorView movePageUp];
            }
            else if([key isEqualTo:[NCKey NCKEY_V]] || [key isEqualTo:[NCKey NCKEY_v]]) {
                // Page down
                [self.textEditorView movePageDown];
            }
            else if([key isEqualTo:[NCKey NCKEY_ARROW_LEFT]]) {
                [self.tabMenuView moveLeft];
            }
            else if([key isEqualTo:[NCKey NCKEY_ARROW_RIGHT]]) {
                [self.tabMenuView moveRight];
            }
            self.commandMode = NO;
        } else {
            if([key isEqualTo:[NCKey NCKEY_ARROW_LEFT]]) {
                [self.textEditorView moveLeft];
            } else if([key isEqualTo:[NCKey NCKEY_ARROW_UP]]) {
                [self.textEditorView moveUp];
            } else if([key isEqualTo:[NCKey NCKEY_ARROW_RIGHT]]) {
                [self.textEditorView moveRight];
            } else if([key isEqualTo:[NCKey NCKEY_ARROW_DOWN]]) {
                [self.textEditorView moveDown];
            } else if([key isEqualTo:[NCKey NCKEY_BACK_SPACE]]) {
                [self.textEditorView backspace];
            } else if([key isEqualTo:[NCKey NCKEY_ENTER]]) {
                [self.textEditorView addNewLine];
            } else {
                [self.textEditorView addCharacter:[key getCharacter]];
            }
        }
    }
    
    // Update modeLabel
    [self updateBottomLabel];
}

- (void)updateBottomLabel
{
    [self.modeLabel setText:(self.searchMode ? [@"SEARCH:" stringByAppendingString:(self.searchString ? [self.searchString uppercaseString] : @"")] : (self.commandMode ? @"COMMAND MODE" : @"INPUT MODE"))];
}

#pragma mark TabMenuViewOutput

- (void)didSelectItem:(TabMenuItem *)item
{
    if(item.tag) {
        [self.textEditorView openBuffer:(FileBuffer*)item.tag];
    } else {
    	[self.textEditorView openBuffer:nil];
    }
    [self updateBottomLabel];
}

#pragma mark TextEditorViewOutput

- (void)failedToOpenFile:(NSString *)filePath
{
    NCAlertView *alert = [[NCAlertView alloc] initWithTitle:@"Failed to open"
                                                 andMessage:[NSString stringWithFormat:@"Could not open '%@'.",filePath]];
    [alert addButton:@"OK" withBlock:nil];
    [alert show];
}

#pragma mark FileSelectorViewControllerDelegate

- (void) didSelectFile:(NSString*)file
               withTag:(int)tag
{
    BOOL openBuffer = tag == 0;
    BOOL saveBuffer = tag == 1;
    
    if(openBuffer) {
        FileBuffer *buffer = [FileBuffer fileBufferFromFilePath:file];
        if(buffer) {
            [self.tabMenuView addMenuItem:[file lastPathComponent] tag:buffer];
        } else {
            [self failedToOpenFile:file];
        }
    } else if(saveBuffer) {
        FileBuffer *buffer = self.textEditorView.buffer;
        if(buffer) {
            buffer.path = file;
            [self.tabMenuView setCurrentTabName:[file lastPathComponent]];
            [[buffer.lines componentsJoinedByString:@"\n"] writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

@end
