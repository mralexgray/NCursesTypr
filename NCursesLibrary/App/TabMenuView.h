//
//  TabMenuView.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-24.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"

@interface TabMenuItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSObject *tag;
@end

@protocol TabMenuViewOutput <NSObject>
- (void) didSelectItem:(TabMenuItem*)item;
@end

@interface TabMenuView : NCView

@property (nonatomic, strong) NCColor *passiveColor;
@property (nonatomic, strong) NCColor *activeColor;

- (void) addMenuItem:(NSString*)name
                 tag:(NSObject*)tag;
- (BOOL) removeCurrentItem;
- (void) removeAllItems;

- (void) moveLeft;
- (void) moveRight;

- (void) setCurrentTabName:(NSString*)name;
- (void) setCurrentTabTag:(NSObject*)tag;

@property (nonatomic, weak) id<TabMenuViewOutput> output;

@end
