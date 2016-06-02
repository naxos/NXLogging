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

import Foundation

public extension NXLogger {

    // MARK: - Static convenience methods to log to a named logger
    
    /**
     * Log info (function/file/line), a message and an error or exception with the given log level
     * to a named logger or the application logger if the logger parameter is nil or omitted
     *
     * @param level The log level. If NXLogLevel.Any or omitted an appropriate log level will be chosen.
     * @param logger The name of the loggger. If nil or omitted, the application logger will be used.
     * @param error The error whose trace will be logged.
     * @param exception The exception whose trace will be logged.
     * @param message The message format. See +[NSString stringWithFormat:] for more info.
     * @param arguments A comma-separated list of arguments to substitute into format.
     * @param function The logging function name (Usually omitted).
     * @param file The logging file (Usually omitted).
     * @param line The logging line number (Usually omitted).
     */
    @nonobjc public class func log(level : NXLogLevel = NXLogLevel.Any, logger: String? = nil, error: ErrorType? = nil, exception: NSException? = nil, format: String? = nil, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
        
        let level = NXLogger.levelFor(level, format: format, error : error, exception : exception)
        let logger = logger == nil ? NXLogger.applicationLogger() : NXLogger(named: logger)
        var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]

        if module != nil {
            info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
        }
        
        withVaList(arguments) {
            logger.log(level, info: info, error: error == nil ? nil : NSError(error!), exception: exception, format: format, arguments: $0)
        }
    }
    
    // MARK: - Methods for logging
    
    /**
     * Log info (function/file/line), a message and an error or exception with the given log level
     *
     * @param level The log level. If NXLogLevel.Any or omitted an appropriate log level will be chosen.
     * @param error The error whose trace will be logged.
     * @param exception The exception whose trace will be logged.
     * @param message The message format. See +[NSString stringWithFormat:] for more info.
     * @param arguments A comma-separated list of arguments to substitute into format.
     * @param function The logging function name (Usually omitted).
     * @param file The logging file (Usually omitted).
     * @param line The logging line number (Usually omitted).
     */
    @nonobjc public func log(level : NXLogLevel = NXLogLevel.Any, error: ErrorType? = nil, exception: NSException? = nil, format: String? = nil, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
        
        let level = NXLogger.levelFor(level, format: format, error : error, exception : exception)
        var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
        
        if module != nil {
            info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
        }

        withVaList(arguments) {
            log(level, info: info, error: error == nil ? nil : NSError(error!), exception: exception, format: format, arguments: $0)
        }
    }
    
    // MARK: - Private methods
    
    @nonobjc public class func levelFor(level : NXLogLevel, format: String?, error: ErrorType?, exception: NSException?) -> NXLogLevel {
        if level == .Any {
            if exception != nil {
                return .Alert
            }
            if error != nil {
                return .Error
            }
            if format != nil {
                return .Notice
            }
            return .Debug
        }
        return level
    }
}

// MARK: - Global methods for compatibility with the corresponding Objective-C macros

public func NXLog(level : NXLogLevel, _ format: String?, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
    
    var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
    
    if module != nil {
        info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
    }
    
    withVaList(arguments) {
        NXLogger.applicationLogger().log(level, info: info, error: nil, exception: nil, format: format, arguments: $0)
    }
}

public func NXLogError(level : NXLogLevel, _ error: ErrorType, _ format: String?, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
    
    var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
    
    if module != nil {
        info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
    }
    
    withVaList(arguments) {
        NXLogger.applicationLogger().log(level, info: info, error: NSError(error), exception: nil, format: format, arguments: $0)
    }
}

public func NXLogException(level : NXLogLevel, _ exception: NSException, _ format: String?, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
    
    var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
    
    if module != nil {
        info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
    }
    
    withVaList(arguments) {
        NXLogger.applicationLogger().log(level, info: info, error: nil, exception: exception, format: format, arguments: $0)
    }
}

public func NXLogTo(logger : String, _ level : NXLogLevel, _ format: String?, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
    
    var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
    
    if module != nil {
        info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
    }
    
    withVaList(arguments) {
        NXLogger(named: logger).log(level, info: info, error: nil, exception: nil, format: format, arguments: $0)
    }
}

public func NXLogErrorTo(logger : String, _ level : NXLogLevel, _ error: ErrorType, _ format: String?, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
    
    var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
    
    if module != nil {
        info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
    }
    
    withVaList(arguments) {
        NXLogger(named: logger).log(level, info: info, error: NSError(error), exception: nil, format: format, arguments: $0)
    }
}

public func NXLogExceptionTo(logger : String, _ level : NXLogLevel, _ exception: NSException, _ format: String?, _ arguments: CVarArgType..., function: String = #function, file: String = #file, line: Int = #line, module : String? = nil) {
    
    var info = [ NXLogInfo.Function.rawValue : function, NXLogInfo.File.rawValue : file, NXLogInfo.Line.rawValue : NSNumber(long: line) ]
    
    if module != nil {
        info.updateValue(module!, forKey: NXLogInfo.Module.rawValue)
    }
    
    withVaList(arguments) {
        NXLogger(named: logger).log(level, info: info, error: nil, exception: exception, format: format, arguments: $0)
    }
}


