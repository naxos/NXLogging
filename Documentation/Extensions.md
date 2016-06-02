Extensions
==========

Creating a new log target
-------------------------

The most interesting part in extending your logging is probably creating a new log target class. Let us assume, you would like to log to an UITextView in your application, with different colors for each log level.

Since the console log target _NXConsoleLogTarget_ already supports colors, we create a subclass: _TextViewLogTarget_.

Objective C: TextViewLogTarget.h

```objectivec    
@import UIKit;
@import NXLogging;

@interface TextViewLogTarget : NXConsoleLogTarget

- (instancetype)initWithTextView:(UITextView *)textView;

@end
```

and the implementation TextViewLogTarget.m

```objectivec    
#import "TextViewLogTarget.h"

@implementation TextViewLogTarget {
    UITextView *_textView;
}

- (instancetype)initWithTextView:(UITextView *)textView {
    NXBasicLogFormatter *formatter = [NXBasicLogFormatter sharedInstance];

    self = [super initWithFormatter:formatter];
    if (self) {
        _textView = textView;
        self.colorsEnabled = YES;
        formatter.hiddenInfo = ~(NXLogInfoSourceCode | NXLogInfoLevel | NXLogInfoContent);
    }
    return self;
}

- (void)log:(NXLogLevel)level message:(id)message {
    NSString *msg = [NSString stringWithFormat:@"%@", message];
    UIColor *color = [UIColor blackColor];

    msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
    msg = [msg stringByAppendingString:@"\n\n"];

    if (self.colorsEnabled) {
        NXTextColor *c = [self colorForLogLevel:level];
        color = [UIColor colorWithRed:c.red green:c.green blue:c.blue alpha:1.f];
    }

    // Modify the UI on the main thread.
    // This will happen sequentially, so we don't need to worry about thread-safety when accessing the textView property.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *text = [_textView.attributedText mutableCopy];
        NSDictionary *attr = @{ NSForegroundColorAttributeName : color };

        [text appendAttributedString:[[NSAttributedString alloc] initWithString:msg attributes:attr]];
    
        [_textView setAttributedText:text];
    });
}

@end
```

Now we need a view controller. LogViewController.h

```objectivec    
@import UIKit;

@interface LogViewController : UIViewController

/// The text view outlet
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
```

and LogViewController.m

```objectivec    
#import "LogViewController.h"
#import "TextViewLogTarget.h"

@import NXLogging;

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NXLogger applicationLogger] addLogTarget:[[TextViewLogTarget alloc] initWithTextView:self.textView]];
}

@end
```

That's it. Assign the _LogViewController_ class to a view controller in interface builder and link the _textView_ property to an _UITextView_.

Now in Swift. TextViewLogTarget.swift

```swift    
import UIKit
import NXLogging

class TextViewLogTarget: NXConsoleLogTarget {

    private var textView: UITextView

    init!(textView: UITextView!) {
        let formatter = NXBasicLogFormatter()

        super.init(formatter: formatter)

        self.textView = textView
        self.colorsEnabled = true
        formatter.hiddenInfo = NXLogInfo.All.exclusiveOr([ .SourceCode, .Level, .Content ])
    }

    override func log(level: NXLogLevel, message: AnyObject!) {
        var msg = String(format: "%@", message.description)
        var color = UIColor.blackColor()
    
        msg = msg.stringByReplacingOccurrencesOfString("\n", withString: "\n   ")
        msg = msg.stringByAppendingString("\n\n")
        
        if self.colorsEnabled {
            let c = self.colorForLogLevel(level)
            color = UIColor(red: CGFloat(c.red), green: CGFloat(c.green), blue: CGFloat(c.blue), alpha: 1.0)
        }
    
        // Modify the UI on the main thread. 
        // This will happen sequentially, so we don't need to worry about thread-safety when accessing the textView property.
    
        dispatch_async(dispatch_get_main_queue()) {
            let text = NSMutableAttributedString(attributedString: self.textView.attributedText)
            let attr = [ NSForegroundColorAttributeName : color ]                
            
            text.appendAttributedString(NSAttributedString(string: msg, attributes: attr))
        
            self.textView.attributedText = text
        }
    }
}
```

and LogViewController.swift

```swift    
import UIKit
import NXLogging

class LogViewController: UIViewController {

    /// The text view outlet
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NXLogger.applicationLogger().addLogTarget(TextViewLogTarget(textView: textView))
    }
}
```

Done. Again, assign the _LogViewController_ class to a view controller in interface builder and link the _textView_ property to an _UITextView_.
