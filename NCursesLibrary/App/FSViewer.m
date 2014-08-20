//
//  TestView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "FSViewer.h"

@interface FSViewer ()
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) Folder *parentFolder;

@property (nonatomic, strong) NSString *fileNewName;

@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *filteredFiles;
@property (nonatomic, strong) NSArray *filteredFolders;

@property (nonatomic, strong) NSArray *files;
@property (nonatomic, strong) NSArray *folders;
@property (nonatomic, assign) int lineY;
@property (nonatomic, assign) int screenY;
@property (nonatomic, assign) int screenOffsetY;
@end

@implementation FSViewer

- (void)drawRect:(CGRect)rect
       inContext:(NCRenderContext *)context
{
    if(!CGRectIsEmpty(rect) && !self.hidden)
    {
        NSArray *folders = self.filteredFolders ? self.filteredFolders : self.folders;
        NSArray *files = self.filteredFiles ? self.filteredFiles : self.files;
        
        // Draw path
        if(self.path && self.path.length > 0) {
            [context drawText:self.path
                       inRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 1)
               withForeground:[NCColor whiteColor]
               withBackground:[NCColor blackColor]
               withColorRange:nil
                    breakMode:NCLineBreakByNoWrapping
                 truncateMode:NCLineTruncationByTruncatingHead
                alignmentMode:NCLineAlignmentCenter];
        }
        
        // Draw filter
        if(self.filter && self.filter.length > 0) {
            NSString *text = [NSString stringWithFormat:@"filter: '%@'",self.filter];
            CGSize textSize = [context sizeOfText:text
                                        breakMode:NCLineBreakByNoWrapping
                                            width:rect.size.width];
            [context drawText:text
                       inRect:CGRectMake(rect.origin.x, rect.origin.y, textSize.width, 1)
               withForeground:[NCColor blackColor]
               withBackground:[NCColor whiteColor]
               withColorRange:nil
                    breakMode:NCLineBreakByNoWrapping
                 truncateMode:NCLineTruncationByTruncationTail
                alignmentMode:NCLineAlignmentLeft];
        }
        
        // Draw new file name
        if(self.fileNewName && self.fileNewName.length > 0) {
            NSString *text = [NSString stringWithFormat:@"new file: '%@'",self.fileNewName];
            CGSize textSize = [context sizeOfText:text
                                        breakMode:NCLineBreakByNoWrapping
                                            width:rect.size.width];
            [context drawText:text
                       inRect:CGRectMake(rect.origin.x, rect.origin.y, textSize.width, 1)
               withForeground:[NCColor blackColor]
               withBackground:[NCColor whiteColor]
               withColorRange:nil
                    breakMode:NCLineBreakByNoWrapping
                 truncateMode:NCLineTruncationByTruncationTail
                alignmentMode:NCLineAlignmentLeft];
        }
        
        // Draw folders
        int y = 1;
        
        NSArray *filesAndFolders = [folders arrayByAddingObjectsFromArray:files];
        
        for (int i = self.screenOffsetY; folders && files && i < filesAndFolders.count && i < self.screenOffsetY + self.frame.size.height; i++) {
            
            NSObject *obj = [filesAndFolders objectAtIndex:i];
            if(obj && [obj isKindOfClass:[Folder class]]) {
                Folder *folder = (Folder*)obj;
                
                NSString *text = [NSString stringWithFormat:@"- %@",folder.dirName];
                
                CGSize textSize = [context sizeOfText:text
                                            breakMode:NCLineBreakByWordWrapping
                                                width:rect.size.width];
                
                if(self.lineY == i) {
                    [context drawText:text
                               inRect:CGRectMake(rect.origin.x, rect.origin.y + y, textSize.width, textSize.height)
                       withForeground:[NCColor blackColor]
                       withBackground:[NCColor whiteColor]
                       withColorRange:nil
                            breakMode:NCLineBreakByWordWrapping
                         truncateMode:NCLineTruncationByClipping
                        alignmentMode:NCLineAlignmentLeft];
                } else {
                    [context drawText:text
                               inRect:CGRectMake(rect.origin.x, rect.origin.y + y, textSize.width, textSize.height)
                       withForeground:[NCColor whiteColor]
                       withBackground:[NCColor blackColor]
                       withColorRange:nil
                            breakMode:NCLineBreakByWordWrapping
                         truncateMode:NCLineTruncationByClipping
                        alignmentMode:NCLineAlignmentLeft];
                }
                
                y += textSize.height;
            } else if(obj && [obj isKindOfClass:[File class]]) {
                File *file = (File*)obj;
                
                NSString *text = [NSString stringWithFormat:@"  %@",file.fileName];
                
                CGSize textSize = [context sizeOfText:text
                                            breakMode:NCLineBreakByWordWrapping
                                                width:rect.size.width];
                
                if(self.lineY == i) {
                    [context drawText:text
                               inRect:CGRectMake(rect.origin.x, rect.origin.y + y, textSize.width, textSize.height)
                       withForeground:[NCColor blackColor]
                       withBackground:[NCColor whiteColor]
                       withColorRange:nil
                            breakMode:NCLineBreakByWordWrapping
                         truncateMode:NCLineTruncationByClipping
                        alignmentMode:NCLineAlignmentLeft];
                } else {
                    [context drawText:text
                               inRect:CGRectMake(rect.origin.x, rect.origin.y + y, textSize.width, textSize.height)
                       withForeground:[NCColor whiteColor]
                       withBackground:[NCColor blackColor]
                       withColorRange:nil
                            breakMode:NCLineBreakByWordWrapping
                         truncateMode:NCLineTruncationByClipping
                        alignmentMode:NCLineAlignmentLeft];
                }
                
                y += textSize.height;
            }
            
        }
    }
    [super drawRect:rect inContext:context];
}

