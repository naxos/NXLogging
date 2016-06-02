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

#import "NXBasicLogFormatter.h"
#import "NSError+NXLogging.h"
#import "NSException+NXLogging.h"

@implementation NXBasicLogFormatter

+ (instancetype)sharedInstance {
    NSAssert(self == NXBasicLogFormatter.class, @"A subclass of this singleton needs its own sharedInstance!");
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
        _dateFormatter = [NSDateFormatter new]; // Beware: Only thread-safe from iOS 7 upwards
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _exceptionSymbolsThreshold = NXLogLevelError;
    }
    return self;
}

#pragma mark - Public API

- (NSString *)messageForLogger:(NSString *)loggerName level:(NXLogLevel)level client:(NXLogClientInfo *)client error:(NSError *)error exception:(NSException *)exception format:(NSString *)format arguments:(va_list)arguments {
    
    NSMutableString *message = [NSMutableString new];
    NSString *info = [self _logInfoString:loggerName level:level client:client];
    NSString *msg = nil;
    NSError *err = [self isHiddenInfo:NXLogInfoError] ? nil : error;
    NSException *exc = [self isHiddenInfo:NXLogInfoException] ? nil : exception;
    
    if (![self isHiddenInfo:NXLogInfoMessage] && format.length) {
        msg = [[NSString alloc] initWithFormat:format arguments:arguments];
        if (msg.length && info.length) {
            info = [info stringByAppendingString:@" - "];
        }
    }

    if (info.length) {
        [message appendString:info];
    }
    if (msg.length) {
        [message appendString:msg];
    }
    if (err) {
        if (message.length) {
            [message appendString:@"\n"];
        }
        [message appendString:err.logTrace];
    }
    if (exc) {
        if (message.length) {
            [message appendString:@"\n"];
        }
        BOOL includeSymbols = level <= _exceptionSymbolsThreshold;
        [message appendString:[exc logTrace:includeSymbols]];
        if (!includeSymbols) {
            if (_exceptionSymbolsThreshold == NXLogLevelNone) {
                [message appendFormat:@"\n   >> Enable call stack symbols with the exceptionSymbolsThreshold property of the log formatter <<"];
            } else {
                [message appendFormat:@"\n   >> Log with severity %@ or higher to enable call stack symbols <<", [self.class levelName:_exceptionSymbolsThreshold]];
            }
        }
    }
    
    return [client stringByReplacingVariablesInString:message];
}

- (BOOL)isHiddenInfo:(NXLogInfo)info {
    return _hiddenInfo & info;
}

+ (NSString *)levelName:(NXLogLevel)level {
    switch (level) {
        case NXLogLevelEmergency:
            return @"Emergency";
        case NXLogLevelAlert:
            return @"Alert";
        case NXLogLevelCritical:
            return @"Critical";
        case NXLogLevelError:
            return @"Error";
        case NXLogLevelWarning:
            return @"Warning";
        case NXLogLevelNotice:
            return @"Notice";
        case NXLogLevelInfo:
            return @"Info";
        case NXLogLevelDebug:
            return @"Debug";
        default:
            return nil;
    }
}

#pragma mark - Private methods

// 1st part:
// 2016-02-22 17:27:33 Naxos iPad #7(iPad4,2 iPhone OS 9.2.1) AirIDSample[4783] <Notice>:
// date       time     device        model   system    sver   process     pid    level

// 2nd part:
// com.naxos-software.AirIDSample [StartPageControl didEnterPage:ofDocument:](StartPageControl.m:49)
// name                           function                                    file               line

- (NSString *)_logInfoString:(NSString *)loggerName level:(NXLogLevel)level client:(NXLogClientInfo *)client {
    NSMutableString *infoString = [NSMutableString new];
    
    if (client) {
        NXLogInfo info = ~self.hiddenInfo;
        
        NSString *name = info & NXLogInfoLoggerName && loggerName.length ? loggerName : nil;
        NSString *levelName = info & NXLogInfoLevel ? [self.class levelName:level] : nil;
        NSDate *date = info & NXLogInfoDate && client.date ? client.date : nil;
        NSString *device = info & NXLogInfoDeviceName && client.deviceName.length ? client.deviceName : nil;
        NSString *model = info & NXLogInfoDeviceModel && client.deviceModel.length ? client.deviceModel : nil;
        NSString *system = info & NXLogInfoSystemName && client.systemName.length ? client.systemName : nil;
        NSString *systemVersion = info & NXLogInfoSystemVersion && client.systemVersion.length ? client.systemVersion : nil;
        NSString *process = info & NXLogInfoProcessName && client.processName.length ? client.processName : nil;
        NSNumber *pid = info & NXLogInfoProcessID && client.processID ? client.processID : nil;
        NSString *function = info & NXLogInfoFunction && client.function.length ? client.function : nil;
        NSString *file = info & NXLogInfoFile && client.file.length ? client.file : nil;
        NSNumber *line = info & NXLogInfoLine && client.line ? client.line : nil;
        NSString *module = info & NXLogInfoModule && client.module.length ? client.module : nil;
        
        // 1st part
        
        if (date) {
            NSString *d = [self.dateFormatter stringFromDate:date];
            [infoString appendString:d];
        }
        
        if (device) {
            if (infoString.length) {
                [infoString appendString:@" "];
            }
            [infoString appendFormat:@"%@", device];
        }

        if (model || system) {
            if (device) {
                [infoString appendString:@"("];
            } else if (infoString.length) {
                [infoString appendString:@" "];
            }
            if (model) {
                [infoString appendString:model];
            }
            if (system) {
                if (model) {
                    [infoString appendString:@" "];
                }
                [infoString appendString:system];
                if (systemVersion) {
                    [infoString appendString:@" "];
                    [infoString appendString:systemVersion];
                }
            }
            if (device) {
                [infoString appendString:@")"];
            }
        }
        
        if (process) {
            if (infoString.length) {
                [infoString appendString:@" "];
            }
            [infoString appendFormat:@"%@", process];
            if (pid) {
                [infoString appendFormat:@"[%@]", pid];
            }
        }
                
        if (levelName) {
            if (infoString.length) {
                [infoString appendString:@" "];
            }
            [infoString appendFormat:@"<%@>", levelName];
        }

        // 2nd part

        NSMutableString *infoString2 = [NSMutableString new];
        
        if (name) {
            [infoString2 appendString:loggerName];
        }
        
        if (module) {
            if (name) {
                [infoString2 appendString:@"["];
            }
            [infoString2 appendString:module];
            if (name) {
                [infoString2 appendString:@"]"];
            }
        }
        
        if (function) {
            if (infoString2.length) {
                [infoString2 appendString:@" "];
            }
            NSArray *comps = [function componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
            
            if (comps.count >= 2) {
                function = [NSString stringWithFormat:@"[%@]", [comps objectAtIndex:1]];
            }
            
            [infoString2 appendFormat:@"%@", function];
        }
        
        if (file) {
            if (function || name) {
                [infoString2 appendString:@"("];
            } else if (infoString2.length) {
                [infoString2 appendString:@" "];
            }

            [infoString2 appendString:file.lastPathComponent];
            if (line) {
                [infoString2 appendFormat:@":%@", line];
            }
            if (function || name) {
                [infoString2 appendString:@")"];
            }
        }
        
        // Concatenate 1st and 2nd part
        
        if (infoString.length && infoString2.length) {
            [infoString appendString:@": "];
        }

        [infoString appendString:infoString2];
    }
    
    return infoString;
}

@end
