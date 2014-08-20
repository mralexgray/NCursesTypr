//
//  TestView.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"

@interface File : NSObject
- (id) initWithPath:(NSString*) path;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileExtension;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) int size;
@end

@interface Folder : NSObject
- (id) initWithPath:(NSString*) path;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) NSString *dirName;
@end

@protocol FSViewerDelegate <NSObject>
- (void) didSelectFile:(NSString*)filePath;
- (void) didSelectFolder:(NSString*)dirPath;
@end

@interface FSViewer : NCView
- (void) moveDown;
- (void) moveUp;
- (void) moveOut;
- (void) moveIn;

- (void) filterAddCharacter:(char)character;
- (void) filterRemovePreviousCharacter;
- (void) filterClear;

- (void) fileNewAddCharacter:(char)character;
- (void) fileNewRemovePreviousCharacter;
- (void) fileNewClear;

- (void) openPath:(NSString*)path;

@property (nonatomic, weak) id<FSViewerDelegate> delegate;
@end