- (void) openPath:(NSString *)path
{
    self.path = path;
    self.lineY = 0;
    self.screenY = 0;
    self.screenOffsetY = 0;
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *files = [NSMutableArray array];
    NSMutableArray *folders = [NSMutableArray array];
    
    if(path.length > 1 && [self previousFolderIn:path]) {
        Folder *folder = [[Folder alloc] initWithPath:[self previousFolderIn:path]];
        folder.dirName = @"..";
        [folders addObject:folder];
        
        self.parentFolder = folder;
    }
    
    for(int i = 0; i < contents.count; i++) {
        NSString *f = [path stringByAppendingString:[contents objectAtIndex:i]];
        BOOL isDir = YES;
        if([[NSFileManager defaultManager] fileExistsAtPath:f isDirectory:&isDir]) {
            if(isDir) {
                Folder * folder = [[Folder alloc] initWithPath:f];
                if(!folder.isHidden) {
                    [folders addObject:folder];
                }
            } else {
                File *file = [[File alloc] initWithPath:f];
                if(!file.isHidden) {
                    [files addObject:file];
                }
            }
        }
    }
    
    self.files = files;
    self.folders = folders;
}

- (NSString*) previousFolderIn:(NSString*)path
{
    if(path.length > 1) {
        for(int i = (int)path.length - 1; i >= 0; i--) {
            if([path characterAtIndex:i] == '/' && i != (int)path.length - 1) {
                if(i == 0) {
                    return [path substringToIndex:1];
                } else {
                    return [path substringToIndex:i];
                }
            }
        }
        return path;
    } else {
        return nil;
    }
}

- (void) moveUp
{
    if(self.screenY == 0) {
        if(self.screenOffsetY > 0) {
            self.screenOffsetY--;
            self.lineY--;
        }
    } else {
        self.screenY--;
        self.lineY--;
    }
}

- (void) moveDown
{
    NSArray *folders = self.filteredFolders ? self.filteredFolders : self.folders;
    NSArray *files = self.filteredFiles ? self.filteredFiles : self.files;
    
    if(self.lineY + 1 < files.count + folders.count) {
        if(self.screenY + 2 < self.frame.size.height) {
            self.screenY++;
            self.lineY++;
        } else {
            self.screenOffsetY++;
            self.lineY++;
        }
    }
}

