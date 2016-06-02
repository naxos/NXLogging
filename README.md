About NXLogging
===============

NXLogging is a modern and easy-to-use logging framework for Objective C and Swift on iOS. It was designed with the programmer's efficiency in mind and using it for logging remains as simple as writing _NSLog(...)_ while allowing broad control, flexibility and extensibility.

Main goals of NXLogging:

- Keep logging as easy as using _NSLog(...)_.
- Support debug console and system log out of the box.
- Log useful information about the caller, e.g. file and function.
- Take special care of logging _NSError_, _NSException_ and _ErrorType_.
- No ramp-up code and configuration necessary.
- Simple, understandable API for customisation and extension.

How to get started
==================

Download the NXLogging Xcode-Project and build the _Universal Framework_ target. Add the resulting _NXLogging.framework_ to the _Embedded Binaries_ of your own project (in Xcode's _General_ section of your build target).

Objective C usage
-----------------

```objectivec
@import NXLogging; // or: #import <NXLogging/NXLogging.h>
```

```objectivec
NXLog(NXLogLevelInfo, @"A simple log message");
NXLog(NXLogLevelInfo, @"A simple log message with an %@", @"argument");
```

Swift usage
-----------

```swift
import NXLogging
```

```swift
NXLog(NXLogLevel.Info, "A simple log message");
NXLog(NXLogLevel.Info, "A simple log message with an %@", "argument");
```

While NXLogging offers the above C-style functions to Swift programmers, too, consider using the more flexible native API:

```swift
NXLogger.log(NXLogLevel.Info, format: "A simple log message")
NXLogger.log(NXLogLevel.Info, format: "A simple log message with an %@", "argument")
```

In principle you can stop reading here, and just start using the NXLogging framework. However, we strongly encourage you to take a few more minutes and delve into

- [Advanced logging](Documentation/Advanced_Logging.md) - Log levels, logging of errors and exceptions, variables
- [Architecture](Documentation/Architecture.nd) - Concepts of the framework
- [Customisation](Documentation/Customisation.md) - Customised log output
- [Extensions](Documentation/Extensions.md) - Extending the framework

We hope, you will enjoy NXLogging and wish you happy coding! If you have any questions, don't hesitate to contact us at <info@naxos-software.com>.

License
=======

NXLogging is licensed under the _Simplified BSD License_:

Copyright (c) 2016, Naxos Software Solutions GmbH
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
