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

#import "NSError+NXLogging.h"

@implementation NSError (NXLogging)

#pragma mark - Static initializers

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict {
    return [self errorWithDomain:[self applicationErrorDomain] code:code userInfo:dict];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description {
    return [self errorWithCode:code description:description reason:nil suggestion:nil underlyingError:nil];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description reason:(NSString *)reason {
    return [self errorWithCode:code description:description reason:reason suggestion:nil underlyingError:nil];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion {
    return [self errorWithCode:code description:description reason:nil suggestion:suggestion underlyingError:nil];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description underlyingError:(NSError *)error {
    return [self errorWithCode:code description:description reason:nil suggestion:nil underlyingError:error];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description reason:(NSString *)reason underlyingError:(NSError *)error {
    return [self errorWithCode:code description:description reason:nil suggestion:nil underlyingError:error];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion underlyingError:(NSError *)error {
    return [self errorWithCode:code description:description reason:nil suggestion:nil underlyingError:error];
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion underlyingError:(NSError *)error {
    return [self errorWithDomain:[self applicationErrorDomain] code:code description:description reason:reason suggestion:suggestion underlyingError:error];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description {
    return [self errorWithDomain:domain code:code description:description reason:nil suggestion:nil underlyingError:nil];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason {
    return [self errorWithDomain:domain code:code description:description reason:reason suggestion:nil underlyingError:nil];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion {
    return [self errorWithDomain:domain code:code description:description reason:nil suggestion:suggestion underlyingError:nil];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description underlyingError:(NSError *)error {
    return [self errorWithDomain:domain code:code description:description reason:nil suggestion:nil underlyingError:error];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason underlyingError:(NSError *)error {
    return [self errorWithDomain:domain code:code description:description reason:reason suggestion:nil underlyingError:error];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description suggestion:(NSString *)suggestion underlyingError:(NSError *)error {
    return [self errorWithDomain:domain code:code description:description reason:nil suggestion:suggestion underlyingError:error];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion underlyingError:(NSError *)error {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (description) {
        dict[NSLocalizedDescriptionKey] = description;
    }
    if (reason) {
        dict[NSLocalizedFailureReasonErrorKey] = reason;
    }
    if (suggestion) {
        dict[NSLocalizedRecoverySuggestionErrorKey] = suggestion;
    }
    if (error) {
        dict[NSUnderlyingErrorKey] = error;
    }
    
    return [self errorWithDomain:domain code:code userInfo:dict];
}

#pragma mark - Class methods

+ (NSString *)applicationErrorDomain {
    NSString *domain = [[NSBundle mainBundle].bundleIdentifier componentsSeparatedByString:@"."].lastObject;
    
    return [domain ? domain : @"Application" stringByAppendingString:@"ErrorDomain"];
}

#pragma mark - Overwritten getters and setters

- (NSString *)logTrace {
    return [@"Error: " stringByAppendingString:[self _trace]];
}

- (NSString *)logInfo {
    NSString *desc = self.userInfo[NSLocalizedDescriptionKey];
    NSString *reason = self.userInfo[NSLocalizedFailureReasonErrorKey];
    NSString *suggestion = self.userInfo[NSLocalizedRecoverySuggestionErrorKey];
    NSString *domain = self.domain;
    
    NSString *err = [NSString stringWithFormat:@"%@ (%@, error %ld)", desc ? desc : @"The operation couldn’t be completed.", domain ? domain : @"UnknownErrorDomain", (long)self.code];
    
    if (reason.length) {
        err = [err stringByAppendingFormat:@"\n   Reason: %@", reason];
    }
    
    if (suggestion.length) {
        err = [err stringByAppendingFormat:@"\n   Suggestion: %@", suggestion];
    }
    
    return err;
}

#pragma mark - Private methods

- (NSString *)_trace {
    NSString *info = self.logInfo;
    
    NSError *underlyingError = [self.userInfo objectForKey:NSUnderlyingErrorKey];
    
    if (underlyingError) {
        info = [info stringByAppendingFormat:@"\nCaused by: %@", [underlyingError _trace]];
    }
    
    return info;
}

@end
