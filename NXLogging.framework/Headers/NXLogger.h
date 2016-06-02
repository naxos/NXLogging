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
#import "NXLogTarget.h"
#import "NXLogTypes.h"

#pragma mark NSLog-style convenience macros for logging

/**
 * @definedblock Log macros
 * @abstract NSLog-like logging macros
 * @define NXLog Log a formatted message with the given log level using the application logger
 * @define NXLogError Log an error and a formatted message with the given log level using the application logger
 * @define NXLogException Log an exception and a formatted message with the given log level using the application logger
 * @define NXLogTo Log a formatted message with the given log level using the given logger
 * @define NXLogErrorTo Log an error and a formatted message with the given log level using the given logger
 * @define NXLogExceptionTo Log an error and a formatted message with the given log level using the given logger
 */
#define NXLog(level, ...) [[NXLogger applicationLogger] log:level info:NX_LOG_INFO format:__VA_ARGS__]
#define NXLogError(level, err, ...) [[NXLogger applicationLogger] log:level info:NX_LOG_INFO error:err format:__VA_ARGS__]
#define NXLogException(level, exc, ...) [[NXLogger applicationLogger] log:level info:NX_LOG_INFO exception:exc format:__VA_ARGS__]
#define NXLogTo(logger, level, ...) [[NXLogger loggerNamed:logger] log:level info:NX_LOG_INFO format:__VA_ARGS__]
#define NXLogErrorTo(logger, level, err, ...) [[NXLogger loggerNamed:logger] log:level info:NX_LOG_INFO error:err format:__VA_ARGS__]
#define NXLogExceptionTo(logger, level, exc, ...) [[NXLogger loggerNamed:logger] log:level info:NX_LOG_INFO exception:exc format:__VA_ARGS__]
/** @/definedblock */

#pragma mark - Basic dictionary with info about the log client

/**
 * @definedblock Log info
 * @abstract Use to capture info from the client
 * @define NX_LOG_INFO Info dictionary containing the log client's function, file and line number
 */
#define NX_LOG_INFO @{ @(NXLogInfoFunction) : @(__FUNCTION__), @(NXLogInfoFile) : @(__FILE__), @(NXLogInfoLine) : @(__LINE__) }
/** @/definedblock */

#pragma mark -

/** 
 * A logger can be used to log messages at a certain log level to log targets.
 * Normally you would use one of the static initializers to create a new logger
 * or to get the instance of a formerly created logger.
 */
@interface NXLogger : NSObject

#pragma mark - Properties
/// @name Properties

/**
 * The log targets of the logger. If a logger was freshly created by
 * one of the static initializers, this array will contain the singleton
 * instances of NXSystemLogTarget and NXConsoleLogTarget.
 */
@property (nonatomic, readonly) NSArray<id<NXLogTarget>> *targets;

/// The name of the logger
@property (nonatomic, readonly) NSString *name;

#pragma mark - Static initializers
/// @name Static initializers

/**
 * Looks up the logger with the bundleIdentifier of your app as a name.
 * Creates and registers the logger if it does not yet exist. By default the logger
 * will log to the singleton instances of NXSystemLogTarget and NXConsoleLogTarget.
 *
 * @result The logger instance
 */
+ (instancetype)applicationLogger;

/**
 * Looks up the logger with the given name.
 * Creates and registers the logger if it does not yet exist. By default the logger
 * will log to the singleton instances of NXSystemLogTarget and NXConsoleLogTarget.
 *
 * @param name (input) The name of the logger
 * @result The logger instance
 */
+ (instancetype)loggerNamed:(NSString *)name;

#pragma mark - Registration of a custom logger
/// @name Registration of a custom logger

/**
 * Register a logger for later usage. The logger will be registered under
 * its name property. A logger registered under the same name will be
 * overwritten. If the logger was created by one of the static initializers
 * the logger will already be registered.
 *
 * @param logger (input) The logger to register
 */
+ (void)registerLogger:(NXLogger *)logger;

#pragma mark - Designated initializer
/// @name Designated initializer

/**
 * Creates a custom logger with a name and a log target.
 * If at a later point, you want to look up this logger with the
 * static loggerNamed method, you need to register the logger
 * instance with the NXLogRegistry.
 *
 * @param name (input) The name for the logger
 * @param target (input) The initial log target for the logger
 * @result The logger instance
 */
