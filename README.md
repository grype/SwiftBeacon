# Beacon

[![CI](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml/badge.svg)](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml) ![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange)

### Structured logging in Swift and Objective-C

Beacon distinguishes itself from conventional logging systems by working with arbitrary values, not just strings, and doing away with severity levels in favor of type-based filtering.

This framework provides all the essentials for logging any type of value to the console, a file or a remote service. It also provides a broader support for buffered and stream-based logging, making it easy to implement custom logging facilities.

For more information:

* See [this post](http://www.humane-assessment.com/blog/beacon) describing the system that inspired this implementation in Swift.
* Learn the [essentials](https://github.com/grype/SwiftBeacon/wiki/Essentials)
* Understand the [signal flow](https://github.com/grype/SwiftBeacon/wiki/Signal-flow)
* Learn about [filtering](https://github.com/grype/SwiftBeacon/wiki/Filtering)
* How to [create custom signals](https://github.com/grype/SwiftBeacon/wiki/Creating-Custom-Signals)
* How to [symbolicate stack traces](https://github.com/grype/SwiftBeacon/wiki/Symbolicating-stack-traces)
* ... more on the [Wiki](https://github.com/grype/SwiftBeacon/wiki)


## Using 

Logging with Beacon is a matter of starting a logger and emitting a value.

```swift
let consoleLogger = ConsoleLogger.starting(name: "Console")
emit("A message")
``` 

The above is equivalent to printing a time-stamped message to the console, à la conventional logging systems. You are not, however, limited to emitting strings - any type of value can be emitted:

```swift
do { 
	let result: MyThing = try something()
	emit(result)
} catch { 
	emit(error: error) 
}
```

There is no need to specify debug levels - simply emit a value of interest. Beacon lets you control what gets logged and where by means of filters and constraints.

### In a nutshell...


```swift
⓪ let memoryLogger = MemoryLogger(name: "Memory")

① let consoleLogger = ConsoleLogger.starting(name: "Console") { 
②	$0 is StringSignal 
   }

③ Constraint.activate {
	-Signal.self
	+ErrorSignal.self ~> memoryLogger
   }

④ emit()

  do {
⑤	memoryLogger.run {
		let result = try something()
⑥		emit(result, on: [.shared], userInfo: ["detail": "Detail info"])
	 }
  }
  catch {
⑦	emit(error: error)
  }
  
⑧ consoleLogger.stop()
⑨ Constraint.enableAllSignals()
```

⓪ Creates an instance of `MemoryLogger`. This logger simply captures signals into an array, available via the `recordings` property. Notice that this logger isn't running yet.

① Creates and starts a `ConsoleLogger`. This logger simply prints a time-stamped `debugDescription` of the emitted value to the console, similar to how a conventional system logs messages. In contrast to the memory logger created in ⓪ - this logger is running and will process emitted signals. See [Components](#Components) for a list of available loggers.

② The console logger is set to filter out anything that is not a `StringSignal` - that's what actually gets logged when we call `emit("with a string")`. Different types of values are represented by different types of signal, falling back to the `WrapperSignal` for capturing arbitrary values. Signals can be easily extended to accomodate specific types of values and are [portable](wiki/Portability). See [Components](#Components) for a list of available signals.

③ Control the flow of signals by defining constraints. The first constraint disables logging of all types of signals. The second constraint enables logging `ErrorSignal`s, but only by the `memoryLogger`. The effect is that only `ErrorSignal`s will be logged, and only by the `memoryLogger`. By default all types of signals are logger, which is the equivalent of `+Signal.self` as the sole constraint. See [Filtering](https://github.com/grype/SwiftBeacon/wiki/Filtering) for more information on constraints.

④ Calling `emit()` without a value logs the execution context, capturing the stack trace leading to the call. This happens by creating and emitting a `ContextSignal`. Additionally, Beacon provides specialized signals for capturing information needed to [symbolicate those stack traces](wiki/Symbolicating-stack-traces).

⑤ It is possible to perform one-shot logging - that is, starting the logger only for the duration of a block closure.

⑥ Every form of `emit()` takes two additional and optional arguments: a list of `Beacon`s on which to emit a signal (defaulting to `Beacon.shared`), and an arbitrary userInfo value.

⑦ Emits an `ErrorSignal`, wrapping the error. Notice that this variant of `emit()` has a named argument. There is a difference between `emit(anError)`, which will emit a `WrapperSignal`, and `emit(error: anError)`, which would emnit an `ErrorSignal`.

⑧ Since we started the console logger in ①, we should stop it whenever we're done with it.

⑨ Restore constraints back to their defaults.

## Components

The framework provides the following building blocks:

| Signal | Description |
| ------ | ----------- |
| `ContextSignal` | Captures execution context at initialization site - e.g. name of containing method and a stack trace |
| `ErrorSignal` | Captures an error and a stack trace that lead to it |
| `StringSignal` | Captures a string - à la conventional logging systems |
| `WrapperSignal` | Captures arbitrary value - be mindful of mutating values as some of the logging facilities may log at a later time |
| `IdentitySignal` | Captures information about Beacon itself - such as version, current platform, architecture, etc |
| `MachImageImportsSignal` | Captures addition and removal of MachO images - this is mainly to help with stack symbolication |

Custom signals are typically implemented as subclasses of `WrapperSignal` as it provides some helpful machinery on top of the base `Signal` class.

| Loggers | Description |
| ------- | ----------- |
| `MemoryLogger` | Logs signals into an array of fixed size |
| `ConsoleLogger` | Prints signals onto the console |
| `JRPCLogger` | Sends signals to a JSON-RPC server (see [Beacon-Server](https://github.com/grype/Beacon-Server/) for a server implementation in Pharo) |
| `FileLogger` | Logs signals to a file, with rotation support |

Furthermore, there are a couple of abstract loggers: 

- `StreamLogger` writes out signals on an arbitrary `OutputStream` (e.g. `FileLogger`)
- `IntervalLogger` provides buffered interface to writing out signals (e.g. `JRPCLogger`) 


### Stack Symbolication 

A few signals, namely `ErrorSignal` and `ContextSignal`, capture stack traces that lead to the emission of the signal. In some cases, the binary may have its symbols stripped, and those stack traces will need to be symbolicated in order to make any sense of them. To help with that, Beacon uses two special signals: `IdentitySignal` and `MachImageImportsSignal`. The former captures the current running environment - operating system and processor architecture, while the latter captures insertion and removal of MachO images. Armed with both the architecture and load addresses of the binary and its dependencies it is possible to symbolicate those stack traces with a tool like `atos`.

Loggers can be configured to emit those signals:

```swift
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

