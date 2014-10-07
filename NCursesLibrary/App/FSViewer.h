//
//  TestView.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"

@interface File : NSObject
- initWithPath:(NSString*)path;
@property (nonatomic) NSString* path, *fileName, *fileExtension;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) int size;
@end

@interface Folder : NSObject
- initWithPath:(NSString*)path;
@property (nonatomic) NSString* path, *dirName;
@property (nonatomic) BOOL isHidden;
@end

@protocol FSViewerDelegate<NSObject>
- (void)didSelectFile:(NSString*)filePath;
- (void)didSelectFolder:(NSString*)dirPath;
@end

@interface FSViewer : NCView
- (void)moveDown;
- (void)moveUp;
- (void)moveOut;
- (void)moveIn;

- (void)filterAddCharacter:(char)character;
- (void)filterRemovePreviousCharacter;
- (void)filterClear;

- (void)fileNewAddCharacter:(char)character;
- (void)fileNewRemovePreviousCharacter;
- (void)fileNewClear;

- (void)openPath:(NSString*)path;

@property (nonatomic, weak) id<FSViewerDelegate> delegate;
@end
