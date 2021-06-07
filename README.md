# Beacon

[![CI](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml/badge.svg)](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml)

Implementation of [Beacon](https://github.com/pharo-project/pharo-beacon) structured logging framework in Swift. The framework distinguishes itself from traditional logging systems by allowing logging of arbitrary objects/values and doing away with log levels in favor of filtering by object/value types. For introduction, see http://www.humane-assessment.com/blog/beacon.

The framework is designed to be lightweight and to be easily extended in order to accommodate custom types. See [Implementation Details](Documentation/ImplementationDetails.md) for more info.


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
    // Start console logger on shared beacon - no need to provide it as argument
    console: ConsoleLogger.starting(name: "Console"),
    
    // Start JSON-RPC logger on shared and dedicated RPC beacons
    rpc: JRPCLogger.starting(url: "http://localhost:4000", method: "emit", name: "JRPC", on: Beacons.shared + Beacons.rpc)
    
    // Start file logger on shared beacon, logging only errors, 
    // capturing them in JSON format, rotating files before they reach 2Mb, 
    // keeping at most 2 backups of log files
    file: { 
        let logger = FileLogger(name: "File", on: URL(fileURLWithPath: "/tmp/my.log"), encoder: SignalJSONEncoder(encoding: .utf8))
        logger.wheel = FileBackupWheel(maxFileSize: 2 * 1024 * 1024, maxNumberOfBackups: 2)
        logger.start { (aSignal) -> Bool in
            return aSignal is ErrorSignal
        }
        return logger
    }()
)

// Emits current context signal, which captures current call stack, on the shared beacon
// This is handled by console + rpc loggers
emit()

// Emits current context on the rpc beacon
// This is handled by RPC logger only
emit(on: Beacons.rpc)

// Emits error signal on the shared beacon
// This is handled by shared + file loggers
emit(error: someError)
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
- `IdentitySignal` for signaling information about Beacon itself - such as version, current platform, architecture, etc
- `MachImageImportsSignal` for signaling addition and removal of MachO images - this is mainly to help with stack symbolication

Custom signals are typically implemented as subclasses of either `SignalLogger` or `WrapperSignal`.

Loggers:
- `MemoryLogger` captures emitted signals in an array
- `ConsoleLogger` prints signals onto the console
- `JRPCLogger` sends signals to a JSON-RPC server (see [Beacon-Server](https://github.com/grype/Beacon-Server/) for a server implementation in Pharo)
- `FileLogger` captures signals in a file, optionally providing a couple of ways to rotate logs:
    - `FileWheel` provides pluggable support for rotating files
    - `FileBackupWheel` provides basic file rotation based on file size and number of backups to keep

Furthermore, there are a couple of abstract loggers: 
- `StreamLogger` writes out signals on an arbitrary `OutputStream` (e.g. `FileLogger`)
- `IntervalLogger` provides buffered interface to writing out signals (e.g. `JRPCLogger`) 


### Stack Symbolication 

A few signals, namely `ErrorSignal` and `ContextSignal`, capture stack traces that lead to the emission of the signal. In some cases, the binary may have its symbols stripped, and those stack traces will need to be symbolicated in order to make any sense of them. To help with that, Beacon uses a combination of `IdentitySignal` and `MachImageImportsSignal`. The former captures the current running environment - operating system and processor architecture, while the latter captures insertion and removal of MachO images whenever the binary loads or unloads external frameworks. Armed with both the architecture and load addresses of the binary and its dependencies it is possible to symbolicate those stack traces with a tool like `atos`.


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
