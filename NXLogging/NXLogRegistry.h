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

#import <Foundation/Foundation.h>
#import "NXLogger.h"

/**
 * A singelton for registration of loggers.
 * Every logger created with the static initializers of the NXLogger
 * class will be looked-up or registered with this registry.
 * You don't really need to use this class directly, unless you
 * create a logger with its non-static initializer and want to
 * reuse it at a later time.
 */
@interface NXLogRegistry : NSObject

#pragma mark - Static singleton initializer

/**
 * Get the instance of this singleton.
 *
 * @result The instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Methods to manage loggers

/**
 * Retrieve a logger registered under the given name
 *
 * @param name (input) The name of the logger
 * @result The logger or nil if no logger with the given name was registered
 */
- (NXLogger *)loggerNamed:(NSString *)name;

/**
 * Register a logger for later usage. The logger will be registered under
 * its name property. A logger registered under the same name will be
 * overwritten
 *
 * @param logger (input) The logger to register
 */
- (void)registerLogger:(NXLogger *)logger;

#pragma mark - Unavailable methods

+ (id)new NS_UNAVAILABLE;
- (id)init NS_UNAVAILABLE;

@end
