# NXLogging

`NXLogging` is a modern and easy-to-use logging framework for Objective C and Swift on iOS. It was designed with the programmer's efficiency in mind and using it for logging remains as simple as writing _NSLog(...)_ while allowing broad control, flexibility and extensibility.

## Main goals of NXLogging

- Keep logging as easy as using _NSLog(...)_.
- Support debug console and system log out of the box.
- Log useful information about the caller, e.g. file and function.
- Take special care of logging _NSError_, _NSException_ and _ErrorType_.
- No ramp-up code and configuration necessary.
- Simple, understandable API for customisation and extension.

## Examples

### Objective C usage

```objectivec
@import NXLogging; // or: #import <NXLogging/NXLogging.h>
```

```objectivec
NXLog(NXLogLevelInfo, @"A simple log message");
NXLog(NXLogLevelInfo, @"A simple log message with an %@", @"argument");
```

### Swift usage

```swift
import NXLogging
```

```swift
NXLog(NXLogLevel.Info, "A simple log message");
NXLog(NXLogLevel.Info, "A simple log message with an %@", "argument");
```

While `NXLogging` offers the above C-style functions to Swift programmers, too, consider using the more flexible native API:

```swift
NXLogger.log(NXLogLevel.Info, format: "A simple log message")
NXLogger.log(NXLogLevel.Info, format: "A simple log message with an %@", "argument")
```

## Documentation

`NXLogging` offers a host of features. Find out more and read the [Documentation](Docs/html/index.html).

## License

`NXLogging` is licensed under the Simplified BSD License. See the [LICENSE file](LICENSE.md)