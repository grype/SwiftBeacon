# Beacon

[![CI](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml/badge.svg)](https://github.com/grype/SwiftBeacon/actions/workflows/swift.yml) ![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange)

### Structured logging in Swift and Objective-C

Beacon distinguishes itself from conventional logging systems by working with arbitrary values, not just strings, and it does away with severity levels in favor of type-based filtering.

This framework provides all the essentials for logging any value to the  console, files and remote services. It also provides a broader support for buffered and stream-based logging, making it easy to implement custom logging facilities.

For more information:

* See [this post](http://www.humane-assessment.com/blog/beacon) describing the system that inspired this implementation in Swift.
* Learn the [essentials](https://github.com/grype/SwiftBeacon/wiki/Essentials)
* Understand the [signal flow](https://github.com/grype/SwiftBeacon/wiki/Signal-flow)
* Learn about [filtering](https://github.com/grype/SwiftBeacon/wiki/Filtering)
* How to [create custom signals](https://github.com/grype/SwiftBeacon/wiki/Creating-Custom-Signals)
* How to [symbolicate stack traces](https://github.com/grype/SwiftBeacon/wiki/Symbolicating-stack-traces)
* ... more on the [Wiki](https://github.com/grype/SwiftBeacon/wiki)


## Using 

Logging with Beacon happens by starting one or more loggers and emitting some values.

```swift
let consoleLogger = ConsoleLogger.starting(name: "Console")
emit("A message")
``` 

The above example is equivalent to printing a time-stamped message to the console, à la conventional logging systems. However, you are not limited to emitting strings - any value can be emitted:

```swift
do { 
	let result: MyThing = try something()
	emit(result)
} catch { 
	emit(error: error) 
}
```

There is no need to specify debug levels - simply emit a value you're interested in. Beacon allows you to control what is being logged by means of filters and constraints.

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

① Creates and starts a `ConsoleLogger`. This logger simply prints a time-stamped `debugDescription` of the emitted value to the console, similar to how a conventional system logs messages. In contrast to the memory logger created in ⓪ - this logger is running and will log emitted signals. See [Components](#Components) for a list of available loggers.

② The console logger is set to filter out anything that is not a `StringSignal` - this is the object that actually gets logged when we call `emit("with a string")`. Different types of values are represented by different signal types, falling back to `WrapperSignal` for capturing arbitrary values. Signals are designed to be portable - meaning, they can be represented by remote systems. This makes it easy to adopt existing technologies. See [Components](#Components) for a list of available signals. You can easily create custom signal types for capturing specific types of values.

③ Control which signals are logged by what facilities by defining constraints. The first constraint disables logging of all types of signals, while the second - enables logging of `ErrorSignal`s but only by the `memoryLogger`. By default Beacon enables logging of all types of signals - equivalent of `+Signal.self` as the sole constraint. See [Filtering](https://github.com/grype/SwiftBeacon/wiki/Filtering) for more information on constraint-based filtering.

④ Calling `emit()` without a value logs curent context, including the stack trace leading to the call. This happens by creating and emitting an instance of `ContextSignal`. Beacon provides specialized signals for capturing information to help in symbolication of stack traces.

⑤ It is possible to perform one-shot logging - that is, starting the logger only for the duration of the passed block. It doesn't mean other running loggers won't handle emitted signals. In this example, the `memoryLogger` won't be doing any more logging outside of the given block.

⑥ Every form of `emit()` allows passing a list of `Beacon` objects on which to emit the resulting signal. Not specifying one implies a special shared beacon (accessible via `Beacon.shared`). It is also possible to pass along userInfo values, similar to how this is done with `NSNotification`s.

⑦ Emits an `ErrorSignal`, which captures the given error. Notice that this variant of `emit()` has a named argument. This is done for convenience as any object can be made to conform to `Error`. There is a difference between `emit(anError)` and `emit(error: anError)` - in the former case - a `WrapperSignal` is created, while in the latter case - an `ErrorSignal` is created.

⑧ Since we started the console logger in ①, we should stop it whenever we're done using it.

⑨ Restores constraints back to their defaults.

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

Custom signals are typically implemented as subclasses of `WrapperSignal` as it provides some helpful machinery, otherwise subclass `Signal` itself.

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

