//
//  FileBuffer.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-24.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "FileBuffer.h"

@implementation FileBuffer

+ (id)fileBufferFromFilePath:(NSString *)path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
        if(content && !error) {
            NSArray *l = [content componentsSeparatedByString:@"\n"];
            
            FileBuffer *buffer = [[FileBuffer alloc] init];
            buffer.path = path;
            buffer.lines = [NSMutableArray array];
            for(NSString *line in l) {
                [buffer.lines addObject:[NSMutableString stringWithString:line]];
            }
            
            buffer.cursorOffsetX = 0;
            buffer.cursorOffsetY = 0;
            buffer.cursorLineX = 0;
            buffer.cursorLineY = 0;
            buffer.screenOffsetY = 0;
            return buffer;
        }
    }
    return nil;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\npath:%@\nlines:%lu\ncursorOffsetX:%i\ncursorOffsetY:%i\ncursorLineX:%i\ncursorLineY:%i\nscreenOffsetY:%i",self.path,(unsigned long)self.lines.count,self.cursorOffsetX,self.cursorOffsetY,self.cursorLineX,self.cursorLineY,self.screenOffsetY];
}

@end
