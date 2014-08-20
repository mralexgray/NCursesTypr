//
//  FileBuffer.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-24.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileBuffer : NSObject

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, assign) int cursorOffsetX;
@property (nonatomic, assign) int cursorOffsetY;
@property (nonatomic, assign) int cursorLineY;
@property (nonatomic, assign) int cursorLineX;
@property (nonatomic, assign) int screenOffsetY;

@property (nonatomic, assign) BOOL markMode;
@property (nonatomic, assign) int markCursorOffsetX;
@property (nonatomic, assign) int markCursorOffsetY;
@property (nonatomic, assign) int markCursorLineY;
@property (nonatomic, assign) int markCursorLineX;
@property (nonatomic, assign) int markScreenOffsetY;

+ (id) fileBufferFromFilePath:(NSString*)path;

@end
