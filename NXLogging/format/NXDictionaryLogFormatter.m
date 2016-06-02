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

#import "NXDictionaryLogFormatter.h"
#import "NSException+NXLogging.h"

@implementation NXDictionaryLogFormatter

+ (instancetype)sharedInstance {
    NSAssert(self == NXDictionaryLogFormatter.class, @"A subclass of this singleton needs its own sharedInstance!");
    static id sharedInstance = nil;
    static dispatch_once_t initOnce;
    dispatch_once(&initOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [NSDateFormatter new]; // Beware: Only thread-safe from iOS 7 upwards
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    }
    return self;
}

- (NSDictionary *)messageForLogger:(NSString *)loggerName level:(NXLogLevel)level client:(NXLogClientInfo *)client error:(NSError *)error exception:(NSException *)exception format:(NSString *)format arguments:(va_list)arguments {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *levelName = [self.class levelName:level];
    NXLogInfo info = ~self.hiddenInfo;
    
    if (info & NXLogInfoLoggerName && loggerName.length)
        dict[@"loggerName"] = loggerName;
    if (info & NXLogInfoLevel && levelName.length)
        dict[@"logLevel"] = levelName;
    if (info & NXLogInfoMessage && format.length)
        dict[@"message"] = [[NSString alloc] initWithFormat:format arguments:arguments];
    if (info & NXLogInfoError && error)
        dict[@"error"] = [self _dictionaryFromError:error];
    if (info & NXLogInfoException && exception)
        dict[@"exception"] = [self _dictionaryFromException:exception];
    if (info & NXLogInfoFunction && client.function.length)
        dict[@"function"] = client.function;
    if (info & NXLogInfoFile && client.file.length)
        dict[@"file"] = client.file.lastPathComponent;
    if (info & NXLogInfoLine && client.line)
        dict[@"line"] = client.line;
    if (info & NXLogInfoModule && client.module.length)
        dict[@"module"] = client.module;
    if (info & NXLogInfoDate && client.date)
        dict[@"date"] = [self.dateFormatter stringFromDate:client.date];
    if (info & NXLogInfoProcessName && client.processName.length)
        dict[@"processName"] = client.processName;
    if (info & NXLogInfoProcessID && client.processID)
        dict[@"processID"] = client.processID;
    if (info & NXLogInfoDeviceName && client.deviceName.length)
        dict[@"deviceName"] = client.deviceName;
    if (info & NXLogInfoDeviceModel && client.deviceModel.length)
        dict[@"deviceModel"] = client.deviceModel;
    if (info & NXLogInfoSystemName && client.systemName.length)
        dict[@"systemName"] = client.systemName;
    if (info & NXLogInfoSystemVersion && client.systemVersion.length)
        dict[@"systemVersion"] = client.systemVersion;
    
    return dict;
}

#pragma mark - Private methods

- (NSDictionary *)_dictionaryFromError:(NSError *)error {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSString *desc = error.localizedDescription;
    NSString *reason = error.userInfo[NSLocalizedFailureReasonErrorKey];
    NSString *suggestion = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
    NSString *domain = error.domain;
    NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
    
    dict[@"code"] = [NSNumber numberWithInteger:error.code];
    if (domain.length)
        dict[@"domain"] = domain;
    if (desc.length)
        dict[@"description"] = desc;
    if (reason.length)
        dict[@"reason"] = reason;
    if (suggestion.length)
        dict[@"suggestion"] = suggestion;
    if (underlyingError)
        dict[@"underlyingError"] = [self _dictionaryFromError:underlyingError];
    
    return dict;
}

- (NSDictionary *)_dictionaryFromException:(NSException *)exception {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSString *name = exception.name;
    NSString *reason = exception.reason;
    NSException *cause = exception.cause;
    NSArray<NSString *> *stackSymbols = exception.callStackSymbols;
    
    if (name.length)
        dict[@"name"] = name;
    if (reason.length)
        dict[@"reason"] = reason;
    if (stackSymbols)
        dict[@"symbols"] = stackSymbols;
    if (cause)
        dict[@"cause"] = [self _dictionaryFromException:cause];
    
    return dict;
}

@end
