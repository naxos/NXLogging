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

public extension NSException {

    /**
     * Creates and raises an exception with the specified name, reason, and arguments.
     *
     * @param name The name of the exception.
     * @param cause An underlying exception.
     * @param format A human-readable message string (that is, the exception reason) with conversion specifications for the variable arguments that follow.
     * @param ... Variable information to be inserted into the formatted exception reason (in the manner of printf).
     */
    @nonobjc public class func raise(name : String, cause: NSException? = nil, format: String? = nil, _ arguments: CVarArgType...) {
        
        withVaList(arguments) {
            NSException.raise(name, cause: cause, format: format, arguments: $0);
        }
    }

}