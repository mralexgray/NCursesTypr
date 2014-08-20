//
//  TestViewController.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCViewController.h"
#import "FSViewer.h"

@protocol FileSelectorViewControllerDelegate <NSObject>

- (void) didSelectFile:(NSString*)file
               withTag:(int)tag;

@end

@interface FileSelectorViewController : NCViewController <FSViewerDelegate>

- (id) initWithPath:(NSString*) path
            withTag:(int)tag;

@property (nonatomic, weak) id<FileSelectorViewControllerDelegate> output;
@property (nonatomic, assign) BOOL allowNewFile;

@end
