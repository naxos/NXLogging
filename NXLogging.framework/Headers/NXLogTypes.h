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

#ifndef NXLogTypes_h
#define NXLogTypes_h

@protocol __NXLogTypesHolder // Just because AppleDoc gets confused if the enums are not encapsulated

typedef struct _NXColor {
    UInt8 r;
    UInt8 g;
    UInt8 b;
} NXColor;

/// Describes the level of a log message
typedef NS_ENUM(NSInteger, NXLogLevel) {
    /// Use for maxLogLevel to switch off logging altogether
    NXLogLevelNone = NSIntegerMin,
    /// After such an error the application is probably unusable
    NXLogLevelEmergency = -5,
    /// A serious failure in a key component bla
    NXLogLevelAlert = -4,
    /// A failure in a key component
    NXLogLevelCritical = -3,
    /// Something has failed
    NXLogLevelError = -2,
    /// Something might fail
    NXLogLevelWarning = -1,
    /// Something of moderate interest to the user or administrator
    NXLogLevelNotice = 0,
    /// Information for the developer (does not normally log)
    NXLogLevelInfo = 1,
    /// Only of interest to the developer in special cases (does not normally log)
    NXLogLevelDebug = 2,
    /// Use for maxLogLevel to log messages of any level
    NXLogLevelAny = NSIntegerMax,
};

/// Flag representing log information
typedef NS_OPTIONS(NSUInteger, NXLogInfo) {
    /// The function name
    NXLogInfoFunction = 1 << 0,
    /// The file name
    NXLogInfoFile = 1 << 1,
    /// The line number
    NXLogInfoLine = 1 << 2,
    /// The module
    NXLogInfoModule = 1 << 3,
    /// The process name
    NXLogInfoProcessName = 1 << 4,
    /// The process id
    NXLogInfoProcessID = 1 << 5,
    /// The date
    NXLogInfoDate = 1 << 6,
    /// The device name
    NXLogInfoDeviceName = 1 << 7,
    /** The device model
     i386      -> 32-bit Simulator
     x86_64    -> 64-bit Simulator
     iPod1,1   -> iPod Touch
     iPod2,1   -> iPod Touch Second Generation
     iPod3,1   -> iPod Touch Third Generation
     iPod4,1   -> iPod Touch Fourth Generation
     iPod7,1   -> iPod Touch 6th Generation
     iPhone1,1 -> iPhone
     iPhone1,2 -> iPhone 3G
     iPhone2,1 -> iPhone 3GS
     iPad1,1   -> iPad
     iPad2,1   -> iPad 2
     iPad3,1   -> 3rd Generation iPad
     iPhone3,1 -> iPhone 4 (GSM)
     iPhone3,3 -> iPhone 4 (CDMA/Verizon/Sprint)
     iPhone4,1 -> iPhone 4S
     iPhone5,1 -> iPhone 5 (model A1428, AT&T/Canada)
     iPhone5,2 -> iPhone 5 (model A1429, everything else)
     iPad3,4   -> 4th Generation iPad
     iPad2,5   -> iPad Mini
     iPhone5,3 -> iPhone 5c (model A1456, A1532 | GSM)
     iPhone5,4 -> iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
     iPhone6,1 -> iPhone 5s (model A1433, A1533 | GSM)
     iPhone6,2 -> iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
     iPad4,1   -> 5th Generation iPad (iPad Air) - Wifi
     iPad4,2   -> 5th Generation iPad (iPad Air) - Cellular
     iPad4,4   -> 2nd Generation iPad Mini - Wifi
     iPad4,5   -> 2nd Generation iPad Mini - Cellular
     iPad4,7   -> 3rd Generation iPad Mini - Wifi (model A1599)
     iPad4,8   -> 3rd Generation iPad Mini - Cellular
     iPad4,9   -> 3rd Generation iPad Mini (China)
     iPad5,3   -> 6th Generation iPad (iPad Air 2) - Wifi
     iPad5,4   -> 6th Generation iPad (iPad Air 2) - Cellular
     iPhone7,1 -> iPhone 6 Plus
     iPhone7,2 -> iPhone 6
     iPhone8,1 -> iPhone 6S
     iPhone8,2 -> iPhone 6S Plus
     */
    NXLogInfoDeviceModel = 1 << 8,
    /// The operating system
    NXLogInfoSystemName = 1 << 9,
    /// The operating system version
    NXLogInfoSystemVersion = 1 << 10,
    /// The name of the logger
    NXLogInfoLoggerName = 1 << 11,
    /// The log level
    NXLogInfoLevel = 1 << 12,
    /// The log message
    NXLogInfoMessage = 1 << 13,
    /// The log error
    NXLogInfoError = 1 << 14,
    /// The log excpetion
    NXLogInfoException = 1 << 15,

    // Predefined combinations
    
    /// Mask for no info
    NXLogInfoNone = 0,
    /// Mask for info about the caller's source code
    NXLogInfoSourceCode = (NXLogInfoFunction | NXLogInfoFile | NXLogInfoLine),
    /// Mask for info about the client's hardware
    NXLogInfoDevice = (NXLogInfoDeviceName | NXLogInfoDeviceModel),
    /// Mask for info about the client's process
    NXLogInfoProcess = (NXLogInfoProcessName | NXLogInfoProcessID),
    /// Mask for info about the client's operating system
    NXLogInfoSystem = (NXLogInfoSystemName | NXLogInfoSystemVersion),
    /// Mask for the actual content
    NXLogInfoContent = (NXLogInfoMessage | NXLogInfoError | NXLogInfoException),
    /// Mask for all info
    NXLogInfoAll = ~NXLogInfoNone
};

@end

#endif /* NXLogTypes_h */
