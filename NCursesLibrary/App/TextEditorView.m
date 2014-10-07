//
//  TextEditorView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-22.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "TextEditorView.h"

@implementation TextEditorView

#pragma mark Public methods

- (void)moveLeft {
  if (self.buffer.markMode) {
    if (self.buffer.markCursorOffsetX > 0) {
      self.buffer.markCursorOffsetX--;
      self.buffer.markCursorLineX = self.buffer.markCursorOffsetX;
    } else if (self.buffer.markCursorLineY > 0) {
      NSMutableString* line = [self textOnLine:self.buffer.markCursorLineY - 1];
      if (line) {
        self.buffer.markCursorLineX = (int)line.length;
      } else {
        self.buffer.markCursorLineX = 0;
      }
      [self moveUp];
    }
  } else {
    if (self.buffer.cursorOffsetX > 0) {
      self.buffer.cursorOffsetX--;
      self.buffer.cursorLineX = self.buffer.cursorOffsetX;
    } else if (self.buffer.cursorLineY > 0) {
      NSMutableString* line = [self textOnLine:self.buffer.cursorLineY - 1];
      if (line) {
        self.buffer.cursorLineX = (int)line.length;
      } else {
        self.buffer.cursorLineX = 0;
      }
      [self moveUp];
    }
  }
}

- (void)moveUp {
  if (self.buffer.markMode) {
    if (self.buffer.markCursorOffsetY > 0) {
      self.buffer.markCursorOffsetY--;
      self.buffer.markCursorLineY--;
    } else if (self.buffer.markScreenOffsetY > 0) {
      self.buffer.markCursorLineY--;
      self.buffer.markScreenOffsetY--;
    }

    NSMutableString* line = [self textOnLine:self.buffer.markCursorLineY];
    if (line) {
      self.buffer.markCursorOffsetX = MIN((int)line.length, self.buffer.markCursorLineX);
    } else {
      self.buffer.markCursorOffsetX = 0;
    }
  } else {
    if (self.buffer.cursorOffsetY > 0) {
      self.buffer.cursorOffsetY--;
      self.buffer.cursorLineY--;
    } else if (self.buffer.screenOffsetY > 0) {
      self.buffer.cursorLineY--;
      self.buffer.screenOffsetY--;
    }

    NSMutableString* line = [self textOnLine:self.buffer.cursorLineY];
    if (line) {
      self.buffer.cursorOffsetX = MIN((int)line.length, self.buffer.cursorLineX);
    } else {
      self.buffer.cursorOffsetX = 0;
    }
  }
}

- (void)moveRight {
  if (self.buffer.markMode) {
    NSMutableString* line = [self textOnLine:self.buffer.markCursorLineY];
    if (line && self.buffer.markCursorOffsetX + 1 < line.length + 1) {
      self.buffer.markCursorOffsetX++;
      self.buffer.markCursorLineX = self.buffer.markCursorOffsetX;
    } else if (self.buffer.markCursorLineY + 1 < self.buffer.lines.count) {
      self.buffer.markCursorLineX = 0;
      [self moveDown];
    }
  } else {
    NSMutableString* line = [self textOnLine:self.buffer.cursorLineY];
    if (line && self.buffer.cursorOffsetX + 1 < line.length + 1) {
      self.buffer.cursorOffsetX++;
      self.buffer.cursorLineX = self.buffer.cursorOffsetX;
    } else if (self.buffer.cursorLineY + 1 < self.buffer.lines.count) {
      self.buffer.cursorLineX = 0;
      [self moveDown];
    }
  }
}

- (void)moveDown {
  if (self.buffer.markMode) {
    if (self.buffer.markCursorOffsetY + 1 < MIN(self.frame.size.height, (int)self.buffer.lines.count)) {
      self.buffer.markCursorOffsetY++;
      self.buffer.markCursorLineY++;
    } else if (self.buffer.markCursorLineY < (int)self.buffer.lines.count - 1) {
      self.buffer.markCursorLineY++;
      self.buffer.markScreenOffsetY++;
    }

    NSMutableString* line = [self textOnLine:self.buffer.markCursorLineY];
    if (line) {
      self.buffer.markCursorOffsetX = MIN((int)line.length, self.buffer.markCursorLineX);
    } else {
      self.buffer.markCursorOffsetX = 0;
    }
  } else {
    if (self.buffer.cursorOffsetY + 1 < MIN(self.frame.size.height, (int)self.buffer.lines.count)) {
      self.buffer.cursorOffsetY++;
      self.buffer.cursorLineY++;
    } else if (self.buffer.cursorLineY < (int)self.buffer.lines.count - 1) {
      self.buffer.cursorLineY++;
      self.buffer.screenOffsetY++;
    }

    NSMutableString* line = [self textOnLine:self.buffer.cursorLineY];
    if (line) {
      self.buffer.cursorOffsetX = MIN((int)line.length, self.buffer.cursorLineX);
    } else {
      self.buffer.cursorOffsetX = 0;
    }
  }
}

