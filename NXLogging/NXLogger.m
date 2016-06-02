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

#import "NXLogger.h"
#import "NXSystemLogTarget.h"
#import "NXConsoleLogTarget.h"
#import "NSError+NXLogging.h"
#import "NXLogRegistry.h"

@implementation NXLogger {
    NSMutableArray<id<NXLogTarget>> *_targets;
}

#pragma mark - Static initializers

+ (instancetype)applicationLogger {
    return [self loggerNamed:[NSBundle mainBundle].bundleIdentifier];
}

+ (instancetype)loggerNamed:(NSString *)name {
    NXLogRegistry *registry = [NXLogRegistry sharedInstance];
    
    // Try to get the logger from the registry
    
    NXLogger *logger = [registry loggerNamed:name];
    
    // If there is no logger of the given name yet, ...
    
    if (logger == nil) {
        
        // ... init the logger with the name and the default log target, ...
        
        logger = [[self alloc] initWithName:name target:[NXSystemLogTarget sharedInstance]];
        
        if (logger) {
            
            // ... add the debug log target as well, ...
            
            [logger addLogTarget:[NXConsoleLogTarget sharedInstance]];
            
            // ... and register the logger
            
            [registry registerLogger:logger];
        }
    }
    
    return logger;
}

#pragma mark - Other static methods

+ (void)registerLogger:(NXLogger *)logger {
    [[NXLogRegistry sharedInstance] registerLogger:logger];
}

#pragma mark - Designated initializer

- (instancetype)initWithName:(NSString *)name target:(id<NXLogTarget>)target {
    
    self = [super init];
    if (self) {
        _name = name;
        _targets = [NSMutableArray arrayWithObject:target];
    }
    return self;
}

#pragma mark - Public API

- (void)addLogTarget:(id<NXLogTarget>)target {
    @synchronized(_targets) {
        if (![_targets containsObject:target]) {
            [_targets addObject:target];
        }
    }
}

- (void)removeLogTarget:(id<NXLogTarget>)target {
    @synchronized(_targets) {
        [_targets removeObject:target];
    }
}

- (void)log:(NXLogLevel)level info:(NSDictionary *)logInfo format:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    
    [self log:level info:logInfo error:nil exception:nil format:format arguments:args];
    
    va_end(args);
}

- (void)log:(NXLogLevel)level info:(NSDictionary *)logInfo error:(NSError *)error format:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    
    [self log:level info:logInfo error:error exception:nil format:format arguments:args];
    
    va_end(args);
}

- (void)log:(NXLogLevel)level info:(NSDictionary *)logInfo error:(NSError *)error {
    
    [self log:level info:logInfo error:error exception:nil format:nil arguments:nil];
}

- (void)log:(NXLogLevel)level info:(NSDictionary *)logInfo exception:(NSException *)exception format:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    
    [self log:level info:logInfo error:nil exception:exception format:format arguments:args];
    
    va_end(args);
}

- (void)log:(NXLogLevel)level info:(NSDictionary *)logInfo exception:(NSException *)exception {
    
    [self log:level info:logInfo error:nil exception:exception format:nil arguments:nil];
}

- (void)log:(NXLogLevel)level info:(NSDictionary *)info error:(NSError *)error exception:(NSException *)exception format:(NSString *)format arguments:(va_list)arguments {
    
    NSArray *targets;
    
    @synchronized(_targets) {
        targets = [NSArray arrayWithArray:_targets];
    }
    
    NSMutableDictionary *messageCache = targets.count > 1 ? [NSMutableDictionary new] : nil;
    NXLogClientInfo *client = nil;
    
    // Log to each target ...
    
    for (id<NXLogTarget> target in targets) {
        
        // ... but only if the log level does not exceed the target's max log level
        
        if (level <= target.maxLogLevel) {
            
            // Try to get the message from the cache
            
            NSString *formatKey = [NSString stringWithFormat:@"%p", target.logFormatter]; // identity
            id message = messageCache[formatKey];
            
            // If we dont have the message yet ...
            
            if (message == nil) {
                
                // ... construct it by creating log client info (if not yet done), ...
                
                if (client == nil) {
                    // Add some more info
                    client = [[NXLogClientInfo alloc] initWithSourceCodeInfo:info];
                }

                // ... copying the variable argument list (because traversing it is destructive), ...
                
                va_list args;
                if (arguments) {
                    va_copy(args, arguments);
                }
                
                // ... and formatting the message
                
                message = [target.logFormatter messageForLogger:self.name level:level client:client error:error exception:exception format:format arguments:args];
                
                // Cache the message for potential reuse

                messageCache[formatKey] = message;
            }
            
            // Log the message to the target
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [target log:level message:message];
            });
        }
    }
}

@end
