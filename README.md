# SwiftBeacon

Implementation of the [Beacon](https://github.com/pharo-project/pharo-beacon) logging framework in Swift. The framework distinguishes itself from traditional logging systems by doing away with levels and allowing for logging of arbitrary objects/structures, not just text. For background information on Beacon, see [this article](http://www.humane-assessment.com/blog/beacon). 

## Getting started

At the heart of the logging system is a `Beacon` object. It encapsulates two essential objects: an announcer (`NotificationCenter`) and a collection of loggers (`SignalLogger`) that observe the announcer for relevant notifications. When the beacon object receives a signal, its loggers are notified via the announcer. It is up to the logger to decide whether and how to handle a signal. 

Before any of that can be done, however, we need to create and configure a beacon object:

```swift
Beacon.shared.add(ConsoleLogger(name: "Console logger"), start: true)
```

Here we're creating a console logger, adding it to the shared beacon object and instructing the beacon object to automatically start the logger. In most cases a single beacon object is sufficient and having a shared instance greatly simplifies our interaction with the system.

### The logging mechanism

Logging is done by sending signals to a beacon object:

```swift
Beacon.shared.signal(ContextSignal())
```

The `ContextSignal` simply captures the context in which it is created. It is then used to signal the shared beacon object, which in turn notifies our console logger, which then prints the context information out to the console:

`2018-01-01 01:02:03.123456 MyAppication 🌀 Context [AppDelegate.swift:20] #application(_:didFinishLaunchingWithOptions:)`

This is the basic mechanism of logging signals, though a bit clunky...

### Emitting signals

A more succinct way to emit a signal is to use the `emit()` function. For example, to log the current execution context, as we did earlier:

```swift
emit()
```

To log an arbitrary string, ala more traditional logging facilities:

```swift
emit("I am a string")
```

In that manner, any structure can be emitted, not just strings. 

To facilitate this behavior, there exists a `WrapperSignal`, whose sole function is to wrap any value you give it. When you call `emit()` _with_ an argument, an instance of `WrapperSignal` is created, capturing that arugment. The resulting signal is then sent to the associated beacon object. 

`2018-01-01 01:02:03.123456 MyAppication 📦 __NSCFString [AppDelegate.swift:21] #application(_:didFinishLaunchingWithOptions:) I am a string`

Do note that in the event of calling `emit()` _without_ an argument, a `ContextSignal` will be created instead of  a `WrapperSignal`.

In addition to the `WrapperSignal`, there are two more specialized signals worth mentioning: `ErrorSignal` - for capturing errors, and `StackTraceSignal` - for capturing the call stack.

```swift
do {
    throw "I am an error"
} catch {
    emit(error: error)
    emitStackTrace(error: error)
}
```

```
2018-01-01 01:02:03.123456 MyAppication ⚡ Error [AppDelegate.swift:25] #application(_:didFinishLaunchingWithOptions:): I am an error
2018-01-01 01:02:03.123456 MyAppication 💣 StackTrace [AppDelegate.swift:26] #application(_:didFinishLaunchingWithOptions:): I am an error
0   MyApplication       0x0000000101234f63 $S9MyApplication16StackTraceSignalC5error05stackD0ACs5Error_p_SaySSGtcfcfA0_ + 35
1   MyApplication       0x00000001012359a2 $S9MyApplication14emitStackTrace5error8userInfo8fileName4line08functionJ0ys5Error_p_SDys11AnyHashableVypGSgSSSiSStF + 162
...
``` 

### Specializing signals

The framework doesn't provide much specialization beyond the already mentioned `WrapperSignal`, `ErrorSignal` and `StackTraceSignal`. To define a custom signal, simply subclass `Signal`. For example, let's create a specialized signal for emitting `URLRequest`s:

```swift
class URLRequestSignal : Signal {
    private(set) var request: URLRequest

    override class var signalName: String {
        return "📡 \(super.signalName)"
    }

    init(_ aRequest: URLRequest) {
        request = aRequest
        super.init()
    }

    override var description: String {
        var urlDescription = ""
        if let method = request.httpMethod {
            urlDescription += "\(method) "
        }
        if let url = request.url {
            urlDescription += "\(url)"
        }
        return "\(super.description) \(urlDescription)"
    }
}
```

A few things worth noting here:
1. We capture the original value via `init()`
2. We override `signalName` to help us visually distinguish this signal from others. The property returns a string identifying the type of signal. Loggers can use that value as appropriate. For example, the `ConsoleLogger` simply prefixes the signal description with its `signalName`, which makes it a lot easier to distinguish different types of signals.
3. We provide URL request information by overriding `description`. 

Lastly, to actually `emit()` a `URLRequest` object, we need to make it conform to the `Signaling` protocol:

```swift
extension URLRequest : Signaling {
    var beaconSignal: Signal {
        return URLRequestSignal(self)
    }
}
```

Now we can  `emit(URLRequest(url: "https://example.com/"))`, which then creates and emits the newly added `URLRequestSignal`. The `ConsoleLogger` will output something like:

`2018-01-01 01:02:03.123456 MyAppication 📡 URLRequest [APIClient.swift:123] #execute(request:) POST http://example.com/post`

### Filtering

Loggers can be started with a filtering function, like this:

```swift
Beacon.shared.add(ConsoleLogger(name: "Filtered console logger")) {
    return aSignal is ErrorSignal
}
```

This logger will only process instances of ErrorSignal. This approach offers many interesting ways of interacting with the logging system...

### Multiple beacons

Using mulitple beacons:

```swift
let debugBeacon = Beacon()
#if DEBUG
debugBeacon.add(ConsoleLogger(name: "console"))
debugBeacon.loggers.forEach { $0.start() }
#endif

let releaseBeacon = Beacon()
#if RELEASE
releaseBeacon.add(ConsoleLogger(name: "console"))
releaseBeacon.add(FileLogger(name: "file"))
releaseBeacon.loggers.forEach { $0.start { return $0 is ErrorSignal } }
#endif

emit("testing", on: debugBeacon) // will be handled by debugBeacon in DEBUG build
emit(error: anError, on: releaseBeacon)  // will be handled by releaseBeacon in RELEASE build
```
