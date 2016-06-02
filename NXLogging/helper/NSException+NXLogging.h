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

/**
 * A category of NSException which provides some methods
 * to retrieve info for log output and comes with a set
 * of convenience initializers.
 */
@interface NSException (NXLogging)

/// @name Properties

/**
 * The underlying exception or nil.
 */
@property (nonatomic) NSException *cause;

/**
 * Get a string representing this exception and underlying exceptions.
 * The exceptions will be separated by a new line character.
 */
@property (nonatomic, readonly) NSString *logTrace;

/**
 * Get a simple description on this exception consisting of its
 * name and reason
 */
@property (nonatomic, readonly) NSString *logInfo;

/// @name Class methods

/**
 * Executes a code block and catches any exception
 *
 * @param tryBlock The block to execute
 * @return The exception caught or nil if no exception occurred
 */
+ (NSException *)probe:(void(^)())tryBlock;

/**
 * Creates and raises an exception with the specified name.
 *
 * @param name The name of the exception.
 */
+ (void)raise:(NSString *)name;

/**
 * Creates and raises an exception with the specified name, cause, and message.
 *
 * @param name The name of the exception.
 * @param cause An underlying exception.
 * @param format A human-readable message string (that is, the exception reason) with conversion specifications for the variable arguments that follow.
 * @param ... Variable information to be inserted into the formatted exception reason (in the manner of printf).
 */
+ (void)raise:(NSString *)name cause:(NSException *)cause format:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);

/**
 * Creates and raises an exception with the specified name, cause, format, and arguments.
 *
 * @param name The name of the exception.
 * @param cause An underlying exception.
 * @param format A human-readable message string (that is, the exception reason) with conversion specifications for the variable arguments in argList.
 * @param argList Variable information to be inserted into the formatted exception reason (in the manner of vprintf).
 */
+ (void)raise:(NSString *)name cause:(NSException *)cause format:(NSString *)format arguments:(va_list)argList;

/// @name Static initializers

/**
 * Creates and returns an exception object.
 *
 * @param name The name of the exception.
 * @param reason A human-readable message string summarizing the reason for the exception.
 * @param cause An underlying exception.
 * @param userInfo A dictionary containing user-defined information relating to the exception
 * @return The created NSException object or nil if the object couldn't be created.
 */
+ (NSException *)exceptionWithName:(NSString *)name cause:(NSException *)cause reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;

/// @name Convenience initializers

/**
 * Initializes and returns a newly allocated exception object.
 *
 * @param name The name of the exception.
 * @param reason A human-readable message string summarizing the reason for the exception.
 * @param cause An underlying exception.
 * @param userInfo A dictionary containing user-defined information relating to the exception
 * @return The created NSException object or nil if the object couldn't be created.
 */
- (instancetype)initWithName:(NSString *)name cause:(NSException *)cause reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;

/// @name Public methods

/**
 * Get a string representing this exception and underlying exceptions.
 * The exceptions will be separated by a new line character.
 *
 * @param includeSymbols Include the stack trace if set to YES
 */
- (NSString *)logTrace:(BOOL)includeSymbols;

/**
 * Get a simple description on this exception consisting of its
 * name and reason
 *
 * @param includeSymbols Include the stack trace if set to YES
 */
- (NSString *)logInfo:(BOOL)includeSymbols;

@end
