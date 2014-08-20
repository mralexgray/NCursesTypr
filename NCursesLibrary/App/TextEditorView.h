//
//  TextEditorView.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-22.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"
#import "FileBuffer.h"

@protocol TextEditorViewOutput <NSObject>

- (void) failedToOpenFile:(NSString*)filePath;

@end

@interface TextEditorView : NCView

- (void)moveLeft;
- (void)moveUp;
- (void)moveRight;
- (void)moveDown;
- (void)moveBeginingOfLine;
- (void)moveEndOfLine;
- (void)movePageUp;
- (void)movePageDown;
- (void)moveFind:(NSString*)toFind;

- (void)backspace;
- (void)addCharacter:(char)character;
- (void)addNewLine;

- (void)startMarkMode;
- (BOOL)stopMarkMode;

- (NSArray*)markCut;
- (NSArray*)markCopy;
- (void)paste:(NSArray*)text;

- (void) openBuffer:(FileBuffer*)buffer;

@property (nonatomic, strong) id<TextEditorViewOutput> output;
@property (nonatomic, strong) FileBuffer *buffer;

@end
