Customisation
=============

It might be a good idea to read [Advanced Logging](02-Advanced_Logging.html) before continuing here. For a general overview of the concepts of NXLogging, read [Architecture](03-Architecture.html).

Unless you manually created a _NXLogger_ instance, any of the standard loggers use the shared instances of _NXSystemLogTarget_ and _NXConsoleLogTarget_ for log output, which themselves employ the shared instances of _NXSystemLogFormatter_ and _NXDebugLogFormatter_ respectively.

The following examples will show the configuration of these shared instances of log targets and log formatters, but of course the configuration can as well be applied to any other compatible log target or formatter.

This chapter tells you all about

- [Setting the log level threshold](#log_level_threshold)
- [Configuring log information](#log_information)
- [Managing log targets](#managing_log_targets)
- [Logging to files](#logging_to_files)
- [Managing log formatters](#managing_log_formatters)
- [Logging in colors](#logging_in_colors)

<a name="log_level_threshold"></a>
Log level threshold
-------------------

You change the log level threshold of any log target with the _maxLogLevel_ property. To e.g. change the log level threshold for the shared NXConsoleLogTarget to Warning, you would write in Objective C:

    [NXConsoleLogTarget sharedInstance].maxLogLevel = NXLogLevelWarning;

and in Swift:

    NXConsoleLogTarget.sharedInstance().maxLogLevel = .Warning

As an effect, log messages with the log levels Debug, Info and Notice will __not__ be logged to this target.

If you want to silence a log target completely, assign __None__ (_NXLogLevelNone_ in Objective C, _NXLogLevel.None_ in Swift). If, however, you want any log message to be logged to the target, you can assign __Any__ (_NXLogLevelAny_ in Objective C, _NXLogLevel.Any_ in Swift).

<a name="log_information"></a>
Log Information
---------------

Removing (or adding) information to the log is a task of the __log formatter__. All standard log formatters which come with NXLogging are sub classes of NXBasicLogFormatter and inherit its property `NXLogInfo hiddenInfo`. This property is a bit mask representing the information that you wish __not__ to be displayed in the log. The _NXLogInfo_ enum is defined in the public header file _NXLogTypes.h_, where you will also find additional documentation. In Objective C, _NXLogInfo_ is presented as a bitmask, in Swift as an _OptionSetType_.

If, e.g. you want all available information on your debug console (note, that this will lead to very long lines), you can achieve this in Objective C with:

    [NXDebugLogFormatter sharedInstance].hiddenInfo = NXLogInfoNone;
    
and in Swift:

    NXDebugLogFormatter.sharedInstance().hiddenInfo = .None

In the highly unlikely case, that you wish to log empty lines, you can assign _NXLogLevelAll_ to the _hiddenInfo_ property. More likely however is, that you will use the value _All_ to hide everything __but__ certain info. Let's say, e.g. that you want to hide everything but the _Date_, the log _Level_, and the actual _Content_ (which is messages, errors and exceptions); then you would write in Objective C:

    NXLogInfo visibleInfo = NXLogInfoDate | NXLogInfoLevel | NXLogInfoContent;
    [NXDebugLogFormatter sharedInstance].hiddenInfo = NXLogInfoAll ^ visibleInfo;

and in Swift:

    let visibleInfo : NXLogInfo = [ .Date, .Level, .Content ]
    NXDebugLogFormatter.sharedInstance().hiddenInfo = NXLogInfo.All.exclusiveOr(visibleInfo)

Note, that in Objective C, you could also assign the _bitwise complement_ <code style="font-size:11px">~visibleInfo</code> instead of the _exclusive or_ <code style="font-size:11px">NXLogInfoAll ^ visibleInfo</code>.

<a name="managing_log_targets"></a>
Managing log targets
--------------------

Instead of silencing a log target by setting its _maxLogLevel_ property to _None_ (see above), you can also remove it from the logger. Let's assume, you want to remove the console log target (_NXConsoleLogTarget_) from the standard logger (_applicationLogger_). In Objective C you would code:

    [[NXLogger applicationLogger] removeLogTarget:[NXConsoleLogTarget sharedInstance]];

and in Swift:

    NXLogger.applicationLogger().removeLogTarget(NXConsoleLogTarget.sharedInstance());

Of course, it's just as simple to add a log target. Just use _addLogTarget_ instead of _removeLogTarget_. See also _Logging to files_.

<a name="logging_to_files"/>
Logging to files
----------------

To log to a file, simply add a _NXFileLogTarget_ to an existing logger, or create a new logger with such a target. In Objective C:

    NXFileLogTarget *fileLogTarget = [NXFileLogTarget sharedInstance];

    fileLogTarget.maxAge = 24 * 60 * 60;
    fileLogTarget.maxSize = 1024 * 1024;
    fileLogTarget.maxNumberOfFiles = 10;

    [[NXLogger applicationLogger] addLogTarget:fileLogTarget];

and in Swift:

    let fileLogTarget = NXFileLogTarget.sharedInstance()
    
    fileLogTarget.maxAge = 24 * 60 * 60
    fileLogTarget.maxSize = 1024 * 1024
    fileLogTarget.maxNumberOfFiles = 10
    
    NXLogger.applicationLogger().addLogTarget(fileLogTarget)

The _sharedInstance_ of the _NXFileLogTarget_ will log to the documents directory into a file with the same names as your application and the extension _log_. If you want to change the file, the target is logging to, use the _filePath_ property. Note, that data protection (encryption) is __not__ turned on for the log file. With the above configuration, the log file will be rolled over after a day or after it reaches a size of 1 MB, while a maximum of ten log files will be kept (the current log file plus nine historic files). A value of 0 (the default value) for _maxAge_, _maxSize_, and _maxNumberOfFiles_ means unlimited file age, size and number respectively. When a log file is being rolled over, the log target will add a minus sign, followed by a timestamp to the old file's name and keep the extension _log_. Please note, that the _sharedInstance_ of the _NXFileLogTarget_ uses the _sharedInstance_ of the _NXDebugLogFormatter_ for formatting log output.

__Warning__: You can __not__ use several log target instances with the same file (_filePath_ property). You may however, use one log target instance in several loggers.

<a name="managing_log_formatters"></a>
Managing log formatters
-----------------------

You can replace a log formatter simply by assigning it to the _logFormatter_ property of a log target. This is how you format your log to JSON in Objective C:

    NXJSONLogFormatter *jsonLogFormatter = [NXJSONLogFormatter sharedInstance];
    
    jsonLogFormatter.prettyPrint = YES;
    
    [NXConsoleLogTarget sharedInstance].logFormatter = jsonLogFormatter;

and in Swift:

    let jsonLogFormatter = NXJSONLogFormatter.sharedInstance()

    jsonLogFormatter.prettyPrint = true

    NXConsoleLogTarget.sharedInstance().logFormatter = jsonLogFormatter

<a name="logging_in_colors"></a>
Logging in colors
-----------------

You can log to your Xcode debug console in colors. Since Xcode doesn't support colors in the console natively, we need the help of a Plug-in. Install [XcodeColors](https://github.com/robbiehanson/XcodeColors). It's simple: Just pull it from GitHub, build the XcodeColors target, and restart Xcode. You can then enable a colorful log output in Objective C like this:

    [NXConsoleLogTarget sharedInstance].colorsEnabled = YES;

and in Swift:

    NXConsoleLogTarget.sharedInstance().colorsEnabled = true

You can also adjust the color used for every log level individually. To set the color for messages at level _Notice_ to magenta, write the following in Objective C:

    NXTextColor *magenta = [NXTextColor colorWithRed:255 green:0 blue:255];
    
    [[NXConsoleLogTarget sharedInstance] setColor:magenta forLoglevel:NXLogLevelNotice];
    
and in Swift:

    let magenta = NXTextColor(red: 255, green: 0, blue: 255)
    
    NXConsoleLogTarget.sharedInstance().setColor(magenta, forLoglevel: .Notice)
