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

public extension NSError {

    @nonobjc public convenience init(_ error: ErrorType, reason: String? = nil, suggestion: String? = nil,  underlyingError: NSError? = nil) {
        
        let nserror = error as NSError;
        var dict = nserror.userInfo
        
        if reason != nil {
            dict[NSLocalizedFailureReasonErrorKey] = reason;
        }
        if suggestion != nil {
            dict[NSLocalizedRecoverySuggestionErrorKey] = suggestion;
        }
        if underlyingError != nil {
            dict[NSUnderlyingErrorKey] = underlyingError;
        }
        
        if error is AnyObject {
            
            // The error was already an NSError or a subclass of it, so just copy it
            self.init(domain: nserror.domain, code: nserror.code, userInfo: dict)
            
        } else {
            
            // The error is an Enum, so we store some extra info in localizedDescription
            dict[NSLocalizedDescriptionKey] = "\(error)"
            self.init(domain: nserror.domain, code: nserror.code, userInfo: dict)
            
        }
    }
}
