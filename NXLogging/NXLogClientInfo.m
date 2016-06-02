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

#import "NXLogClientInfo.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "NXLogTypes.h"
#include <pthread.h>

@interface NSMutableString (NXLogging)

-(void)replaceVariable:(NSString *)variable with:(id)value;

@end

@implementation NXLogClientInfo  {
    NSDateFormatter *_dateFormatter;
}

- (instancetype)initWithSourceCodeInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        UIDevice *device = [UIDevice currentDevice];
        NSProcessInfo *process = NSProcessInfo.processInfo;

        _dateFormatter = [NSDateFormatter new]; // Beware: Only thread-safe from iOS 7 upwards
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        _file = info[@(NXLogInfoFile)];
        _function = info[@(NXLogInfoFunction)];
        _line = info[@(NXLogInfoLine)];
        _module = info[@(NXLogInfoModule)];
        _date = [NSDate new];
        _processName = process.processName;
        _processID = @(process.processIdentifier);
        _deviceName = device.name;
        _deviceModel = [self.class _model];//device.model;
        _systemName = device.systemName;
        _systemVersion = device.systemVersion;
    }
    return self;
}

- (NSString *)stringByReplacingVariablesInString:(NSString *)string {
    
    if ([string rangeOfString:@"$("].location != NSNotFound) {
        NSMutableString *msg = [NSMutableString stringWithString:string];
        
        [msg replaceVariable:@"file" with:self.file.length ? self.file.lastPathComponent : nil];
        [msg replaceVariable:@"function" with:self.function];
        [msg replaceVariable:@"line" with:self.line];
        [msg replaceVariable:@"module" with:self.module];
        [msg replaceVariable:@"date" with:self.date ? [_dateFormatter stringFromDate:self.date] : nil];
        [msg replaceVariable:@"processName" with:self.processName];
        [msg replaceVariable:@"processID" with:self.processID];
        [msg replaceVariable:@"deviceName" with:self.deviceName];
        [msg replaceVariable:@"deviceModel" with:self.deviceModel];
        [msg replaceVariable:@"systemName" with:self.systemName];
        [msg replaceVariable:@"systemVersion" with:self.systemVersion];

        return msg;
    }
    
    return string;
}

#pragma mark - Private methods

+ (NSString *)_model {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end

@implementation NSMutableString (NXLogging)

-(void)replaceVariable:(NSString *)variable with:(id)value {
    
    NSString *val = value ? [NSString stringWithFormat:@"%@", value] : nil;
    val = val.length ? val : [NSString stringWithFormat:@"<Unknown %@>", variable];
    
    [self replaceOccurrencesOfString:[NSString stringWithFormat:@"$(%@)", variable] withString:val options:NSLiteralSearch range:NSMakeRange(0, self.length)];
}

@end