- (void)moveBeginingOfLine {
  if (self.buffer) {
    if (self.buffer.markMode) {
      self.buffer.markCursorLineX = 0;
      self.buffer.markCursorOffsetX = 0;
    } else {
      self.buffer.cursorLineX = 0;
      self.buffer.cursorOffsetX = 0;
    }
  }
}

- (void)moveEndOfLine {
  if (self.buffer) {
    if (self.buffer.markMode) {
      self.buffer.markCursorLineX = (int)[[self.buffer.lines objectAtIndex:self.buffer.markCursorLineY] length];
      self.buffer.markCursorOffsetX = (int)[[self.buffer.lines objectAtIndex:self.buffer.markCursorLineY] length];
    } else {
      self.buffer.cursorLineX = (int)[[self.buffer.lines objectAtIndex:self.buffer.cursorLineY] length];
      self.buffer.cursorOffsetX = (int)[[self.buffer.lines objectAtIndex:self.buffer.cursorLineY] length];
    }
  }
}

- (void)movePageUp {
  if (self.buffer) {
    for (int i = 0; i < (int)self.frame.size.height; i++) {
      [self moveUp];
    }
  }
}

- (void)movePageDown {
  if (self.buffer) {
    for (int i = 0; i < (int)self.frame.size.height; i++) {
      [self moveDown];
    }
  }
}

- (void)moveFind:(NSString*)toFind {
  if (self.buffer && toFind && toFind.length > 0) {
    if (!self.buffer.markMode) {
      int foundLineY = -1;
      int foundOffsetX = -1;
      for (int y = self.buffer.cursorLineY; y < self.buffer.lines.count; y++) {
        NSString* line = [self.buffer.lines objectAtIndex:y];
        if (y == self.buffer.cursorLineY) {
          if (self.buffer.cursorOffsetX + 1 < line.length) {
            NSRange range = [[line substringFromIndex:self.buffer.cursorOffsetX + 1] rangeOfString:toFind options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
              foundLineY = y;
              foundOffsetX = self.buffer.cursorOffsetX + 1 + (int)range.location;
              break;
            }
          }
        } else {
          NSRange range = [line rangeOfString:toFind options:NSCaseInsensitiveSearch];
          if (range.location != NSNotFound) {
            foundLineY = y;
            foundOffsetX = (int)range.location;
            break;
          }
        }
      }
      if (foundLineY == -1 && foundOffsetX == -1) {
        for (int y = 0; y < self.buffer.cursorLineY; y++) {
          NSString* line = [self.buffer.lines objectAtIndex:y];
          NSRange range = [line rangeOfString:toFind options:NSCaseInsensitiveSearch];
          if (range.location != NSNotFound) {
            foundLineY = y;
            foundOffsetX = (int)range.location;
            break;
          }
        }
      }
      if (foundLineY != -1 && foundOffsetX != -1) {
        self.buffer.cursorLineX = foundOffsetX;
        self.buffer.cursorOffsetX = foundOffsetX;
        self.buffer.cursorLineY = foundLineY;
        self.buffer.cursorOffsetY = MIN(self.frame.size.height, foundLineY);
        self.buffer.screenOffsetY = MAX(0, foundLineY - self.frame.size.height);
      }
    }
  }
}

