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
#import "NXLogFormatter.h"

/**
 * The protocol describing a log target.
 * Custom log target classes must conform to this protocol.
 */
@protocol NXLogTarget <NSObject>

#pragma mark - Properties
/// @name Properties

/// The maximum level of log messages that will be logged
@property (atomic) NXLogLevel maxLogLevel;
/// The identifier of the formatter for the log messages
@property (atomic) id<NXLogFormatter> logFormatter;

#pragma mark - Method for logging to the target
/// @name Method for logging to the target

/**
 * Log a message with a log level.
 *
 * @param level (input) The log level
 * @param message (input) The log message
 * @discussion If you create your own log target this method must be implemented thread-safe and write the log message atomically. So, basically, do not modify any variables outside the scope of this function, and if, e.g. you are using printf to write your message, then make one call to printf and not several. As a side note: In a POSIX system, printf is likely re-entrant but thread-safe and writes atomically due to the usage of flockfile/funlockfile, which can be seen as some sort of mutex associated with the file handle. So, while using printf or a function behaving similarly, serves our purpose, it can very well present a severe bottleneck to the logging system.
 */
- (void)log:(NXLogLevel)level message:(id)message;

#pragma mark - Unavailable methods

+ (id)new NS_UNAVAILABLE;
- (id)init NS_UNAVAILABLE;

@end
