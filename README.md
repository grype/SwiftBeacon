# Beacon

Implementation of [Beacon](https://github.com/pharo-project/pharo-beacon) structured logging framework in Swift. The framework distinguishes itself from traditional logging systems by allowing logging of arbitrary objects/values and doing away with log levels in favor of filtering by object/value types. For introductory information on Beacon, see http://www.humane-assessment.com/blog/beacon.

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
do { try something() } catch { emit(error: error) }

consoleLogger.stop()
``` 

The framework uses the Observer pattern, with `SignalLogger`s observing `Beacon`s for emitted `Signal`s. Calling `emit()` creates an appropriate instance of a `Signal` and announces it to one or more `Beacon`s. In the above examples, a shared instance of `Beacon` is implied. However, multiple loggers and beacons can be used:

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

The framework provides the following building blocks:

Signals:
- `ContextSignal` captures execution context where it's created, including stack trace
- `ErrorSignal` captures an error and a stack trace that lead to it
- `StringSignal` for signaling strings - ala traditional logging facilities
- `WrapperSignal` for signaling arbitrary values

Custom signals can be implemented as subclasses of `SignalLogger` or `WrapperSignal`.

Loggers:
- `MemoryLogger` captures emitted signals in an array
- `ConsoleLogger` prints signals onto the console
- `FileLogger` captures signals in a file (file rotation supported)
- `JRPCLogger` sends signals to a JSON-RPC server (see [Beacon-Server](https://github.com/grype/Beacon-Server/) for a server implementation in Pharo)

Furthermore, there are a couple of abstract loggers: 
- `StreamLogger` writes out signals on an arbitrary `OutputStream` (e.g. `FileLogger`)
- `IntervalLogger` provides buffered interface to writing out signals (e.g. `JRPCLogger`)

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

## Xcode Goodies

To simplify creation of custom signal classes, there exists a code snippet that can be added to Xcode's snippet library. You will find it in [Xcode/Snippets/MakeSignal.swift](Xcode/Snippets/MakeSignal.swift)