- (void)backspace {
  if (!self.buffer.markMode) {
    NSMutableString* line = [self textOnLine:self.buffer.cursorLineY];
    if (line) {
      if (self.buffer.cursorOffsetX - 1 >= 0) {
        [line deleteCharactersInRange:NSMakeRange(self.buffer.cursorOffsetX - 1, 1)];
        [self moveLeft];
      } else {
        if (self.buffer.cursorLineY > 0) {
          NSMutableString* lineAbove = [self textOnLine:self.buffer.cursorLineY - 1];
          self.buffer.cursorLineX = (int)lineAbove.length;
          self.buffer.cursorOffsetX = (int)lineAbove.length;
          [lineAbove appendString:line];
          [self moveUp];
          [self.buffer.lines removeObjectIdenticalTo:line];
        }
      }
    }
  }
}

- (void)addNewLine {
  if (!self.buffer.markMode) {
    NSMutableString* line = [self textOnLine:self.buffer.cursorLineY];
    if (line) {
      NSString* rightSideOfCursor = [line substringFromIndex:self.buffer.cursorOffsetX];
      NSMutableString* toAdd = [NSMutableString stringWithString:rightSideOfCursor];
      [line deleteCharactersInRange:NSMakeRange(self.buffer.cursorOffsetX, line.length - self.buffer.cursorOffsetX)];
      [self.buffer.lines insertObject:toAdd atIndex:self.buffer.cursorLineY + 1];
      self.buffer.cursorLineX = 0;
      [self moveDown];
    }
  }
}

- (void)addCharacter:(char)character {
  if (!self.buffer.markMode) {
    NSMutableString* line = [self textOnLine:self.buffer.cursorLineY];
    if (line) {
      [line insertString:[NSString stringWithFormat:@"%c", character] atIndex:self.buffer.cursorOffsetX];
      [self moveRight];
    }
  }
}

- (void)startMarkMode {
  if (self.buffer) {
    self.buffer.markMode = YES;
    self.buffer.markCursorLineX = self.buffer.cursorLineX;
    self.buffer.markCursorLineY = self.buffer.cursorLineY;
    self.buffer.markCursorOffsetX = self.buffer.cursorOffsetX;
    self.buffer.markCursorOffsetY = self.buffer.cursorOffsetY;
  }
}

- (BOOL)stopMarkMode {
  if (self.buffer && self.buffer.markMode) {
    self.buffer.markMode = NO;
    return YES;
  }
  return NO;
}

- (NSArray*)markCut {
  NSArray* text = nil;
  if (self.buffer && self.buffer.markMode) {
    text = [self markedTextWithDelete:YES];
    if (self.buffer.markCursorLineY < self.buffer.cursorLineY) {
      self.buffer.cursorLineY = self.buffer.markCursorLineY;
      self.buffer.cursorLineX = self.buffer.markCursorLineX;
      self.buffer.cursorOffsetX = self.buffer.markCursorOffsetX;
      self.buffer.cursorOffsetY = self.buffer.markCursorOffsetY;
      self.buffer.screenOffsetY = self.buffer.markScreenOffsetY;
    } else if (self.buffer.markCursorLineY == self.buffer.cursorLineY) {
      self.buffer.cursorLineX = MIN(self.buffer.markCursorLineX, self.buffer.cursorLineX);
      self.buffer.cursorOffsetX = MIN(self.buffer.markCursorOffsetX, self.buffer.cursorOffsetX);
    }
    self.buffer.markMode = NO;
  }
  return text;
}

- (NSArray*)markCopy {
  NSArray* text = nil;
  if (self.buffer && self.buffer.markMode) {
    text = [self markedTextWithDelete:NO];
    self.buffer.markMode = NO;
  }
  return text;
}

- (void)paste:(NSArray*)text {
  if (self.buffer && !self.buffer.markMode) {
    NSString* contentOnFirstLine = nil;
    for (int i = self.buffer.cursorLineY; i < self.buffer.cursorLineY + text.count; i++) {

      BOOL isFirstCopyLine = i == self.buffer.cursorLineY;
      if (isFirstCopyLine) {
        contentOnFirstLine = [[self.buffer.lines objectAtIndex:i] substringFromIndex:self.buffer.cursorLineX];
        if (contentOnFirstLine) {
          [[self.buffer.lines objectAtIndex:i] deleteCharactersInRange:NSMakeRange(self.buffer.cursorLineX, contentOnFirstLine.length)];
        }
        [[self.buffer.lines objectAtIndex:i] appendString:[text objectAtIndex:i - self.buffer.cursorLineY]];
      } else {
        [self.buffer.lines insertObject:[text objectAtIndex:i - self.buffer.cursorLineY] atIndex:i];
      }

      BOOL isLastCopyLine = i == self.buffer.cursorLineY + text.count - 1;
      if (isLastCopyLine && contentOnFirstLine) {
        [[self.buffer.lines objectAtIndex:i] appendString:contentOnFirstLine];
      }
    }
  }
}

