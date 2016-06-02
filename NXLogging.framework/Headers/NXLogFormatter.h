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
#import "NXLogClientInfo.h"
#import "NXLogTypes.h"

/**
 * Protocol describing a formatter for log messages.
 * Custom formatter classes must conform to this protocol.
 */
@protocol NXLogFormatter <NSObject>

/// @name Format the log message

/**
 * Creates a formatted message including several parameters
 *
 * @param loggerName The name of the logger for the message (must not be nil)
 * @param level The log level
 * @param client Some info about the log client.
 * @param error An error or nil
 * @param format The message format as in -[NSString initWithFormat:arguments:]. May be nil.
 * @param arguments Arguments to substitute into format or nil. Not taken into account if format is nil.
 * @return The formatted message (which may or may not be a string)
 * @discussion This method should be implemented in a thread-safe way
 */
- (id)messageForLogger:(NSString *)loggerName level:(NXLogLevel)level client:(NXLogClientInfo *)client error:(NSError *)error exception:(NSException *)exception format:(NSString *)format arguments:(va_list)arguments;

@end
