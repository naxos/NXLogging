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

/**
 * The default log target for every logger. Since every
 * logger created withe one of the static initializers of the
 * logger class uses the same instance of NXSystemLogTarget,
 * you can adjust the level of log output of your application
 * with [NXSystemLogTarget sharedInstance].maxLogLevel.
 * This log target uses the Apple System Log (asl)
 * for logging.
 */
@interface NXSystemLogTarget : NSObject <NXLogTarget>

#pragma mark - Static singleton initializer
/// @name Static initializers

/**
 * Get the singleton instance of the system log target initialized
 * with the singleton instance of the NXSystemLogFormatter.
 * @result The instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Designated initializer
/// @name Designated initializer

/**
 * The designated initializer
 *
 * @param formatter The log formatter
 */
- (instancetype)initWithFormatter:(id<NXLogFormatter>)formatter NS_DESIGNATED_INITIALIZER;

#pragma mark - Unavailable methods

+ (id)new NS_UNAVAILABLE;
- (id)init NS_UNAVAILABLE;

@end