- (void)openBuffer:(FileBuffer*)buffer {
  self.buffer = buffer;
}

#pragma mark Private methods

- (NSArray*)markedTextWithDelete:(BOOL) delete {
  NSMutableArray* deletedText = [NSMutableArray array];

  int lineStart = MIN(self.buffer.cursorLineY, self.buffer.markCursorLineY);
  int lineEnd = MAX(self.buffer.cursorLineY, self.buffer.markCursorLineY);

  int posStart = MIN(self.buffer.cursorLineX, self.buffer.markCursorLineX);
  int posEnd = MAX(self.buffer.cursorLineX, self.buffer.markCursorLineX);

  if (self.buffer.cursorLineY < self.buffer.markCursorLineY) {
    posStart = self.buffer.cursorLineX;
    posEnd = self.buffer.markCursorLineX;
  } else if (self.buffer.cursorLineY > self.buffer.markCursorLineY) {
    posStart = self.buffer.markCursorLineX;
    posEnd = self.buffer.cursorLineX;
  }
  if (posEnd + 1 < [[self.buffer.lines objectAtIndex:self.buffer.cursorLineY] length]) {
    posEnd++;
  }

  if (lineStart == lineEnd) {
    NSRange range = NSMakeRange(posStart, posEnd - posStart);
    [deletedText addObject:[NSMutableString stringWithString:[[self.buffer.lines objectAtIndex:lineStart] substringWithRange:range]]];
    if (delete) {
      [[self.buffer.lines objectAtIndex:lineStart] deleteCharactersInRange:range];
    }
  } else {
    for (int i = lineEnd; i >= lineStart; i--) {
      if (i == lineEnd) {
        NSRange range = NSMakeRange(0, posEnd);
        [deletedText addObject:[NSMutableString stringWithString:[[self.buffer.lines objectAtIndex:i] substringWithRange:range]]];
        if (delete) {
          [[self.buffer.lines objectAtIndex:i] deleteCharactersInRange:range];
        }
      } else if (i == lineStart) {
        NSRange range = NSMakeRange(posStart, [[self.buffer.lines objectAtIndex:i] length] - posStart);
        [deletedText addObject:[NSMutableString stringWithString:[[self.buffer.lines objectAtIndex:i] substringWithRange:range]]];
        if (delete) {
          [[self.buffer.lines objectAtIndex:i] deleteCharactersInRange:range];
        }
      } else {
        [deletedText addObject:[NSMutableString stringWithString:[self.buffer.lines objectAtIndex:i]]];
        if (delete) {
          [self.buffer.lines removeObjectAtIndex:i];
        }
      }
    }
  }

  return deletedText;
}

- (BOOL)bufferIsOpen {
  return self.buffer != nil;
}

- (BOOL)bufferIsEmpty {
  return !self.buffer.lines || self.buffer.lines.count == 0;
}