- (void) moveIn
{
    if(self.fileNewName && self.fileNewName.length > 0) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectFile:)]) {
            [self.delegate didSelectFile:[self.path stringByAppendingString:self.fileNewName]];
        }
        return;
    }
    
    NSArray *folders = self.filteredFolders ? self.filteredFolders : self.folders;
    NSArray *files = self.filteredFiles ? self.filteredFiles : self.files;
    
    if(self.lineY >= folders.count && self.lineY < folders.count + files.count) {
        File *file = [files objectAtIndex:self.lineY - folders.count];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectFile:)]) {
            [self.delegate didSelectFile:file.path];
        }
    } else if(self.lineY < folders.count) {
        Folder *folder = [folders objectAtIndex:self.lineY];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectFolder:)]) {
            [self.delegate didSelectFolder:folder.path];
        }
    }
    
    [self filterClear];
}

- (void) moveOut
{
    if(self.parentFolder) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectFolder:)]) {
            [self.delegate didSelectFolder:self.parentFolder.path];
        }
    }
}

- (void) filterAddCharacter:(char)character
{
    self.lineY = 0;
    self.screenY = 0;
    self.screenOffsetY = 0;
    if(!self.filter) {
        self.filter = [NSString stringWithFormat:@"%c",character];
    } else {
        self.filter = [self.filter stringByAppendingFormat:@"%c",character];
    }
    
    self.filteredFolders = [self.folders filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Folder *folder, NSDictionary *bindings) {
        return [[folder.dirName lowercaseString] rangeOfString:[self.filter lowercaseString]].location != NSNotFound;
    }]];
    
    self.filteredFiles = [self.files filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(File *file, NSDictionary *bindings) {
        return [[file.fileName lowercaseString] rangeOfString:[self.filter lowercaseString]].location != NSNotFound;
    }]];
}

- (void) filterRemovePreviousCharacter
{
    self.lineY = 0;
    self.screenY = 0;
    self.screenOffsetY = 0;
    if(self.filter) {
        if(self.filter.length > 1) {
            self.filter = [self.filter substringToIndex:self.filter.length-1];
        } else {
            self.filter = nil;
            self.filteredFiles = nil;
            self.filteredFolders = nil;
        }
    }
}

- (void) filterClear
{
    self.lineY = 0;
    self.screenY = 0;
    self.screenOffsetY = 0;
    self.filter = nil;
    self.filteredFiles = nil;
    self.filteredFolders = nil;
}

- (void) fileNewAddCharacter:(char)character
{
    if(!self.fileNewName) {
        self.fileNewName = [NSString stringWithFormat:@"%c",character];
    } else {
        self.fileNewName = [self.fileNewName stringByAppendingFormat:@"%c",character];
    }
}

- (void) fileNewRemovePreviousCharacter
{
    if(self.fileNewName) {
        if(self.fileNewName.length > 1) {
            self.fileNewName = [self.fileNewName substringToIndex:self.fileNewName.length-1];
        } else {
            self.fileNewName = nil;
        }
    }
}

- (void) fileNewClear
{
    self.fileNewName = nil;
}

@end

@implementation File

- (id) initWithPath:(NSString*) path
{
    self = [super init];
    if(self) {
        self.path = path;
        self.fileName = [path lastPathComponent];
        self.fileExtension = [path pathExtension];
        if(self.fileName.length > 0 && [[self.fileName substringToIndex:1] isEqualToString:@"."]) {
            self.isHidden = YES;
        } else {
            self.isHidden = NO;
        }
    }
    return self;
}

@end

@implementation Folder

- (id) initWithPath:(NSString*) path
{
    self = [super init];
    if(self) {
        self.path = path.length > 0 && ![[path substringFromIndex:path.length-1] isEqualToString:@"/"] ? [path stringByAppendingString:@"/"] : path;
        self.dirName = [path lastPathComponent];
        if(self.dirName.length > 0 && [[self.dirName substringToIndex:1] isEqualToString:@"."]) {
            self.isHidden = YES;
        } else {
            self.isHidden = NO;
        }
    }
    return self;
}

@end
