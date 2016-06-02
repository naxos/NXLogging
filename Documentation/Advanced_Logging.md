Advanced Logging
================

This is about

- [Using different log levels](#log_levels)
- [Logging errors](#logging_errors)
- [Logging exceptions](#logging_exceptions)
- [Using variables in your log messages](#log_variables)

<a name="log_levels"></a>
Log Levels
----------

NXLogging supports the eight log levels first introduced with syslog back in the 1980s. The Apple System Log (ASL) uses the same:

- Debug
- Info
- Notice
- Warning
- Error
- Critical
- Alert
- Emergency

In your code you will use these log levels with the prefix _NXLogLevel_. In Objective C you could write

```objectivec
NXLogLevel level = NXLogLevelWarning;
```

and in Swift

```swift
let level: NXLogLevel = NXLogLevel.Warning // or for short: .Warning
```

On a side note: In our documentation ---and partially in the API--- we will use the terms _log level_ and _severity_, which refer to the same concept but counter-directional: _Debug_ is the __highest log level__ (most detailled) but has the __lowest severity__ (least impact). Therefore, if you configure a log target's __maximum log level__ to _Error_, it will log only log messages with a __level up to__ _Error_ (_Error_, _Critical_, _Alert_ and _Emergency_). For adjusting the maximum log level, refer to [Customisation](Customisation.md).

The log levels are defined in the public header file _NXLogTypes.h_. You will also find some additional documentation there.

You can use the log levels to your liking but know, that some backends might filter log messages according to their severity. The Apple System Log, e.g. by default only accepts messages with a severity of _Notice_ or higher.

The standard log configured in NXLogging logs to the _console_ (usually the Xcode debug console) and to the _system_ (ASL, usually what you see accessing the system) log. The maximum log level for the _console_ is preconfigured to _Debug_ and for the _system_ to _Notice_ (the latter coinsides with the default setting of ASL).

<a name="logging_errors"></a>
Logging errors
--------------

Here is an example on error handling and logging in Objective C:

```objectivec
NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
NSError *error = nil;
NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

if(error) {
    NXLogError(NXLogLevelError, error, @"Unable to read file %@", path.lastPathComponent);
} else {
    NXLog(NXLogLevelDebug, @"Got content:'%@' from file %@", content, path.lastPathComponent);
}
```

and here in Swift:

```swift
let path : NSString! = NSBundle.mainBundle().pathForResource("test", ofType: "txt")

do {
    let content = try NSString(contentsOfFile: path as String, encoding: NSUTF8StringEncoding)
    NXLogger.log(.Debug, format: "Got content '%@' from file %@", content, path.lastPathComponent)
} catch {
    NXLogger.log(.Error, error: error, format: "Unable to read file %@", path.lastPathComponent)
}
```

Appart from the obviously different error handling in the two languages, the logging is pretty much the same. If the encoding file in the examples is not UTF-8, you'll get a log message like this:

<pre style="font-size: 11px">2016-03-12 16:37:43 &lt;Error&gt;: com.naxos-software.NXLoggingSample logSomething()(LogClientSwift.swift:92) - Unable to read file test.txt
   Error: The operation couldn’t be completed. (NSCocoaErrorDomain, error 261)
</pre>
   
Here's another Swift example. Assume the implementation of a vending machine (adopted from Apple's [error handling guide](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html)):

```swift
enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int, coinsInserted: Int)
    case OutOfStock
}

func buyBeer(coins: Int) throws {
    if (coins < 5) {
        throw VendingMachineError.InsufficientFunds(coinsNeeded: 5, coinsInserted: coins)
    } else {
        ejectBeer();
    }
}
```

As a caller, you can simply log an error like this:

```swift
do {
    try buyBeer(3)
} catch {
    NXLogger.log(error: error)
}
```

In Swift, you can omit the log level for the log method and leave it to the logger to find a suitable one. Here it will use _NXLogLevel.Error_, because an _ErrorType_ was logged. Also note the details of the error message, which you get in the second line of the log output even though the error was just an enum value:

<pre style="font-size: 11px">2016-03-12 16:37:43 &lt;Error&gt;: com.naxos-software.NXLoggingSample swiftSpecificExamples()(LogClientSwift.swift:130)
   Error: InsufficientFunds(5, 3) (NXLoggingSample.VendingMachineError, error 1)
</pre>

You can also handle the error in a slightly more elaborate way and add some information to the log by using the _NSError_ extension of NXLogging:

```swift
do {
    try buyBeer(3)
} catch VendingMachineError.InsufficientFunds(let p) {
    NXLogger.log(error: NSError(VendingMachineError.InsufficientFunds(p),
        reason: "\(p.coinsInserted) coins inserted but \(p.coinsNeeded) coins are needed",
        suggestion: "Insert \(p.coinsNeeded - p.coinsInserted) more coins"))
} catch let error as VendingMachineError {
    NXLogger.log(error: NSError(error, suggestion: "Try banging the machine"))
} catch {
    NXLogger.log(error: error)
}
```

The result will look something like this:

<pre style="font-size: 11px">2016-03-12 16:37:43 &lt;Error&gt;: com.naxos-software.NXLoggingSample swiftSpecificExamples()(LogClientSwift.swift:145)
   Error: InsufficientFunds(5, 3) (NXLoggingSample.VendingMachineError, error 1)
      Reason: 3 coins inserted but 5 coins are needed
      Suggestion: Insert 2 more coins
</pre>

Especially in Objective C, where you are stuck with _NSError_, NXLogging's extension makes it more convenient creating _NSError_ instances:

```objectivec
NSError *err = [NSError errorWithCode: -2
                          description: @"Unable to complete this operation"
                               reason: @"The request timed out"
                           suggestion: @"Try again later"
                      underlyingError: [NSError errorWithCode: -1 description: @"Time-out error"]];
```

In most cases you don't have to deal with the _userInfo_ dictionary and if omitted, _NSError_ will use an error domain derived from the bundle identifier of your application. Logging the error above will result in log output similar to the one below (note how underlying errors are included recursively):

<pre style="font-size: 11px">2016-03-12 16:37:43 &lt;Error&gt;: com.naxos-software.NXLoggingSample [LogClientObjC logSomething](LogClientObjC.m:33)
   Error: Unable to complete this operation (NXLoggingSampleErrorDomain, error -2)
      Reason: The request timed out
      Suggestion: Try again later
   Caused by: Time-out error (NXLoggingSampleErrorDomain, error -1)
</pre>

<a name="logging_exceptions"></a>
Logging exceptions
------------------

We don't want to encourage you to raise and catch exceptions all over your Objective-C or (even worse) Swift code. In rare cases however, exception handling might be necessary. NXLogging comes with an extension to the _NSException_ class, which allows for __nested exceptions__ by adding the property __cause__. It also adds a static method __probe__, which is particular useful in Swift, because Swift does not come with a standard way to catch a raised _NSException_.

In Objective C you can create and raise and catch exceptions like this:

```objectivec
- (void)badGuy {
    [NSException raise:@"BadGuyException" format:@"Trouble is my middle name"];
}

- (void)handleBadGuy {
    NSException *exception = [NSException probe:^{ [self badGuy]; }];

    [NSException raise:@"TooBadException" cause:exception format:@"Can't handle the %@", @"bad guy"];
}
```

And the equivalent in Swift:

```swift
func badGuy() {
    NSException.raise("BadGuyException", format: "Trouble is my middle name")
}

func handleBadGuy() {
    let exception = NSException.probe(badGuy)

    NSException.raise("TooBadException", cause: exception, format: "Can't handle the %@", "bad guy")
}
```

Now, if you log an exception in Objective C:

```objectivec
NSException *exception = [NSException probe:^{ [self handleBadGuy]; }]; // We could also do @try @catch here

NXLogException(NXLogLevelNotice, exception, @"Something sinister is going on");
```

or in Swift:

```swift
let exception = NSException.probe(handleBadGuy)
    
NXLogger.log(.Notice, exception: exception, format: "Something sinister is going on")
```

you'll end up with log like this:

<pre style="font-size: 11px">2016-03-12 16:37:43 &lt;Notice&gt;: com.naxos-software.NXLoggingSample logSomething()(LogClientSwift.swift:90) - Something sinister is going on
   Exception: Can't handle the bad guy (TooBadException)
   Caused by: Trouble is my middle name (BadGuyException)
      &gt;&gt; Log with severity Error or higher to enable call stack symbols &lt;&lt;
</pre>

As the last line of the log output states, logging an exception with the severity _Error_ or above, will cause the logger to include the __call stack symbols__ in the log. You can configure this threshold on the log target (see [Customisation](Customisation.md)).

<a name="log_variables"></a>
Log variables
-------------

Let us assume, that you don't want every line in your logs to include a lot of information on the client's environment, which sometimes might be advisable for a production system (see [Customisation](Customisation.md) on how to achieve this). Let us also assume, that for some particular log messages you _do_ want to include some info. In such a case, you can make use of __log variables__:

```swift
NXLogger.log(.Warning, format: "This feature is not available in $(systemName) $(systemVersion).")

NXLogger.log(.Error, format: "Sorry, this device ($(deviceModel)) does not make coffee.")

// You can also put variables in the format arguments ...
NXLogger.log(.Info, format: "Application %@ started on %@ with process ID %@.", "$(processName)", "$(deviceName)", "$(processID)")

// ... or even mix it like this
NXLogger.log(.Emergency, format: "HELP WANTED: Can some Swift expert fix function $(%@) in file $(%@)?", "function", "file")
```

The variables currently supported are:

- file
- function
- line
- module
- date
- processName
- processID
- deviceName
- deviceModel
- systemName
- systemVersion

Logging with the statements above, will result in log lines like this:

<pre style="font-size: 11px">2016-03-12 16:37:43 &lt;Warning&gt;: This feature is not available in iPhone OS 9.2.
2016-03-12 16:37:43 &lt;Error&gt;: Sorry, this device (x86_64) does not make coffee.
2016-03-12 16:37:43 &lt;Info&gt;: Application NXLoggingSample started on iPhone Simulator with process ID 63132.
2016-03-12 16:37:43 &lt;Emergency&gt;: HELP WANTED: Can some Swift expert fix function logSomething() in file LogClientSwift.swift?
</pre>
