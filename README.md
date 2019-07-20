# Beacon

Implementation of [Beacon](https://github.com/pharo-project/pharo-beacon) logging framework in Swift. The framework distinguishes itself from traditional logging systems by doing away with levels and allowing for logging of arbitrary values, not just text. For introductory information on Beacon, see http://www.humane-assessment.com/blog/beacon.

## Installing

Install as swift package...

## Getting started 

Logging with Beacon is a matter of emitting a signal. Let's start by creating a console logger and emitting a few things for it to log:   

```swift
// create and start an instance of a console logger
let consoleLogger = ConsoleLogger.starting(name: "Console")

// emit current context, capturing the stack trace
emit()

// emit a string
emit("A message")

// emit arbitrary value
emit(anything)

// emit an error
do { try something() } catch { emit(error) }

consoleLogger.stop()
```

The framework uses the Observer pattern, with instances of `SignalLogger` subscribing to notifications posted on a `Beacon` object. Calling `emit()` creates an appropriate instance of `BeaconSignal` and posts it on a `Beacon` object, thus notifying observing loggers. In the above examples, a shared instance of `Beacon` is implied. However, multiple loggers and beacons can be used:

```swift
let Beacons = (
    shared: Beacon.shared, 
    rpc: Beacon()
)

let Loggers = (
    // start console logger on shared beacon - no need to provide it as argument
    console: ConsoleLogger.starting(name: "Console"),
    
    // start JSON-RPC logger on dedicated beacon
    jrpc: JRPCLogger.starting(url: "http://localhost:4000", method: "emit", name: "JRPC", on: Beacons.shared + Beacons.rpc)
)

// emit current context on the shared beacon (handled by both loggers)
emit()

// emit current context on rpc beacon (handled by RPC logger only)
emit(on: Beacons.rpc)
```

Signals can be augmented with arbitrary user info:

```swift
emit(something, userInfo: ["detail" : "Detail Info"])
```

Loggers can be started temporarily:

```swift
ConsoleLogger(name: "Console").run {
    // will be logged by console logger
    emit()
}

// won't be logged by console logger
emit()
```

and are capable of filtering signals:

```swift
let consoleLogger = ConsoleLogger.starting(name: "Console error logger")) {
    return aSignal is ErrorSignal
}

// will be logged
do { throw(...) } catch { emit(error) }

// won't be logged
emit("A String")
```

The framework provides the following types of signals and loggers:

Signals:
- `ContextSignal` captures execution context where it's created, including stack trace
- `ErrorSignal` captures an error and a stack trace that lead to it
- `StringSignal` for signaling strings - ala traditional logging facilities
- `WrapperSignal` for signaling arbitrary values

Loggers:
- `MemoryLogger` records signals using a FIFO pool
- `ConsoleLogger` prints signals onto the console
- `JRPCLogger` sends signals to a JSON-RPC server (see [Beacon-Server](https://github.com/grype/Beacon-Server/) for a server implementation in Pharo)

The framework is designed to be lightweight and to be easily extended in order to accommodate custom types. See [Implementation Details](Documentation/ImplementationDetails.md) for more info.

## Objective-C

The framework supports both Swift and Objective-C. There are, however, a few language-specific differences between the two. When it comes to emitting signals in Objective-C, the following macros are defined for convenience:

```objective-c
// emit context signal
BeaconEmit(beacons, userInfo);

// emit value
BeaconEmit(someObject, beacons, userInfo);

// emit error
BeaconEmitError(someError, beacons, userInfo);
```

The `beacons` argument expects either `NSArray<Beacon*>*` or nil, implying the shared beacon object.

When it comes to emitting custom signals, you'd have to either provide your own macros, or use this flow:

```objective-c
MySignal *signal = [MySignal new];
BeaconEmitSignal(signal, on: arrayOfBeacons, userInfo: aUserInfoDictionary)
```
