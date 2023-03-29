# Filtering

One of the major ideas behind Beacon is the ability to filter signals programmatically and do so with great flexibility. This means being able to filter by arbitrary logic that may include:

* type of a signal
* values captured by a signal
* source of a signal (file, function, class)
* signal's destination - both the beacon object where signals are emitted and the loggers that observe those beacons

## Filtering with loggers

The most direct place to filter signals is at the logger level. All subclasses of `SignalLogger` accept a filter block as their final argument.

For example, to log only errors to the console:

```swift
ConsoleLogger.starting(name: "Console") { $0 is ErrorSignal }
```

We can get more creative here and filter in only errors and any signal that originates from files with a certain path:

```swift
ConsoleLogger.starting(name: "Console") { aSignal in
    if aSignal is ErrorSignal { return true }
    guard let source = aSignal.source else { return false }
    return source.fileName.contains("some/path")
}
```

## Filtering with constraints

Another way of filtering signals is by constraining signals to specific beacons and loggers. This approach makes more sense in the context of a production application, where it may be desirable to limit logging to specific signals until we need to debug specific areas of the application in greater detail. 

For example, to filter out all signals:

```swift
Signal.disable()
```

To filter in string signals across all beacons and loggers:

```swift
StringSignal.enable(constrainedTo: aLogger, on: aBeacon)
```

The two examples above effectively limit logging to just the `StringSignal`s being emitted on a specific logger and beacon.

When handling multiple constraints, its best to interact with actual constraints, as opposed to the convenience methods introduced above. For example:

```swift
extension Beacon {
	static let debug: Beacon = .init()
}

// console logger will run on both shared and debug beacons
let console = ConsoleLogger.starting(name: "Console")

// memory logger will only run on the debug beacon
let memory = MemoryLogger.starting(name: "Memory", on: [.debug])

Constraint.activate {
	-Signal.self							// disables logging of all signals
	+ErrorSignal.self ~> console			// enables error signals only on the console logger
	+StringSignal.self ~> (memory, .debug)	// enables string signals only on memory logger running on the debug beacon
}

// will only be logged by the memory logger
emit("Hello World", on: [.shared, .debug])

// will only be logged by the console logger
emit(error: "OMG" as Error, on: [.shared, .debug])
```

Be mindful that constraint-based filtering takes place before the logger is even given a chance to log a signal. This means that the filtering block that a logger was started with may not be evaluated. Consider this example:

```swift
// Console logger will filter out anything that is not an `ErrorSignal`
let logger = ConsoleLogger.starting(name: "Console") { $0 is ErrorSignal }

// Disables any logging of `ErrorSignal`s
ErrorSignal.disable()

// Won't be logged due to above constraint
emit(error: anError)
```

The key takeaway here is this - use constraint-based filtering when establishing particular behavior(s) - i.e. errors go to the console, specific areas of the application - to a file. Use block-based filtering in ad hoc situations.

## Constraint-based optimizations

Constraints make it possible for Beacon to determine whether a signal will be handled before it is actually constructed, thus reducing the unnecessary overhead of having to create signals and potentially encode its data. Whenever an `emit()` method is called, Beacon will first check whether the signal type, associated with the emitting value, is actually going to be logged by asking `willLog(type:on:)`.

For example:

```swift
willLog(type: Signal.self, on: .shared) 		// true
willLog(type: StringSignal.self, on: shared) 	// true
willLog(type: ErrorSignal.self, on: .shared) 	// true

Constraint.activate {
	-Signal.self
	+ErrorSignal.self
}

willLog(type: Signal.self, on: .shared) 		// false
willLog(type: StringSignal.self, on: shared) 	// false
willLog(type: ErrorSignal.self, on: .shared) 	// true
```

Whenever you find the need to implement your own `emit()` method - be sure to check with `willLog(type:on:)` to make use of this optimization.