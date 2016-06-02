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

/// Project version number for NXLogging.
FOUNDATION_EXPORT double NXLoggingVersionNumber;

/// Project version string for NXLogging.
FOUNDATION_EXPORT const unsigned char NXLoggingVersionString[];

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
#   error The Logging framework requires iOS 8.0 or higher. Please adjust your deployment target.
#endif

// If you want to replace NSLog, you can use the following macro:
// #define NSLog(...) NXLog(NXLogLevelNotice, __VA_ARGS__)

#import <NXLogging/NXLogger.h>
#import <NXLogging/NXLogTypes.h>
#import <NXLogging/NXSystemLogTarget.h>
#import <NXLogging/NXConsoleLogTarget.h>
#import <NXLogging/NXFileLogTarget.h>
#import <NXLogging/NXSystemLogFormatter.h>
#import <NXLogging/NXDebugLogFormatter.h>
#import <NXLogging/NXJSONLogFormatter.h>
#import <NXLogging/NSError+NXLogging.h>
#import <NXLogging/NSException+NXLogging.h>
