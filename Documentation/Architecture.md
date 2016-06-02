Architecture
============

When, in Objective C, you log a message by writing

```objectivec
NXLog(NXLogLevelInfo, @"A simple log message");
```

you are actually using a preprocessor macro and you could have also written

```objectivec
[[NXLogger applicationLogger] log:level info:NX_LOG_INFO format:@"A simple log message"];
```

The first thing we notice is the _NXLogger_ class and when we look at its definition we find two readonly properties:

```objectivec
NSString *name;

NSArray<id<NXLogTarget>> *targets;
```

So, a logger instance of the _NXLogger_ class has a __name__ and several __log targets__, which conform to the protocol _NXLogTarget_. The static method _applicationLogger_ looks up and ---in case it does not yet exist--- creates a logger with a name identical to the __bundle identifier__ of your application and pre-configures it with two log targets, which are singleton instances of the _NXSystemLogTarget_ (logs via ASL to the system log) and _NXConsoleLogTarget_ (logs to the debug console) classes. You can access these pre-configured log targets globally with the static _sharedInstance_ method of the respective classes.

The _NXLogTarget_ protocol defines the two read/write properties

```objectivec
NXLogLevel maxLogLevel;

id<NXLogFormatter> logFormatter;
```

which introduce the _NXLogLevel_ enum type and the _NXLogFormatter_ protocol. At this point you know pretty much everything there is to the basic concept of NXLogging. Let's summarise by looking at the entity relationship:

_NXLogger_ (n)------(n) _NXLogTarget_ (n)------(1) _NXLogFormatter_

In words, a __logger__ holds one or more __log targets__ and a log target holds one __log formatter__. What you can also see from the relationship model is, that every log target can be used in many loggers, and every log formatter can be used in many log targets. This is important knowledge, because it infers that every implementation of the protocols _NXLogTarget_ and _NXLogFormatter_ must be thread-safe.

While the static method _applicationLogger_ of the _NXLogger_ class looks-up/creates a logger instance with your bundle identifier as the logger's name, you can also look-up/create named loggers with the static method _loggerNamed:_. Again these loggers will be pre-configured to log to the system log and the debug console. If you want to have full control over how a logger is configured, you can also instantiate it manually with the constructor _initWithName:target:_. In order to be able to look-up a manually instantiated logger via the _loggerNamed:_ method, you must register the logger instance with the static method _registerLogger:_ of the _NXLogger_ class.

When you instantiate a logger manually, you have to pass a name and a log target to the constructor. As log targets you can use the shared instances of _NXSystemLogTarget_ or _NXConsoleLogTarget_, or instantiate a log target manually with _initWithFormatter:_. The shared instance of _NXSystemLogTarget_ is pre-configured with a _NXSystemLogFormatter_ and the shared instance of _NXConsoleLogTarget_ uses a _NXDebugLogFormatter_ to format the log messages. Again, these pre-configured log formatter instances are globally accessible via their static _sharedInstance_ methods. Both, the _NXSystemLogFormatter_ and the _NXDebugLogFormatter_ classes inherit from the _NXBasicLogFormatter_ class.

To learn more about how you can configure the logging system, read [Customisation](Customisation.md), and if you want to create your own log targets or log formatters, read [Extensions](Extensions.md).
