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

#import "NXSystemLogTarget.h"
#import "NXSystemLogFormatter.h"
#import <asl.h>

@implementation NXSystemLogTarget

@synthesize maxLogLevel = _maxLogLevel;
@synthesize logFormatter = _logFormatter;

+ (instancetype)sharedInstance {
    NSAssert(self == NXSystemLogTarget.class, @"A subclass of this singleton needs its own sharedInstance!");
    static id sharedInstance = nil;
    static dispatch_once_t initOnce;
    dispatch_once(&initOnce, ^{
        sharedInstance = [[self alloc] initWithFormatter:[NXSystemLogFormatter sharedInstance]];
    });
    return sharedInstance;
}

- (instancetype)initWithFormatter:(id<NXLogFormatter>)formatter {
    self = [super init];
    if (self) {
        _logFormatter = formatter;
    }
    return self;
}

- (void)log:(NXLogLevel)level message:(id)message {

    NSString *msg = [NSString stringWithFormat:@"%@", message];
    
    asl_log(NULL, NULL, [self.class _ASLLevel:level], "%s", [msg UTF8String]);
}

#pragma mark - Private methods
/*
+ (void)_enableStdErrorLog {
    static dispatch_once_t addErrLogOnce;
    dispatch_once(&addErrLogOnce, ^{
//        asl_add_log_file(NULL, STDERR_FILENO);
        asl_add_output_file(NULL, STDERR_FILENO, ASL_MSG_FMT_MSG, ASL_TIME_FMT_LCL, ASL_FILTER_MASK_UPTO(ASL_LEVEL_DEBUG), ASL_ENCODE_SAFE);
    });
}
*/
+ (int)_ASLLevel:(NXLogLevel)level {
    switch (level) {
        case NXLogLevelDebug:
            return ASL_LEVEL_DEBUG;
        case NXLogLevelInfo:
            return ASL_LEVEL_INFO;
        case NXLogLevelNotice:
            return ASL_LEVEL_NOTICE;
        case NXLogLevelWarning:
            return ASL_LEVEL_WARNING;
        case NXLogLevelError:
            return ASL_LEVEL_ERR;
        case NXLogLevelCritical:
            return ASL_LEVEL_CRIT;
        case NXLogLevelAlert:
            return ASL_LEVEL_ALERT;
        case NXLogLevelEmergency:
            return ASL_LEVEL_EMERG;
        default:
            return ASL_LEVEL_NOTICE;
    }
}

@end
