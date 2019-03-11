# Implementation Details

At the core of the logging system is a `Beacon` object. It provides a signaling interface by which `Signal`s are transmitted to `SignalLogger`s. When a beacon object receives a signal, observing loggers are notified via its announcer (`NotificationCenter`). It is up to the logger to decide whether and how to handle a signal.

Let's start by creating a console logger:

```swift
let consoleLogger = ConsoleLogger(name: "My console logger")
console.start(on: Beacon.shared)

// or simply
let consoleLogger = ConsoleLogger.starting(name: "My console logger")
```

Loggers carry an arbitrary name to distinguish them from one another. They also need to be started before they can do any logging - starting a logger initiates observation of signals on the given beacon object. Most of the time a single beacon object is sufficient, and unless one is made explicit, the API will assume the `Beacon.shared` instance. In the last example we're implicitly using the shared beacon object.

## Emitting signals

Logging is essentially done by emitting a signal on a beacon object:

```swift
ContextSignal().emit(on: Beacon.shared)
```

The `ContextSignal` captures the context in which it is created. It is then emitted on the shared beacon object, which in turn notifies our console logger, which then prints the context information out to the console:

`2018-01-01 01:02:03.123456 MyAppication 🌀 Context [AppDelegate.swift:20] #application(_:didFinishLaunchingWithOptions:)`

A more succinct way to emit a signal is to use one of several global `emit()` function. The last example can be reduced to:

```swift
emit()
```

To log an arbitrary string, ala more traditional logging facilities:

```swift
emit("I am a string")
```

In that manner, any value can be emitted, not just strings. 

To facilitate this behavior, there exists a `WrapperSignal` for wrapping arbitrary values. When you call `emit()` _with_ an argument, an instance of `WrapperSignal` is created, capturing that argument (or its copy if it's passed by copy or otherwise conforms to `NSCopying`). The resulting signal is then sent to the beacon object (the shared instance, or one explicitly specified in the `emit()` call). The console logger will indicate the wrapped value: 

`2018-01-01 01:02:03.123456 MyAppication 📦 __NSCFString [AppDelegate.swift:21] #application(_:didFinishLaunchingWithOptions:) I am a string`

Do note that in the event of calling `emit()` _without_ an argument, a `ContextSignal` will be created instead of  a `WrapperSignal`.

There are two more signals baked into the framework: `ErrorSignal` - for capturing errors, and `StackTraceSignal` - for capturing the call stack.

```swift
do {
throw "I am an error"
} catch {
emit(error: error)
emitStackTrace()
}
```

```
2018-01-01 01:02:03.123456 MyAppication ⚡ Error [AppDelegate.swift:25] #application(_:didFinishLaunchingWithOptions:): I am an error
2018-01-01 01:02:03.123456 MyAppication 💣 StackTrace [AppDelegate.swift:26] #application(_:didFinishLaunchingWithOptions:): I am an error
0   MyApplication       0x0000000101234f63 $S9MyApplication16StackTraceSignalC5error05stackD0ACs5Error_p_SaySSGtcfcfA0_ + 35
1   MyApplication       0x00000001012359a2 $S9MyApplication14emitStackTrace5error8userInfo8fileName4line08functionJ0ys5Error_p_SDys11AnyHashableVypGSgSSSiSStF + 162
...
``` 

## Specializing signals

The framework doesn't provide much specialization beyond the aforementioned signals. To define a custom signal, simply subclass `Signal`. For example, let's create a specialized signal for emitting `URLRequest`s:

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
1. We capture the URLRequest value via `init()`. Alternatively, we could capture copies of mutable properties of the request if we're going to be inspecting them at different stages.
2. We override `signalName` to help us visually distinguish this signal from others. The property returns a string identifying the type of signal. Loggers can use that value as appropriate. For example, the `ConsoleLogger` prefixes the signal description with its `signalName`, which makes it easier to distinguish and filter by different types of signals.
3. We also provide additional request information via `description`. 

To make it possible to `emit()` a `URLRequest` object, we need to make it conform to the `Signaling` protocol:

```swift
extension URLRequest : Signaling {
var beaconSignal: Signal {
return URLRequestSignal(self)
}
}
```

Now we can  `emit(URLRequest(url: "http://example.com/"))`, which then creates and emits the newly added `URLRequestSignal`. The `ConsoleLogger` will output something like:

`2018-01-01 01:02:03.123456 MyAppication 📡 URLRequest [APIClient.swift:123] #execute(request:) GET http://example.com/`

## Filtering

A logger can be started with a filtering function. For example, to log only the `ErrorSignal`s:

```swift
ConsoleLogger.starting(name: "Console error logger")) {
return aSignal is ErrorSignal
}
```

Keep in mind that starting a logger makes it observe beacon objects for relevant signals. Starting a logger on multiple beacons would result in that logger observing multiple beacons. Starting a logger on a beacon it's already observing would resign it from prior observation and filtering, making the most recent call to start() determine the logger's ultimate behavior with respect to that beacon.

## Multiple beacons

Multiple beacons can be used by both signals and loggers. This makes it possible to create versatile configurations. For example:

```swift

var Beacons = (events: Beacon())
// we need to retain our loggers...
var Loggers = [SignalLogger]()

// 1. Emitting to multiple beacons
Loggers.append(ConsoleLogger.starting(name: "console"))
Loggers.append(HypotheticalRemoteLogger.starting(name: "event", on: Beacons.events)

emit("Debugging")  // will be handled by the console logger
emit(Event.loggedIn(user), on: Beacon.shared + Beacons.events)  // will be handled by both loggers

// 2. Logging via multiple beacons
Loggers.append(ConsoleLogger.starting(name: "console", on: Beacon.shared + Beacons.events))
Loggers.append(HypotheticalRemoteLogger.starting(name: "event", on: Beacons.events)

emit("Debugging")  // will be handled by the console logger
emit(Event.loggedIn(user), on: Beacons.events)  // will be handled by both loggers
```

In the first case, we setup a console logger to observe the shared beacon, and a hypothetical remote logger to observe a dedicated beacon for signaling application events. When we emit signals, we specify which beacons to signal ( `+` operator combines beacons and arrays of beacons).

In the second case, we setup a console logger that observes both the shared and the dedicate event beacons. When we emit an event signal - we direct it to the dedicated event beacon object. In both cases the end result is the same.
