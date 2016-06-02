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

/// Information about the log client.
@interface NXLogClientInfo : NSObject

#pragma mark - Properties
/// @name Properties

/// The log caller's function name
@property (nonatomic, readonly) NSString *function;
/// The log caller's file path
@property (nonatomic, readonly) NSString *file;
/// The log caller's line number
@property (nonatomic, readonly) NSNumber *line;
/// The log caller's module
@property (nonatomic, readonly) NSString *module;
/// The log caller's process name
@property (nonatomic, readonly) NSString *processName;
/// The log caller's process ID
@property (nonatomic, readonly) NSNumber *processID;
/// The log caller's date
@property (nonatomic, readonly) NSDate *date;
/// The log caller's device
@property (nonatomic, readonly) NSString *deviceName;
/// The log caller's device model
@property (nonatomic, readonly) NSString *deviceModel;
/// The log caller's operating system
@property (nonatomic, readonly) NSString *systemName;
/// The log caller's operating system version
@property (nonatomic, readonly) NSString *systemVersion;

#pragma mark - Designated initializer
/// @name Designated initializer

/**
 * Create the log info from some basic info.
 *
 * @param info Some basic info on the log client. Normally NX_LOG_INFO would be passed,
 * or to be precise, a dictionary with the keys @(NXLogInfoFile), @(NXLogInfoFunction),
 * and @(NXLogInfoLine) and their corresponding values.
 */
- (instancetype)initWithSourceCodeInfo:(NSDictionary *)info NS_DESIGNATED_INITIALIZER;

#pragma mark - Public methods
///@name Other methods

/**
 * Replaces all variables in a string with their values
 * Variables are formed $(variable) where variable is one of this class' property names
 *
 * @param string The string to search
 * @return The resulting string
 */
- (NSString *)stringByReplacingVariablesInString:(NSString *)string;

#pragma mark - Unavailable methods

+ (id)new NS_UNAVAILABLE;
- (id)init NS_UNAVAILABLE;

@end