- (instancetype)initWithName:(NSString *)name target:(id<NXLogTarget>)target NS_DESIGNATED_INITIALIZER;

#pragma mark - Methods to manage log targets
/// @name Methods to manage log targets

/**
 * Adds a target to the logger. Each log target will be
 * logged to individually according to its maxLogLevel property.
 *
 * @param target (input) The log target to be added to the logger
 */
- (void)addLogTarget:(id<NXLogTarget>)target;

/**
 * Remove a target from the logger.
 *
 * @param target (input) The log target to be removed from the logger
 */
- (void)removeLogTarget:(id<NXLogTarget>)target;

#pragma mark - Methods for logging
/// @name Methods for logging

/**
 * Log a message and info with the given log level to the logger's targets
 *
 * @param level (input) The log level
 * @param info (input) An info dictionary. Use the macro NX_LOG_INFO or pass a dictionary with values for the keys @(NXLogInfoFile), @(NXLogInfoFunction), and @(NXLogInfoLine).
 * @param format (input) The message format (can be nil). See +[NSString stringWithFormat:] for more info.
 * @param ... A comma-separated list of arguments to substitute into format.
 */
- (void)log:(NXLogLevel)level info:(NSDictionary *)info format:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);

/**
 * Log info and an error with the given log level to the logger's targets
 *
 * @param level (input) The log level
 * @param info (input) An info dictionary. Use the macro NX_LOG_INFO or pass a dictionary with values for the keys @(NXLogInfoFile), @(NXLogInfoFunction), and @(NXLogInfoLine).
 * @param error (input) The error whose trace (see NSError+NXLogging) will be logged.
 */
- (void)log:(NXLogLevel)level info:(NSDictionary *)info error:(NSError *)error;

/**
 * Log info, a message and an error with the given log level to the logger's targets
 *
 * @param level (input) The log level
 * @param info (input) An info dictionary. Use the macro NX_LOG_INFO or pass a dictionary with values for the keys @(NXLogInfoFile), @(NXLogInfoFunction), and @(NXLogInfoLine).
 * @param error (input) The error whose trace will be logged.
 * @param format (input) The message format (can be nil). See +[NSString stringWithFormat:] for more info.
 * @param ... A comma-separated list of arguments to substitute into format.
 */
- (void)log:(NXLogLevel)level info:(NSDictionary *)info error:(NSError *)error format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

/**
 * Log info and an error with the given log level to the logger's targets
 *
 * @param level (input) The log level
 * @param info (input) An info dictionary. Use the macro NX_LOG_INFO or pass a dictionary with values for the keys @(NXLogInfoFile), @(NXLogInfoFunction), and @(NXLogInfoLine).
 * @param exception (input) The exception whose trace (see NSException+NXLogging) will be logged.
 */
- (void)log:(NXLogLevel)level info:(NSDictionary *)info exception:(NSException *)exception;

/**
 * Log info, a message and an error with the given log level to the logger's targets
 *
 * @param level (input) The log level
 * @param info (input) An info dictionary. Use the macro NX_LOG_INFO or pass a dictionary with values for the keys @(NXLogInfoFile), @(NXLogInfoFunction), and @(NXLogInfoLine).
 * @param exception (input) The exception whose trace (see NSException+NXLogging) will be logged.
 * @param format (input) The message format (can be nil). See +[NSString stringWithFormat:] for more info.
 * @param ... A comma-separated list of arguments to substitute into format.
 */
- (void)log:(NXLogLevel)level info:(NSDictionary *)info exception:(NSException *)exception format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

/**
 * Log info, a message and an error with the given log level to the logger's targets
 *
 * @param level (input) The log level
 * @param info (input) An info dictionary. Use the macro NX_LOG_INFO or pass a dictionary with values for the keys @(NXLogInfoFile), @(NXLogInfoFunction), and @(NXLogInfoLine).
 * @param error (input) The error whose trace will be logged.
 * @param exception (input) The exception whose trace will be logged.
 * @param format (input) The message format (can be nil). See -[NSString initWithFormat:arguments:] for more info.
 * @param arguments A list of arguments to substitute into format.
 */
- (void)log:(NXLogLevel)level info:(NSDictionary *)info error:(NSError *)error exception:(NSException *)exception format:(NSString *)format arguments:(va_list)arguments;

#pragma mark - Unavailable methods

+ (id)new NS_UNAVAILABLE;
- (id)init NS_UNAVAILABLE;

@end
