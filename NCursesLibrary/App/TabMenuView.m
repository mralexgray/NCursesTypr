//
//  TabMenuView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-24.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "TabMenuView.h"

@implementation TabMenuItem

@end

@interface TabMenuView ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int offsetX;
@end

@implementation TabMenuView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)addMenuItem:(NSString *)name
                tag:(NSObject *)tag
{
    if(name) {
        TabMenuItem *item = [[TabMenuItem alloc] init];
        item.name = name;
        item.tag = tag;
        [self.items addObject:item];
        
        if(self.items.count == 1) {
            if(self.output && [self.output respondsToSelector:@selector(didSelectItem:)]) {
                [self.output didSelectItem:item];
            }
        }
    }
}

- (BOOL)removeCurrentItem
{
    BOOL didRemove = NO;
    
    if(self.currentIndex >= 0 && self.currentIndex < self.items.count) {
        [self.items removeObjectAtIndex:self.currentIndex];
        if(self.currentIndex >= self.items.count && self.currentIndex != 0) {
            self.currentIndex--;
        }
        didRemove = YES;
    }
    
    if(self.items.count > 0 && self.currentIndex >= 0 && self.currentIndex < self.items.count) {
        if(self.output && [self.output respondsToSelector:@selector(didSelectItem:)]) {
            [self.output didSelectItem:[self.items objectAtIndex:self.currentIndex]];
        }
    } else {
        if(self.output && [self.output respondsToSelector:@selector(didSelectItem:)]) {
            [self.output didSelectItem:nil];
        }
    }
    
    return didRemove;
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
    self.currentIndex = 0;
}

- (void) moveLeft
{
    if(self.currentIndex > 0) {
        self.currentIndex--;
        
        TabMenuItem *item = [self.items objectAtIndex:self.currentIndex];
        if(self.output && [self.output respondsToSelector:@selector(didSelectItem:)]) {
            [self.output didSelectItem:item];
        }
    }
}

- (void) moveRight
{
    if(self.currentIndex + 1 < self.items.count) {
        self.currentIndex++;
        
        TabMenuItem *item = [self.items objectAtIndex:self.currentIndex];
        if(self.output && [self.output respondsToSelector:@selector(didSelectItem:)]) {
            [self.output didSelectItem:item];
        }
    }
}

- (void)setCurrentTabName:(NSString *)name
{
    if(name && self.currentIndex >= 0 && self.currentIndex < self.items.count) {
        TabMenuItem *item = [self.items objectAtIndex:self.currentIndex];
        item.name = name;
    }
}

- (void)setCurrentTabTag:(NSObject *)tag
{
    if(self.currentIndex >= 0 && self.currentIndex < self.items.count) {
        TabMenuItem *item = [self.items objectAtIndex:self.currentIndex];
        item.tag = tag;
    }
}

- (void)drawRect:(CGRect)rect
       inContext:(NCRenderContext *)context
{
    [super drawRect:rect
          inContext:context];
    
    if(!self.hidden)
    {
        int rx = 0;
        int tempOffsetX = self.offsetX;
        for(int i = 0; i < self.items.count && rx < self.frame.size.width; i++) {
            TabMenuItem *item = [self.items objectAtIndex:i];
            int lenToDraw = ((int)item.name.length)+2 - tempOffsetX;
            tempOffsetX -= (item.name.length+2);
            tempOffsetX = MAX(tempOffsetX, 0);
            
            if(lenToDraw > 0) {
                [context drawText:[[NSString stringWithFormat:@"[%@]",item.name] substringFromIndex:((int)item.name.length+2) - lenToDraw]
                           inRect:CGRectMake(self.frame.origin.x + rx, self.frame.origin.y, lenToDraw, 1)
                   withForeground:i == self.currentIndex ? self.passiveColor : self.activeColor
                   withBackground:i == self.currentIndex ? self.activeColor : self.passiveColor
                   withColorRange:nil
                        breakMode:NCLineBreakByNoWrapping
                     truncateMode:NCLineTruncationByClipping
                    alignmentMode:NCLineAlignmentLeft];
                rx += lenToDraw;
            }
        }
    }
}

@end
