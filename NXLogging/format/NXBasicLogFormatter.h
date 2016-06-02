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
 A basic configurable log formatter.
 Serves as a basis for most log formatters.
 */
@interface NXBasicLogFormatter : NSObject <NXLogFormatter>

#pragma mark - Properties
/// @name Properties

/// The date formatter for the log. Default date format is "yyyy-MM-dd HH:mm:ss".
@property (atomic) NSDateFormatter *dateFormatter;

/// The bit mask representing the info to be excluded from the log message. Defaults to NXLogInfoNone.
@property (atomic) NXLogInfo hiddenInfo;

/// The minimum log level from which to include call stack symbols, when logging exceptions. Defaults to NXLogLevelError.
@property (atomic) NXLogLevel exceptionSymbolsThreshold;

#pragma mark - Static initializers
/// @name Static initializers

/**
 * Get the singleton instance.
 * @result The instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Other static methods
/// @name Class methods

/**
 * Get the name of a log level
 *
 * @param level The log level
 * @return The name of the log level
 */
+ (NSString *)levelName:(NXLogLevel)level;

#pragma mark - Method to test on hidden info
/// @name Test if info is hidden

/**
 * Determine if certain info is excluded from the log message
 *
 * @param info The flag to test if the according info is hidden
 * @return YES, if the info is excluded, NO otherwise.
 */
- (BOOL)isHiddenInfo:(NXLogInfo)info;

@end
