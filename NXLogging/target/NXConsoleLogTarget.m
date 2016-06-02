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

#import "NXConsoleLogTarget.h"
#import "NXDebugLogFormatter.h"

@implementation NXConsoleLogTarget {
    NSMutableDictionary<NSNumber *, NXTextColor *> *_logLevelColors;
}

@synthesize maxLogLevel = _maxLogLevel;
@synthesize logFormatter = _logFormatter;

+ (instancetype)sharedInstance {
    NSAssert(self == NXConsoleLogTarget.class, @"A subclass of this singleton needs its own sharedInstance!");
    static id sharedInstance = nil;
    static dispatch_once_t initOnce;
    dispatch_once(&initOnce, ^{
        sharedInstance = [[self alloc] initWithFormatter:[NXDebugLogFormatter sharedInstance]];
    });
    return sharedInstance;
}

- (instancetype)initWithFormatter:(id<NXLogFormatter>)formatter {
    self = [super init];
    if (self) {
        _maxLogLevel = NXLogLevelDebug;
        _logFormatter = formatter;
        _logLevelColors = [@{@(NXLogLevelEmergency) : [NXTextColor colorWithRed:222 / 255.f
                                                                          green: 26 / 255.f
                                                                           blue: 22 / 255.f],
                             @(NXLogLevelAlert)     : [NXTextColor colorWithRed:222 / 255.f
                                                                          green: 26 / 255.f
                                                                           blue: 22 / 255.f],
                             @(NXLogLevelCritical)  : [NXTextColor colorWithRed:222 / 255.f
                                                                          green: 26 / 255.f
                                                                           blue: 22 / 255.f],
                             @(NXLogLevelError)     : [NXTextColor colorWithRed:196 / 255.f
                                                                          green: 66 / 255.f
                                                                           blue: 22 / 255.f],
                             @(NXLogLevelWarning)   : [NXTextColor colorWithRed:235 / 255.f
                                                                          green:138 / 255.f
                                                                           blue: 22 / 255.f],
                             @(NXLogLevelNotice)    : [NXTextColor colorWithRed: 38 / 255.f
                                                                          green: 71 / 255.f
                                                                           blue: 75 / 255.f],
                             @(NXLogLevelInfo)      : [NXTextColor colorWithRed: 63 / 255.f
                                                                          green:110 / 255.f
                                                                           blue:116 / 255.f],
                             @(NXLogLevelDebug)     : [NXTextColor colorWithRed:  0 / 255.f
                                                                          green:116 / 255.f
                                                                           blue:  0 / 255.f]} mutableCopy];
    }
    return self;
}

- (void)setColor:(NXTextColor *)color forLoglevel:(NXLogLevel)level {
    if (color) {
        _logLevelColors[@(level)] = color;
    } else {
        [_logLevelColors removeObjectForKey:@(level)];
    }
}

- (NXTextColor *)colorForLogLevel:(NXLogLevel)level {
    return _logLevelColors[@(level)];
}

- (void)log:(NXLogLevel)level message:(id)message {

    NSString *msg = [NSString stringWithFormat:@"%@", message];
    
    if (_colorsEnabled) {
        NXTextColor *color = _logLevelColors[@(level)];
        
        if (color) {
            msg = [color colorizeText:msg];
        }
    }
    
    fprintf(stdout, "%s\n", [msg UTF8String]);
}

@end