- (void)drawRect:(CGRect)rect
       inContext:(NCRenderContext*)context {
  if (!self.hidden) {
    if ([self bufferIsOpen]) {
      if (![self bufferIsEmpty]) {

        int expectedLines = 0;
        int totalLines = 0;
        for (int i = self.buffer.markMode ? self.buffer.markScreenOffsetY : self.buffer.screenOffsetY; i < self.buffer.lines.count && i <= (self.buffer.markMode ? self.buffer.markCursorLineY : self.buffer.cursorLineY); i++) {
          NSString* line = [self.buffer.lines objectAtIndex:i];
          CGSize size = [context sizeOfText:line
                                  breakMode:NCLineBreakByWordWrapping
                                      width:rect.size.width];
          expectedLines++;
          totalLines += MAX(size.height, 1);
        }

        int y = expectedLines - totalLines;
        for (int i = self.buffer.markMode ? self.buffer.markScreenOffsetY : self.buffer.screenOffsetY; i < self.buffer.lines.count; i++) {
          NSString* line = [self.buffer.lines objectAtIndex:i];
          if (line) {
            NCColorRange* colorRange = nil;
            NCColor* fg = NCColor.whiteColor;
            NCColor* bg = NCColor.blackColor;

            // Create mark color range
            if (self.buffer.markMode) {
              BOOL isLineBetweenCursors = (i > self.buffer.cursorLineY && i < self.buffer.markCursorLineY) ||
                                          (i < self.buffer.cursorLineY && i > self.buffer.markCursorLineY);

              BOOL isLineStartAndEnd = i == self.buffer.cursorLineY && i == self.buffer.markCursorLineY;
              BOOL isLineStart = i == MIN(self.buffer.cursorLineY, self.buffer.markCursorLineY);
              BOOL isLineEnd = i == MAX(self.buffer.cursorLineY, self.buffer.markCursorLineY);

              if (isLineBetweenCursors) {
                fg = NCColor.blackColor;
                bg = NCColor.whiteColor;
              } else if (isLineStartAndEnd) {
                if (self.buffer.cursorLineY == self.buffer.markCursorLineY) {
                  int min = MIN(self.buffer.cursorLineX, self.buffer.markCursorLineX);
                  int max = MAX(self.buffer.cursorLineX, self.buffer.markCursorLineX);
                  int len = max - min;
                  colorRange = [NCColorRange.alloc initWithForeground:NCColor.blackColor
                                                       withBackground:NCColor.whiteColor
                                                            withRange:NSMakeRange(min, len)];
                }
              } else if (isLineStart) {
                int x = self.buffer.cursorLineY < self.buffer.markCursorLineY ? self.buffer.cursorLineX : self.buffer.markCursorLineX;
                colorRange = [NCColorRange.alloc initWithForeground:NCColor.blackColor
                                                     withBackground:NCColor.whiteColor
                                                          withRange:NSMakeRange(x, line.length - x)];
              } else if (isLineEnd) {
                int x = self.buffer.cursorLineY > self.buffer.markCursorLineY ? self.buffer.cursorLineX : self.buffer.markCursorLineX;
                colorRange = [NCColorRange.alloc initWithForeground:NCColor.blackColor
                                                     withBackground:NCColor.whiteColor
                                                          withRange:NSMakeRange(0, x)];
              }
            }

            CGSize size = [context sizeOfText:line
                                    breakMode:NCLineBreakByWordWrapping
                                        width:rect.size.width];
            size.height = MAX(size.height, 1);

            [context drawText:line
                       inRect:CGRectMake(rect.origin.x, rect.origin.y + y, rect.size.width, size.height)
               withForeground:fg
               withBackground:bg
               withColorRange:colorRange
                    breakMode:NCLineBreakByWordWrapping
                 truncateMode:NCLineTruncationByClipping
                alignmentMode:NCLineAlignmentLeft];

            if (!self.buffer.markMode && i == self.buffer.cursorLineY) {
              CGSize cursor = [context locationForX:self.buffer.markMode ? self.buffer.markCursorOffsetX : self.buffer.cursorOffsetX
                                             inText:line
                                             inRect:CGRectMake(rect.origin.x, rect.origin.y + y, rect.size.width, size.height)
                                          breakMode:NCLineBreakByWordWrapping
                                        tuncateMode:NCLineTruncationByClipping];
              [context drawPoint:CGSizeMake(self.frame.origin.x + cursor.width, self.frame.origin.y + y + cursor.height)
                  withForeground:NCColor.blackColor
                  withBackground:NCColor.whiteColor];
            }

            y += size.height;
            if (y >= rect.size.height) {
              break;
            }
          }
        }
      }

    } else {
      [context drawText:@"No buffer open"
                 inRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height / 2, rect.size.width, 1)
         withForeground:NCColor.whiteColor
         withBackground:NCColor.blackColor
         withColorRange:nil
              breakMode:NCLineBreakByNoWrapping
           truncateMode:NCLineTruncationByTruncationTail
          alignmentMode:NCLineAlignmentCenter];
    }
  }
  [super drawRect:rect
        inContext:context];
}

- (NSMutableString*)textOnLine:(int)line {
  if (line >= 0 && line < self.buffer.lines.count) {
    return [self.buffer.lines objectAtIndex:line];
  }
  return nil;
}

@end
