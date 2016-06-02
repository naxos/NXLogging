// -----------------------------------------------------------------------------
// This file is part of NXLogging.
//
// Copyright © 2016 Naxos Software Solutions GmbH. All rights reserved.
//
// Author: Martin Schaefer <martin.schaefer@naxos-software.de>
//
// NXLogging is licensed under the Simplified BSD License
// -----------------------------------------------------------------------------
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// -----------------------------------------------------------------------------

#import "NXFileLogTarget.h"
#import "NXDebugLogFormatter.h"

@interface NXFileLogTarget ()

@property (atomic) NSFileHandle *fileHandle;

@end

@implementation NXFileLogTarget {
    NSMutableArray *_fileNamesHistory;
    NSDate *_currentFileCreationDate;
    NSOperationQueue *_writeQueue;
}

@synthesize maxLogLevel = _maxLogLevel;
@synthesize logFormatter = _logFormatter;

+ (instancetype)sharedInstance {
    NSAssert(self == NXFileLogTarget.class, @"A subclass of this singleton needs its own sharedInstance!");
    static id sharedInstance = nil;
    static dispatch_once_t initOnce;
    dispatch_once(&initOnce, ^{
        
        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
        NSString *baseName = [bundleIdentifier componentsSeparatedByString:@"."].lastObject;
        NSString *logFileName = [baseName stringByAppendingPathExtension:@"log"];
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:logFileName];

        sharedInstance = [[self alloc] initWithFormatter:[NXDebugLogFormatter sharedInstance] file:logFilePath];
    });
    return sharedInstance;
}

- (instancetype)initWithFormatter:(id<NXLogFormatter>)formatter file:(NSString *)path {
    self = [super init];
    if (self) {
        _maxLogLevel = NXLogLevelDebug;
        _logFormatter = formatter;
        _filePath = path;
        _fileNamesHistory = [self _createHistory];
        _writeQueue = [NSOperationQueue new];
        _writeQueue.maxConcurrentOperationCount = 1; // Force serialization on the file
    }
    return self;
}

- (void)dealloc {
    [self _closeFile];
}

- (void)log:(NXLogLevel)level message:(id)message {
    
    NSString *msg = [NSString stringWithFormat:@"%@\n", message];
    
    // Put the write op into a queue and let it do the job for us
    [_writeQueue addOperationWithBlock:^{
        [[self _currentFileHandle] writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    }];
}

#pragma mark - Private methods

- (NSFileHandle *)_currentFileHandle {
    
    [self _rollOverIfNeeded];
    
    if (self.fileHandle == nil) {
        NSFileManager *fmgr = [NSFileManager defaultManager];
        BOOL isDir;
        
        if ([fmgr fileExistsAtPath:_filePath isDirectory:&isDir]) {
            if (isDir) {
                [NSException raise:@"FileIsDirectoryException" format:@"Expected a file, but found a directory %@", _filePath];
            }
            if (![fmgr isWritableFileAtPath:_filePath]) {
                [NSException raise:@"FileNotWritableException" format:@"Unable to write to file at path %@", _filePath];
            }
            NSDictionary *meta = [fmgr attributesOfItemAtPath:_filePath error:nil];
                
            _currentFileCreationDate = meta.fileCreationDate;
        } else {
            if (![self _createFile]) {
                [NSException raise:@"FileCreationFailedException" format:@"Unable to create file at path %@", _filePath];
            }
            _currentFileCreationDate = [NSDate new];
        }
        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_filePath];
        
        if (self.fileHandle == nil) {
            [NSException raise:@"FileNotWritableException" format:@"Unable to create handle for file at path %@", _filePath];
        }
        [self.fileHandle seekToEndOfFile];
    }
    
    return self.fileHandle;
}

- (void)_rollOverIfNeeded {
    if (_maxAge || _maxSize) {
        /* Don't read the file attributes, we already have everything we need
        NSFileManager *fmgr = [NSFileManager defaultManager];
        NSError *error;
        
        NSDictionary *meta = [fmgr attributesOfItemAtPath:_filePath error:&error];
        
        NSDate *creationDate = meta.fileCreationDate;
        unsigned long long size = meta.fileSize;
        */
        
        NSDate *creationDate = _currentFileCreationDate;
        unsigned long long size = self.fileHandle.offsetInFile;
        
        if (_maxSize && size >= _maxSize) {
            [self _rollOver];
        } else if (_maxAge && -[creationDate timeIntervalSinceNow] > _maxAge) {
            [self _rollOver];
        }
    }
}

- (BOOL)_rollOver {
    NSString *path = _filePath;
    NSString *ext = [path pathExtension];
    NSFileManager *fmgr = [NSFileManager defaultManager];
    NSError *error;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];

    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss_SSS"];
    
    if (ext.length) {
        path = [path stringByDeletingPathExtension];
    }

    path = [path stringByAppendingFormat:@"-%@", [dateFormatter stringFromDate:[NSDate new]]];
    
    if (ext.length) {
        path = [path stringByAppendingPathExtension:ext];
    }

    [self _closeFile];
        
    if ([fmgr moveItemAtPath:_filePath toPath:path error:&error]) {
        [_fileNamesHistory addObject:path.lastPathComponent];
        
        // NSLog(@"Rolled over log file %@", _filePath.lastPathComponent);

        // Purge if necessary
        
        while (_maxNumberOfFiles && (_fileNamesHistory.count >= _maxNumberOfFiles)) {
            
            // will normally only run once, unless maxNumberOfFiles changed
            
            NSString *pathToDelete = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:_fileNamesHistory.firstObject];
            
            [fmgr removeItemAtPath:pathToDelete error:nil];
            
            [_fileNamesHistory removeObjectAtIndex:0];
        }
        return YES;
    //} else {
        //NSLog(@"Unable to rollover log file: %@", error);
    }
    
    return NO;
}

- (BOOL)_createFile {
    NSFileManager *fmgr = [NSFileManager defaultManager];
    
    return [fmgr createFileAtPath:_filePath
                      contents:NULL
                    attributes:@{
                                 // NSFileProtectionKey : NSFileProtectionCompleteUnlessOpen
                                 }];
}

- (void)_closeFile {
    [self.fileHandle closeFile];
    self.fileHandle = nil;
}

- (NSMutableArray<NSString *> *)_createHistory {
    NSFileManager *fmgr = [NSFileManager defaultManager];
    NSError *error;
    NSString *baseName = [_filePath.lastPathComponent stringByDeletingPathExtension];
    NSString *ext = [_filePath pathExtension];
    
    NSArray *files = [fmgr contentsOfDirectoryAtPath:[_filePath stringByDeletingLastPathComponent] error:&error];
    NSMutableArray<NSString *> *fileNames = [NSMutableArray new];
    
    baseName = [baseName stringByAppendingString:@"-"];
    
    for (NSString *path in files) {
        NSString *name = path.lastPathComponent;
        
        if ([name hasPrefix:baseName] && [name hasSuffix:ext]) {
            [fileNames addObject:name];
        }
    }
    
    [fileNames sortUsingComparator:^NSComparisonResult(NSString *name1, NSString *name2) {
        return [name1 compare:name2];
    }];
    
    return fileNames;
}
     
@end
