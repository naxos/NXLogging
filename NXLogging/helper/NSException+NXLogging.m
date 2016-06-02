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

#import "NSException+NXLogging.h"
#import <objc/runtime.h>

@implementation NSException (NXLogging)

#pragma mark - Static methods

+ (NSException *)probe:(void(^)())tryBlock {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}

+ (void)raise:(NSString *)name {
    [[[NSException alloc] initWithName:name reason:nil userInfo:nil] raise];
}

+ (void)raise:(NSString *)name cause:(NSException *)cause format:(NSString *)format, ... {
    NSString *reason = nil;

    if (format) {
        va_list args;
        va_start(args, format);

        reason = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
    }

    NSException *exc = [NSException exceptionWithName:name cause:cause reason:reason userInfo:nil];

    [exc raise];
}

+ (void)raise:(NSString *)name cause:(NSException *)cause format:(NSString *)format arguments:(va_list)argList {
    NSString *reason = format ? [[NSString alloc] initWithFormat:format arguments:argList] : nil;
    
    NSException *exc = [NSException exceptionWithName:name cause:cause reason:reason userInfo:nil];

    [exc raise];
}

+ (NSException *)exceptionWithName:(NSString *)name cause:(NSException *)cause reason:(NSString *)reason userInfo:(NSDictionary *)userInfo {
    
    return [[self alloc] initWithName:name cause:cause reason:reason userInfo:userInfo];
}

#pragma mark - Initializers

- (instancetype)initWithName:(NSString *)aName cause:(NSException *)cause reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo {
    
    self = [self initWithName:aName reason:aReason userInfo:aUserInfo];
    if (self) {
        self.cause = cause;
    }
    
    return self;
}

#pragma mark - Overwritten getters and setters

- (NSException *)cause {
    return objc_getAssociatedObject(self, @selector(cause));
}

- (void)setCause:(NSException *)cause {
    objc_setAssociatedObject(self, @selector(cause), cause, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)logTrace {
    return [self logTrace:YES];
}

- (NSString *)logInfo {
    return [self logInfo:YES];
}

- (NSString *)logTrace:(BOOL)includeSymbols {
    return [@"Exception: " stringByAppendingString:[self _trace:includeSymbols]];
}

- (NSString *)logInfo:(BOOL)includeSymbols {
    
    NSMutableString *exc = [NSMutableString stringWithFormat:@"%@", self.reason ? self.reason : @"An exception occurred"];
    
    if (self.name.length) {
        [exc appendFormat:@" (%@)", self.name];
    }
    
    if (includeSymbols && self.callStackSymbols.count) {
        for (NSString *sym in self.callStackSymbols) {
            [exc appendFormat:@"\n   %@", sym];
        }
    }
    
    return exc;
}

#pragma mark - Private methods

- (NSString *)_trace:(BOOL)includeSymbols {
    NSString *info = [self logInfo:includeSymbols];
    
    if (self.cause) {
        info = [info stringByAppendingFormat:@"\nCaused by: %@", [self.cause _trace:includeSymbols]];
    }
    
    return info;
}

@end
