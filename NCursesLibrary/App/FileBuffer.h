//
//  FileBuffer.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-24.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileBuffer : NSObject

@property (nonatomic) NSString* path;
@property (nonatomic) NSMutableArray* lines;

@property (nonatomic) int   cursorOffsetX,      cursorOffsetY,
                              cursorLineX,        cursorLineY,
                            screenOffsetX,      screenOffsetY,
                        markCursorOffsetX,  markCursorOffsetY,
                          markCursorLineX,    markCursorLineY,
                        markScreenOffsetX,  markScreenOffsetY,  markMode;

+ fileBufferFromFilePath:(NSString*)_;

@end
