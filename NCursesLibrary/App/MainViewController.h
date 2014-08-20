//
//  DetailViewController.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-18.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCViewController.h"

#import "FileSelectorViewController.h"
#import "TextEditorView.h"
#import "TabMenuView.h"

@interface MainViewController : NCViewController <TextEditorViewOutput, TabMenuViewOutput, FileSelectorViewControllerDelegate>

@end
