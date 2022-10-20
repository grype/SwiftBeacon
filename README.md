# Beacon

[![CI](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml/badge.svg)](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml) ![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange)

Structured logging in Swift and Objective-C. The framework distinguishes itself from traditional systems by working with arbitrary values, not just strings, and doing away with severity levels in favor of type-based filtering.

Beacon provides all the essentials for logging any type of value as well as facilities for logging to files and remote machines (via JSON-RPC). It is designed to be easily extended to accommodate custom types and loggers, with out-of-the-box support for buffered and stream-bound logging.

For more information:

* See [this post](http://www.humane-assessment.com/blog/beacon) describing the system that inspired this implementation in Swift.
* Understand the [signal flow](https://github.com/grype/SwiftBeacon/wiki/Signal-flow)
* Learn about [filtering](https://github.com/grype/SwiftBeacon/wiki/Filtering)
* How to [create custom signals](https://github.com/grype/SwiftBeacon/wiki/Creating-Custom-Signals)
* How to [symbolicate stack traces](https://github.com/grype/SwiftBeacon/wiki/Symbolicating-stack-traces)
* ... more on the [Wiki](https://github.com/grype/SwiftBeacon/wiki)


## Using 

Logging with Beacon is a matter of emitting a signal. Let's start by creating a console logger and emitting a few things for it to log (try it in a [Playground](Playground.xcworkspace)):

```swift
// create and start an instance of a console logger
let consoleLogger = ConsoleLogger.starting(name: "Console")

// emit a string, à la print()
emit("A message")

// emit arbitrary value
emit(anything)

// emit an error
do { try something() } catch { emit(error: error) }

// stop logger when done
consoleLogger.stop()
``` 

The framework uses the Observer pattern, in which one or more `SignalLogger`s observe one or more `Beacon`s for emitted `Signal`s. Calling `emit()` creates an appropriate instance of a `Signal` and announces it to one or more `Beacon`s. In the above examples, a shared instance of `Beacon` is implied. However, multiple loggers and beacons can be used:

```swift

extension Beacon {
    static var remote: Beacon = .init()
}

let Loggers = (
    // Starts a console logger on the implied shared beacon
    console: ConsoleLogger.starting(name: "Console"),
    
    // Starts a JSON-RPC logger on both - shared and remote beacons
    remote: JRPCLogger.starting(url: "http://localhost:4000", method: "emit", name: "JRPC", on: [.shared, .remote])
)

// Emits current context signal on the shared beacon
// which get logged by both - console & remote loggers
emit()

// Emits current context only on the remote beacon
// which gets logged only to the remote (JSON-RPC) logger
emit(on: [.remote])
```

Signals can be augmented with arbitrary user info:

```swift
emit(something, userInfo: ["detail" : "Detail Info"])
```

Loggers support single-shot runs:

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
do { throw(...) } catch { emit(error: error) }

// won't be logged
emit("A String")
```

It is also possible to define logging semantics in a more declarative fashion:

```swift
let firstLogger = ConsoleLogger.starting(name: "First logger"))
let secondLogger = ConsoleLogger.starting(name: "Second logger"))

// will disable handling of `StringSignal`s by `secondLogger` regardless of what Beacon the signal came from.
StringSignal.disable(loggingTo: secondLogger, on: nil)

emit("Will only be logged by firstLogger")

// will re-enable handling of StringSignal across all loggers and beacons
StringSignal.enable(loggingTo: nil, on: nil)

emit("Will be logged by both loggers")
```

Doing so avoids having to construct actual `Signal` objects during `emit()` calls, which can be benefitial when e.g. emitting `Encodable` values using `WrapperSignal`, which encodes the wrapped value during initialization of the signal.

##  Components

The framework provides the following building blocks:

| Signal | Description |
| ------ | ----------- |
| `ContextSignal` | Captures execution context at initialization site - e.g. name of containing method and a stack trace |
| `ErrorSignal` | Captures an error and a stack trace that lead to it |
| `StringSignal` | Captures a string - à la traditional logging facilities |
| `WrapperSignal` | Captures arbitrary value - be mindful of mutating values as some of the logging facilities may log at a later time |
| `IdentitySignal` | Captures information about Beacon itself - such as version, current platform, architecture, etc |
| `MachImageImportsSignal` | Captures addition and removal of MachO images - this is mainly to help with stack symbolication |

Custom signals are typically implemented as subclasses of `WrapperSignal` as it provides some helpful machinery, otherwise subclass `Signal` itself.

| Loggers | Description |
| ------- | ----------- |
| `MemoryLogger` | Logs signals into an array of fixed size, in a FIFO fashion |
| `ConsoleLogger` | Prints signals onto the console |
| `JRPCLogger` | Sends signals to a JSON-RPC server (see [Beacon-Server](https://github.com/grype/Beacon-Server/) for a server implementation in Pharo) |
| `FileLogger` | Logs signals to a file, with rotation support |

Furthermore, there are a couple of abstract loggers: 

- `StreamLogger` writes out signals on an arbitrary `OutputStream` (e.g. `FileLogger`)
- `IntervalLogger` provides buffered interface to writing out signals (e.g. `JRPCLogger`) 


### Stack Symbolication 

A few signals, namely `ErrorSignal` and `ContextSignal`, capture stack traces that lead to the emission of the signal. In some cases, the binary may have its symbols stripped, and those stack traces will need to be symbolicated in order to make any sense of them. To help with that, Beacon uses two special signals: `IdentitySignal` and `MachImageImportsSignal`. The former captures the current running environment - operating system and processor architecture, while the latter captures insertion and removal of MachO images. Armed with both the architecture and load addresses of the binary and its dependencies it is possible to symbolicate those stack traces with a tool like `atos`.

It may be helpful to emit those signals as soon as a logger starts:

```
let consoleLogger = ConsoleLogger(name: "Console")

// Will emit IdentitySignal when started
consoleLogger.identifiesOnStart = true

// Will emit MachImageImportsSignal for all loaded MachO images when started 
// and then track subsequently loaded and unloaded images 
consoleLogger.tracksMachImageImports = true

consoleLogger.start() 
```


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

You can find a code snippet to simplify creation of custom signals [here](Xcode/Snippets/MakeSignal.swift). Add it to your existing collection of Xcode snippets, if you're into that sort of thing...

