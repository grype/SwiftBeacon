# Implementation Details

At the core of the logging system is a `Beacon` object. It provides a signaling interface by which `Signal`s are transmitted to `SignalLogger`s. When a beacon object receives a signal, observing loggers are notified via its announcer. It is up to the logger to decide whether and how to handle a signal.

Let's start by creating a console logger:

```swift
let consoleLogger = ConsoleLogger(name: "My console logger")
console.start(on: Beacon.shared)

// or in one-shot
let consoleLogger = ConsoleLogger.starting(name: "My console logger", on: Beacon.shared)
```

Loggers carry an arbitrary name to distinguish them from one another. They also need to be started before they can do any logging - starting a logger initiates observation of signals on the given beacon object. Most of the time a single beacon object is sufficient, and unless one is made explicit, the API will assume the `Beacon.shared` instance. This, the last example can be shortened to:

```
let consoleLogger = ConsoleLogger.starting(name: "My console logger")
```


## Emitting signals

Logging is essentially done by emitting a signal on a beacon object:

```swift
ContextSignal().emit(on: Beacon.shared)
```

A more succinct way to emit a signal is to use one of several global `emit()` function:

```swift
emit()  // implying shared Beacon object
``` 

To log an arbitrary string, ala more traditional logging facilities:

```swift
emit("I am a string")
```

In that manner, any value can be emitted, not just strings. 

To facilitate this behavior, there exists a `WrapperSignal` for wrapping arbitrary values. When you call `emit()` _with_ an argument, an instance of `WrapperSignal` is created, capturing that argument (or its copy if it's passed by copy or otherwise conforms to `NSCopying`). The resulting signal is then sent to the beacon object. This is true as long as you don't delcare enother `emit()` method that accepts a more concrete type of argument.


## Specializing signals

To define a custom signal, simply subclass `Signal`. For example, let's create a specialized signal for emitting `URLRequest`s:

```swift
class URLRequestSignal : Signal {
  private(set) var request: URLRequest

  override var signalName: String {
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

1. We override `signalName` to help us visually distinguish this signal from others. The property returns a string identifying the type of signal. Loggers can use that value as appropriate. For example, the `ConsoleLogger` prefixes the signal description with its `signalName`, which makes it easier to distinguish and filter by different types of signals.
2. We also provide additional request information via `description`. The `ConsoleLogger` will use that description by default, when printing out signals. 

To make it possible to `emit()` a `URLRequest` object, we need to make it conform to the `Signaling` protocol:

```swift
extension URLRequest : Signaling {
  var beaconSignal: Signal {
    return URLRequestSignal(self)
  }
}
```

Now we can  `emit(URLRequest(url: "http://example.com/"))`, which then creates and emits the  `URLRequestSignal`. The `ConsoleLogger` will output something like:

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

// 0. Retain Beacons and Loggers
var Beacons = (events: Beacon())
var Loggers = [
    ConsoleLogger.starting(name: "console"),
    MemoryLogger.starting(name: "event", on: Beacons.events)
]

// 1. Emitting to multiple beacons
emit("Debugging")  // will be handled by the console logger
emit(Event.loggedIn(user), on: Beacon.shared + Beacons.events)  // will be handled by both loggers

// 2. Logging via multiple beacons
loggers = [
    ConsoleLogger.starting(name: "console", on: Beacon.shared + Beacons.events))
    MemoryLogger.starting(name: "event", on: Beacons.events)
]

emit("Debugging")  // will be handled by the console logger
emit(Event.loggedIn(user), on: Beacons.events)  // will be handled by both loggers
```
